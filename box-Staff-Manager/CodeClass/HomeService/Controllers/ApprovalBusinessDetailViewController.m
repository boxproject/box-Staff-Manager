//
//  ApprovalBusinessDetailViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessDetailViewController.h"
#import "ApprovalBusinessCollectionReusableView.h"
#import "ApprovalBusinessCollectionViewCell.h"
#import "ApprovalBusinessDetailModel.h"
#import "ApprovalBusApproversModel.h"
#import "ApprovalBusinessTopView.h"
#import "ApprovalBusinessFooterView.h"
#import "PrivatePasswordView.h"
#import "LoginBoxViewController.h"
#import "ViewApprovalLogViewController.h"

#define CellReuseIdentifier  @"ApprovalBusinessDetail"
#define headerReusableViewIdentifier  @"ApprovalBusinessDetail"

@interface ApprovalBusinessDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApprovalBusinessTopDelegate,ApprovalBusinessFooterDelegate,PrivatePasswordViewDelegate>
{
    NSInteger pendingNum;
    NSString *language;
} 
@property(nonatomic, strong)ApprovalBusinessTopView *approvalBusinessTopView;
@property(nonatomic, strong)ApprovalBusinessFooterView *approvalBusinessFooterView;
//布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *approvaledInfoArray;
@property(nonatomic, strong)UIButton *approvalStateBtn;
@property(nonatomic, strong)PrivatePasswordView *privatePasswordView;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation ApprovalBusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = ApprovalBusinessDetailTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    [self createBarItem];
    _aWrapper = [[DDRSAWrapper alloc] init];
    _approvaledInfoArray = [[NSMutableArray alloc] init];
    [self layoutCollectionView];
    [self createCollectionView:0];
    [self requestData];
    language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
}


#pragma mark ----- 布局 -----
-(void)layoutCollectionView
{
    _collectionFlowlayout = [[UICollectionViewFlowLayout alloc] init];
    //item大小
    _collectionFlowlayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 22 - 37 - 13 - 6*3)/4, 35);
    // 最小列间距
    _collectionFlowlayout.minimumInteritemSpacing = 6;
    // 最小行间距
    _collectionFlowlayout.minimumLineSpacing = 10;
    // 分区内容边间距（上，左， 下， 右）；
    _collectionFlowlayout.sectionInset = UIEdgeInsetsMake(8, 37, 8, 13);
    // 滑动方向
    //_flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //_assoFlowlayout.scrollDirection = NO;
}

#pragma mark - 添加群列表
-(void)createCollectionView:(CGFloat)currencyFloat
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11, 8,  SCREEN_WIDTH - 22, SCREEN_HEIGHT - 8 - kTopHeight + (-kTabBarHeight + 49)) collectionViewLayout:_collectionFlowlayout];
    [_collectionView registerClass:[ApprovalBusinessCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator =NO;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _collectionView.contentInset = UIEdgeInsetsMake(72 + 39 + 10 + currencyFloat, 0, 0, 0);
    _approvalBusinessTopView = [[ApprovalBusinessTopView alloc] initWithFrame: CGRectMake(0, -72 - 39  - 10 - currencyFloat, SCREEN_WIDTH - 22, 72 + 39  + 10 + currencyFloat) dic:nil];
    _approvalBusinessTopView.delegate = self;
    [_collectionView addSubview: _approvalBusinessTopView];
    [_collectionView registerClass:[ApprovalBusinessCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier];
    [self.view addSubview:_collectionView];
}

#pragma mark  ----- ApprovalBusinessTopDelegate -----
- (void)queryForLimitTime
{
   [self showProgressWithMessage:LimitAlertContent title:LimitAlertTitle actionWithTitle:LimitAlertAffirm];
}

-(void)showProgressWithMessage:(NSString *)message title:(NSString *)title actionWithTitle:(NSString *)actionWithTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:actionWithTitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark  ----- UICollectionViewDataSource -----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ApprovalBusinessDetailModel *model = _approvaledInfoArray[section];
    return model.approvers.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _approvaledInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ApprovalBusinessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    ApprovalBusinessDetailModel *approvalBusinessDetailModel = _approvaledInfoArray[indexPath.section];
    ApprovalBusApproversModel *model = approvalBusinessDetailModel.approvers[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width - 22, 30);
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ApprovalBusinessCollectionReusableView* reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier forIndexPath:indexPath];
    ApprovalBusinessDetailModel *approvalBusinessDetailModel = _approvaledInfoArray[indexPath.section];
    reusableView.model = approvalBusinessDetailModel;
    [reusableView setDataWithModel:approvalBusinessDetailModel index:indexPath.section];
    return reusableView;
}

