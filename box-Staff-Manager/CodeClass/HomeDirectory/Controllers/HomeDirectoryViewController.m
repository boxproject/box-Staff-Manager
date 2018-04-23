//
//  HomeDirectoryViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeDirectoryViewController.h"
#import "HomeDirectoryTableViewCell.h"
#import "HomeDirectoryModel.h"
#import "AddDirectoryViewController.h"
#import "EditorDirectoryViewController.h"
#import "CurrencyView.h"

#define HomeDirectoryVCTitle  @"地址簿"
#define HomeDirectoryVCAddAddress  @"新增地址"
#define CellReuseIdentifier  @"HomeDirectory"

@interface HomeDirectoryViewController ()<UITableViewDelegate, UITableViewDataSource,CurrencyViewDelegate>

@property (nonatomic,strong) UIView *viewLayer;
@property (nonatomic,strong)UILabel *topTitleLab;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong)UILabel *labelTip;
@property (nonatomic,strong)CurrencyView *currencyView;

@end

@implementation HomeDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createTitleView];
    [self createBarItem];
    [self createView];
    if ([_type isEqualToString:@"getAddress"]) {
        _sourceArray = [[DirectoryManager sharedManager] loadDBDirectoryData:_model.currency];
    } 
    [self.tableView reloadData];
    if (_sourceArray.count == 0) {
        _labelTip.hidden = NO;
    }else{
        _labelTip.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyListAction:) name:@"currencyList" object:nil];
}

-(void)currencyListAction:(NSNotification *)notification
{
    CurrencyModel *model = notification.object;
    _sourceArray = [[DirectoryManager sharedManager] loadDBDirectoryData:model.currency];
    [self.tableView reloadData];
    if (_sourceArray.count == 0) {
        _labelTip.hidden = NO;
    }else{
        _labelTip.hidden = YES;
    }
    _model = model;
    _topTitleLab.attributedText = [self attributedStringWithImage:model.currency];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.right.offset(-0);
        if ([_type isEqualToString:@"getAddress"]) {
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }else{
            make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
        }
    }];
    [_tableView registerClass:[HomeDirectoryTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _labelTip = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 30)];
    _labelTip.text = @"还未新增地址";
    _labelTip.textAlignment = NSTextAlignmentCenter;
    _labelTip.textColor = [UIColor colorWithHue:0.00 saturation:0.00 brightness:0.66 alpha:1.00];
    _labelTip.font = [UIFont systemFontOfSize:17];
    _labelTip.hidden = YES;
    [_tableView addSubview:_labelTip];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeDirectoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    HomeDirectoryModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model integer:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == nil) {
        return;
    }
    HomeDirectoryModel *model = self.sourceArray[indexPath.row];
    self.addressBlock(model.address);
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        HomeDirectoryModel *model =_sourceArray[indexPath.row];
        EditorDirectoryViewController *editorDirectoryVC = [[EditorDirectoryViewController alloc] init];
        editorDirectoryVC.currencyBlock = ^(NSString *currency){
            _topTitleLab.attributedText = [self attributedStringWithImage:currency];
            [_sourceArray removeAllObjects];
            _sourceArray = [[DirectoryManager sharedManager] loadDBDirectoryData:currency];
            [self.tableView reloadData];
            if (_sourceArray.count == 0) {
                _labelTip.hidden = NO;
            }else{
                _labelTip.hidden = YES;
            }
        };
        editorDirectoryVC.hidesBottomBarWhenPushed = YES;
        editorDirectoryVC.model = model;
        [self.navigationController pushViewController:editorDirectoryVC animated:YES];
        
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            HomeDirectoryModel *model =_sourceArray[indexPath.row];
            BOOL isOK = [[DirectoryManager sharedManager] deleteDirectoryModel:model];
            if (isOK) {
                // 删除模型
                [self.sourceArray removeObjectAtIndex:indexPath.row];
                // 刷新
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                if (_sourceArray.count == 0) {
                    _labelTip.hidden = NO;
                }else{
                    _labelTip.hidden = YES;
                }
            }
        }];
        [alert addAction:actionOk];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    return @[action1, action0];
}

#pragma mark - createBarItem
- (void)createBarItem{
    if ([_type isEqualToString:@"getAddress"]) {
        UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
        self.navigationItem.leftBarButtonItem = buttonLeft;
    }
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:HomeDirectoryVCAddAddress style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#666666"];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15), NSFontAttributeName, nil] forState:UIControlStateNormal];
}

#pragma mark ----- rightBarButtonItemAction -----
- (void)rightButtonAction:(UIBarButtonItem *)buttonItem{
    AddDirectoryViewController *addDirectoryVC = [[AddDirectoryViewController alloc] init];
    addDirectoryVC.currencyBlock = ^(NSString *currency){
        _topTitleLab.attributedText = [self attributedStringWithImage:currency];
        [_sourceArray removeAllObjects];
        _sourceArray = [[DirectoryManager sharedManager] loadDBDirectoryData:currency];
        [self.tableView reloadData];
        if (_sourceArray.count == 0) {
            _labelTip.hidden = NO;
        }else{
            _labelTip.hidden = YES;
        }
    };
    addDirectoryVC.currency = _model.currency;
    addDirectoryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addDirectoryVC animated:YES];
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableAttributedString *)attributedStringWithImage:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"%@%@", string, HomeDirectoryVCTitle];
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", str]];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, str.length + 1)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"icon_pulldown_gray"];
    attch.bounds = CGRectMake(7, 0.5, 12, 9);
    //创建带有图片的富文本
    NSAttributedString *stringAt = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    //[attri appendAttributedString:string];
    //将图片放在第一位
    [attri insertAttributedString:stringAt atIndex:str.length];
    return attri;
}

-(void)createTitleView
{
    _viewLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _viewLayer.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = self.viewLayer;
    
    _topTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _topTitleLab.textAlignment = NSTextAlignmentCenter;
    _topTitleLab.font = Font(16);
    if ([_type isEqualToString:@"getAddress"]) {
        _topTitleLab.attributedText = [self attributedStringWithImage:_model.currency];
    }else{
        _topTitleLab.attributedText = [self attributedStringWithImage:@"BTC"];
    }
    //_topTitleLab.attributedText = [self attributedStringWithImage:@"BTC"];
    _topTitleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _topTitleLab.numberOfLines = 1;
    [_viewLayer addSubview:_topTitleLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 30);
    [button addTarget:self action:@selector(topTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_viewLayer addSubview:button];
}

#pragma mark ----- topTitleTapAction -----
-(void)topTitleAction:(UIButton *)btn
{
    _currencyView = [[CurrencyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _currencyView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_currencyView];
}

#pragma mark ----- CurrencyViewDelegate -----
- (void)didSelectItem:(CurrencyModel *)model
{
    _model = model;
    _topTitleLab.attributedText = [self attributedStringWithImage:model.currency];
    [_sourceArray removeAllObjects];
    _sourceArray = [[DirectoryManager sharedManager] loadDBDirectoryData:model.currency];
    [self.tableView reloadData];
    if (_sourceArray.count == 0) {
        _labelTip.hidden = NO;
    }else{
        _labelTip.hidden = YES;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
