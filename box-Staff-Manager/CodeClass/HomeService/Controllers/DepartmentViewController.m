//
//  DepartmentViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "DepartmentViewController.h"
#import "DepartmentTableViewCell.h"
#import "DepartmentModel.h"
#import "AddDepartmentViewController.h"
#import "DepartmentDetailViewController.h"


#define PageSize  12
#define CellReuseIdentifier  @"Department"

@interface DepartmentViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,AddDepartmentDelegate,JXMovableCellTableViewDataSource, JXMovableCellTableViewDelegate>

@property (nonatomic,strong) JXMovableCellTableView *tableView;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *addDepartmentView;
@property (nonatomic,strong) UILabel *addDepartmentLab;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation DepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = DepartmentVCTitle;
    _aWrapper = [[DDRSAWrapper alloc] init];
    _sourceArray = [[NSMutableArray alloc] init];
    [self createView];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshBranchListAction:) name:@"refleshBranchList" object:nil];
}

-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/branch/list" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [_sourceArray removeAllObjects];
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *listDic in listArray) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithDict:listDic];
                [_sourceArray addObject:model];
            }
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self reloadAction];
    }];
}

-(void)reloadAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark ----- createBarItem -----
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
}

#pragma mark ----- backAction -----
-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createView
{
    [self createBarItem];
    if ([[BoxDataManager sharedManager].depth isEqualToString:@"0"]) {
        [self createViewForOneDepth];
    }else{
        _tableView = [[JXMovableCellTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[DepartmentTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.gestureMinimumPressDuration = 0.5;
        _tableView.canScroll = NO;
        _tableView.drawMovalbeCellBlock = ^(UIView *movableCell){
            movableCell.layer.shadowColor = [UIColor grayColor].CGColor;
            movableCell.layer.masksToBounds = NO;
            movableCell.layer.cornerRadius = 0;
            movableCell.layer.shadowOffset = CGSizeMake(-5, 0);
            movableCell.layer.shadowOpacity = 0.4;
            movableCell.layer.shadowRadius = 5;
        };
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.right.offset(-0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
    }
}

-(void)createViewForOneDepth
{
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:238.0/255.0 blue:253.0/255.0 alpha:1.0];
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kTopHeight);
        make.left.right.offset(0);
        make.height.offset(35);
    }];
    
    UILabel *laber = [[UILabel alloc]init];
    laber.font = Font(12);
    laber.textColor = [UIColor colorWithHexString:@"#4c7afd"];
    laber.text = DepartmentVCTopTitle;
    [_topView addSubview:laber];
    [laber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(15);
        make.right.offset(-50);
    }];
    
    UIImageView *cancelImg = [[UIImageView alloc] init];
    cancelImg.image = [UIImage imageNamed:@"icon_delete_blue"];
    [_topView addSubview:cancelImg];
    [cancelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(laber);
        make.right.offset(-15);
        make.width.offset(12);
        make.height.offset(12);;
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(laber);
        make.right.offset(-12);
        make.top.bottom.offset(0);
        make.width.offset(35);
    }];
    
    _addDepartmentView = [[UIView alloc] init];
    _addDepartmentView.backgroundColor = kWhiteColor;
    [self.view addSubview:_addDepartmentView];
    [_addDepartmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(_topView.mas_bottom).offset(0);
        make.right.offset(-0);
        make.height.offset(51);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_addDepartmentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_addDepartmentView.mas_bottom).offset(-1);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
    
    _addDepartmentLab = [[UILabel alloc]init];
    _addDepartmentLab.font = Font(15);
    _addDepartmentLab.textColor = [UIColor colorWithHexString:@"#4c7afd"];
    _addDepartmentLab.attributedText = [self createAttributedText:DepartmentVCAddDepartment];
    [_addDepartmentView addSubview:_addDepartmentLab];
    [_addDepartmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(15);
        make.right.offset(0);
    }];
    
    _addDepartmentView.userInteractionEnabled = YES;
    _addDepartmentLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *addDepartmentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addDepartmentAction:)];
    [_addDepartmentLab addGestureRecognizer:addDepartmentTap];
 
    _tableView = [[JXMovableCellTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[DepartmentTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.gestureMinimumPressDuration = 0.5;
    _tableView.drawMovalbeCellBlock = ^(UIView *movableCell){
        movableCell.layer.shadowColor = [UIColor grayColor].CGColor;
        movableCell.layer.masksToBounds = NO;
        movableCell.layer.cornerRadius = 0;
        movableCell.layer.shadowOffset = CGSizeMake(-5, 0);
        movableCell.layer.shadowOpacity = 0.4;
        movableCell.layer.shadowRadius = 5;
    };
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(_addDepartmentView.mas_bottom).offset(0);
        make.right.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [self headerReflesh];
}



#pragma mark ----- AddDepartmentDelegate -----
- (void)addDepartmentReflesh
{
   [self.tableView.mj_header beginRefreshing];
}

-(void)refleshBranchListAction:(NSNotification *)notification
{
    [self requestData];
}

#pragma mark ----- add department -----
-(void)addDepartmentAction:(UITapGestureRecognizer *)tap
{
    AddDepartmentViewController *addDepartmentVc = [[AddDepartmentViewController alloc] init];
    addDepartmentVc.delegate = self;
    addDepartmentVc.type = DepartmentAddType;
    [self.navigationController pushViewController:addDepartmentVc animated:YES];
}

#pragma mark ----- create NSMutableAttributedString -----
-(NSMutableAttributedString *)createAttributedText:(NSString *)str
{
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",  str]];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4c7afd"] range:NSMakeRange(0, str.length + 1)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"icon_add employ"];
    attch.bounds = CGRectMake(0, -0.5, 13.5, 13.5);
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    //[attri appendAttributedString:string];
    //将图片放在第一位
    [attri insertAttributedString:string atIndex:0];
    return attri;
}

#pragma mark ----- cancel topView -----
-(void)cancelBtnAction:(UIButton *)button
{
    [_topView removeFromSuperview];
    [_addDepartmentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(kTopHeight);
        make.right.offset(-0);
        make.height.offset(51);
    }];
}

#pragma mark ----- MJRefreshHeader -----
-(void)headerReflesh
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    DepartmentModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:delete handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:SureToDelete preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:Affirm style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self deleteDepartment:indexPath];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    DepartmentModel *model = self.sourceArray[indexPath.row];
    if ([[BoxDataManager sharedManager].depth isEqualToString:@"0"]) {
        if (model.ID == 1) {
            return @[];
        }else{
            return @[action1];
        }
    }else{
        return @[];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepartmentModel *model = self.sourceArray[indexPath.row];
    DepartmentDetailViewController *departmentDetailVc = [[DepartmentDetailViewController alloc] init];
    departmentDetailVc.model = model;
    [self.navigationController pushViewController:departmentDetailVc animated:YES];
}

- (NSMutableArray *)dataSourceArrayInTableView:(JXMovableCellTableView *)tableView
{
    return self.sourceArray;
}

#pragma mark ----- delete department -----
-(void)deleteDepartment:(NSIndexPath *)indexPath
{
    DepartmentModel *model = self.sourceArray[indexPath.row];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:[NSString stringWithFormat:@"%ld", model.ID] privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:@"" forKey:@"new_name"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:@(model.ID) forKey:@"bid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/branch/change" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [self.sourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
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