#pragma mark ----- ViewLog -----
- (void)enterViewLog
{
    ViewApprovalLogViewController *viewLogVC = [[ViewApprovalLogViewController alloc] init];
    viewLogVC.hashString = _model.flow_id;
    UINavigationController *viewLogNC = [[UINavigationController alloc] initWithRootViewController:viewLogVC];
    [self presentViewController:viewLogNC animated:YES completion:nil];
}

#pragma mark ----- 作废审批流 -----
- (void)cancelApprovalBusiness
{
    if (pendingNum == 0) {
        [self showAlertWith:ApprovalCancelAlertTitleOne message:ApprovalCancelAlertMessageOne];
    }else{
        if ([language isEqualToString: @"en"]) {
            [self showAlertWith:[NSString stringWithFormat:@"%ld Pending Transfers", pendingNum] message:ApprovalCancelAlertMessageTwo];
        }else{
            [self showAlertWith:[NSString stringWithFormat:@"该审批流有%ld个正在进行中的转账申请", pendingNum] message:ApprovalCancelAlertMessageTwo];
        }
        //[self showAlertWith:ApprovalCancelAlertTitleTwo message:ApprovalCancelAlertMessageTwo];
    }
}

-(void)showAlertWith:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:Affirm style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        _privatePasswordView = [[PrivatePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _privatePasswordView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_privatePasswordView];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ----- PrivatePasswordViewDelegate -----
- (void)PrivatePasswordViewDelegate:(NSString *)passwordStr
{
    [self handleApprovalApplicationCancel:passwordStr];
}

#pragma mark ----- Cancel Approval Flow -----
-(void)handleApprovalApplicationCancel:(NSString *)passwordStr
{
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:_model.flow_name privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    NSString *hmacSHA256 = [UIARSAHandler hmac: passwordStr withKey:[BoxDataManager sharedManager].encryptKey];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_model.flow_id forKey:@"flow_id"];
    [paramsDic setObject:hmacSHA256 forKey:@"password"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/business/flow/disuse" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [self showProgressWithMessage:dict[@"message"]];
            [_privatePasswordView removeFromSuperview];
            [_approvalBusinessTopView setValueWithtateCancel];
            [_approvalBusinessFooterView setValueWithProgress:ApprovalCancel type:ApprovalFooterFlowCancel];
        }else{
            //code == 1018时提示解冻时间戳
            if ([dict[@"code"] integerValue] == 1018) {
                if ([BoxDataManager sharedManager].launchState == LoginState) {
                    return ;
                }
                [ProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%@", AccountLockup, [self getElapseTimeToString:[dict[@"data"][@"frozenTo"] integerValue]]] code:[dict[@"code"] integerValue]];
                LoginBoxViewController *loginVc = [[LoginBoxViewController alloc] init];
                loginVc.fromFunction = FromAppDelegate;
                [self presentViewController:loginVc animated:YES completion:nil];
                [[BoxDataManager sharedManager] saveDataWithCoding:@"launchState" codeValue:@"2"];
            }
            //输入密码错误且未被冻结
            else if ([dict[@"code"] integerValue] == 1016) {
                [ProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%ld%@%@%ld%@", AccountPasswordError,[dict[@"data"][@"frozenFor"] integerValue], AccountPasswordHour, AccountPasswordAlert,[dict[@"data"][@"attempts"] integerValue], AccountPasswordTimes] code:[dict[@"code"] integerValue]];
            }else{
                [self showProgressWithMessage:dict[@"message"]];
            }
        }
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
}

-(void)showProgressWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:Affirm style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)getElapseTimeToString:(NSInteger)second{
    NSDateFormatter  *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval1 = second;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval1];
    NSString *dateStr1=[dateformatter1 stringFromDate:date1];
    return dateStr1;
}

