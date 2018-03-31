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


#define HomeDirectoryVCTitle  @"地址簿"
#define HomeDirectoryVCAddAddress  @"新增地址"
#define CellReuseIdentifier  @"HomeDirectory"


@interface HomeDirectoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UIView *viewLayer;
@property (nonatomic,strong)UILabel *topTitleLab;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

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
//    @property (nonatomic,strong) NSString *currency;
//    @property (nonatomic,strong) NSString *nameTitle;
//    @property (nonatomic,strong) NSString *address;
//    @property (nonatomic,strong) NSString *remark;
    
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"currency":@"BTC", @"nameTitle":@"二秒科技",@"remark":@"黄大大",@"address":@"0xb2ed7ceaebd98686cb9310a32d93e91044a580a6"},
                                   @{@"currency":@"BTC", @"nameTitle":@"二秒科技",@"remark":@"黄大大",@"address":@"0xb2ed7ceaebd98686cb9310a32d93e91044a580a6"},
                                   @{@"currency":@"BTC", @"nameTitle":@"二秒科技",@"remark":@"黄大大",@"address":@"0xb2ed7ceaebd98686cb9310a32d93e91044a580a6"},
                                   @{@"currency":@"BTC", @"nameTitle":@"二秒科技",@"remark":@"黄大大",@"address":@"0xb2ed7ceaebd98686cb9310a32d93e91044a580a6"},
                                   @{@"currency":@"BTC", @"nameTitle":@"二秒科技",@"remark":@"黄大大",@"address":@"0xb2ed7ceaebd98686cb9310a32d93e91044a580a6"},
                                   @{@"currency":@"BTC", @"nameTitle":@"二秒科技",@"remark":@"黄大大",@"address":@"0xb2ed7ceaebd98686cb9310a32d93e91044a580a6"},
                                   @{@"currency":@"BTC", @"nameTitle":@"二秒科技",@"remark":@"黄大大",@"address":@"0xb2ed7ceaebd98686cb9310a32d93e91044a580a6"}
                                   ]
                           
                           };
    
    
    for (NSDictionary *dataDic in dict[@"data"]) {
        HomeDirectoryModel *model = [[HomeDirectoryModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
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
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
    [_tableView registerClass:[HomeDirectoryTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self footerReflesh];
    [self headerReflesh];
}


-(void)footerReflesh
{
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self requestData];
    }];
    
    
}

-(void)headerReflesh
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
    }];
}

-(void)requestData
{
    
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
    //    ApprovalBusinessModel *model = self.sourceArray[indexPath.row];
    //    ApprovalDetailViewController *approvalDetailVC = [[ApprovalDetailViewController alloc] init];
    //    approvalDetailVC.model = model;
    //    [self.navigationController pushViewController:approvalDetailVC animated:YES];
}






#pragma mark - createBarItem
- (void)createBarItem{
    //UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    //self.navigationItem.leftBarButtonItem = buttonLeft;
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:HomeDirectoryVCAddAddress style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#666666"];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15), NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}

#pragma mark ----- rightBarButtonItemAction -----
- (void)rightButtonAction:(UIBarButtonItem *)buttonItem{
    AddDirectoryViewController *addDirectoryVC = [[AddDirectoryViewController alloc] init];
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
    
    _topTitleLab = [[UILabel alloc] init];
    _topTitleLab.textAlignment = NSTextAlignmentCenter;
    _topTitleLab.font = Font(16);
    _topTitleLab.attributedText = [self attributedStringWithImage:@"BTC"];
    _topTitleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _topTitleLab.numberOfLines = 1;
    [_viewLayer addSubview:_topTitleLab];
    [_topTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_viewLayer);
        make.centerX.equalTo(_viewLayer);
        make.height.offset(30);
        make.width.offset(100);
    }];
    UITapGestureRecognizer *topTitleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topTitleTapAction:)];
    _viewLayer.userInteractionEnabled = YES;
    [_viewLayer addGestureRecognizer:topTitleTap];
    
}


#pragma mark ----- topTitleTapAction -----
-(void)topTitleTapAction:(UITapGestureRecognizer *)tap
{
    
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