#pragma mark ----- 数据请求 -----
-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_model.flow_id forKey:@"flow_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/business/flow/info" params:paramsDic success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            //NSInteger progress = [responseObject[@"data"][@"progress"] integerValue];
            //[self showBtnApprovalState:progress];
            //NSString *single_limit = responseObject[@"data"][@"single_limit"];
            NSString *flow_name = responseObject[@"data"][@"flow_name"];
            NSString *createdBy = responseObject[@"data"][@"createdBy"];
            pendingNum = [responseObject[@"data"][@"pending_tx_num"] integerValue];
            NSString *period = responseObject[@"data"][@"period"];
            NSArray *flowLimitArr = responseObject[@"data"][@"flow_limit"];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic  setObject:responseObject[@"data"][@"progress"] forKey:@"progress"];
            [mutableDic  setObject:flow_name forKey:@"flow_name"];
            [mutableDic  setObject:flowLimitArr forKey:@"flow_limit"];
            [mutableDic  setObject:period forKey:@"period"];
            [self headertViewChange:flowLimitArr.count * 30];
            [_approvalBusinessTopView setValueWithData:mutableDic ];
            NSArray *approvaled_infoArr = responseObject[@"data"][@"approval_info"];
            [self footerViewChange:approvaled_infoArr createdBy:createdBy progress:[responseObject[@"data"][@"progress"] integerValue] headFloat:flowLimitArr.count * 30];
            for (NSDictionary *dic in approvaled_infoArr) {
                ApprovalBusinessDetailModel *model = [[ApprovalBusinessDetailModel alloc] initWithDict:dic];
                [_approvaledInfoArray addObject:model];
            }
        }else{
            [ProgressHUD showErrorWithStatus:responseObject[@"message"] code:[responseObject[@"code"] integerValue]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)headertViewChange:(CGFloat)headFloat
{
    _collectionView.contentInset = UIEdgeInsetsMake(72 + 39 + 10 + headFloat, 0, 0, 0);
    _approvalBusinessTopView.frame = CGRectMake(0, -72 - 39  - 10 - headFloat, SCREEN_WIDTH - 22, 72 + 39  + 10 + headFloat);
}

-(void)footerViewChange:(NSArray *)array createdBy:(NSString *)createdBy progress:(NSInteger)progress headFloat:(CGFloat)headFloat
{
    CGFloat aa = 0.0;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dic = array[0];
        ApprovalBusinessDetailModel *model = [[ApprovalBusinessDetailModel alloc] initWithDict:dic];
        NSInteger approversAll = 0;
        NSInteger approversIn = model.approvers.count % 4;
        if (approversIn >= 1) {
            approversAll = model.approvers.count / 4 + 1;
        }
        aa = aa + 30 + approversAll * 45 + 10;
    }
    CGFloat height = 60;
    NSInteger type = 0;
    if ([[BoxDataManager sharedManager].app_account_id isEqualToString:createdBy] && progress == ApprovalSucceed) {
        height = 110;
        type = 1;
    }
    _collectionView.contentInset = UIEdgeInsetsMake(72 + 39 + 10 + headFloat, 0, height + 50, 0);
    _approvalBusinessFooterView = [[ApprovalBusinessFooterView alloc] initWithFrame: CGRectMake(0,aa, SCREEN_WIDTH - 22, height)];
    [_approvalBusinessFooterView setValueWithStatus:type];
    _approvalBusinessFooterView.delegate = self;
    [_collectionView addSubview: _approvalBusinessFooterView];
}

-(void)showBtnApprovalState:(NSInteger)progress
{
    switch (progress) {
        case ApprovalAwait:
            [_approvalStateBtn setTitle:ApprovalBusinessAwait forState:UIControlStateNormal];
            break;
        case Approvaling:
            [_approvalStateBtn setTitle:ApprovalBusinessApprovaling forState:UIControlStateNormal];
            break;
        case ApprovalFail:
            [_approvalStateBtn setTitle:ApprovalBusinessFail forState:UIControlStateNormal];
            break;
        case ApprovalSucceed:
            [_approvalStateBtn setTitle:ApprovalBusinessSucceed forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = [UIColor colorWithHexString:@"#292e40"];;
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [redColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
