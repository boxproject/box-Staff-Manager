//
//  TransferAwaitDetailViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferAwaitDetailViewController.h"
#import "TransferTopView.h"
#import "TransferCollectionViewCell.h"
#import "TransferCollectionReusableView.h"
#import "TransferCollectionViewCell.h"
#import "TransferModel.h"
#import "TransferApproversModel.h"
#import "UIARSAHandler.h"
#import "PrivatePasswordView.h"

#define TransferAwaitVCAgreeApprovalBtn  @"同意审批"
#define TransferAwaitVCRefuseApprovalBtn  @"拒绝审批"
#define TransferTopViewApprovaling  @"审批中"
#define TransferTopViewApprovalSucceed  @"审批通过"
#define TransferTopViewApprovalFail  @"已拒绝审批"
#define TransferTopViewApprovalAgreen  @"已同意审批"
#define CellReuseIdentifier  @"TransferRecordDetail"
#define headerReusableViewIdentifier  @"TransferCollectionReusable"

@interface TransferAwaitDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PrivatePasswordViewDelegate>

@property(nonatomic, strong)TransferTopView *transferTopView;
@property(nonatomic, strong)UIButton *agreeApprovalBtn;
@property(nonatomic, strong)UIButton *refuseApprovalBtn;
@property(nonatomic, strong)UIButton *approvalStateBtn;
 
//布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *approvaledInfoArray;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;
@property(nonatomic, strong)NSString *apply_info;
@property(nonatomic, strong)PrivatePasswordView *privatePasswordView;
@property(nonatomic, assign)NSInteger progress;

@end

@implementation TransferAwaitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = _model.tx_info;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    [self createBarItem];
    [self createTransferBtn];
    _approvaledInfoArray = [[NSMutableArray alloc] init];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self layoutCollectionView];
    [self createCollectionView];
    [self requestData];
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
-(void)createCollectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11, 8,  SCREEN_WIDTH - 22, SCREEN_HEIGHT - 8 - kTopHeight - 45) collectionViewLayout:_collectionFlowlayout];
    [_collectionView registerClass:[TransferCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator =NO;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _collectionView.contentInset = UIEdgeInsetsMake(338, 0, 0, 0);
    _transferTopView = [[TransferTopView alloc] initWithFrame: CGRectMake(0, -338, SCREEN_WIDTH - 22, 338) dic:nil];
    [_collectionView addSubview: _transferTopView];
    [_collectionView registerClass:[TransferCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier];
    [self.view addSubview:_collectionView];
}

#pragma mark  ----- UICollectionViewDataSource -----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TransferModel *model = _approvaledInfoArray[section];
    return model.approversArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _approvaledInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TransferCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    TransferModel *transferModel = _approvaledInfoArray[indexPath.section];
    TransferApproversModel *model = transferModel.approversArray[indexPath.row];
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
    TransferCollectionReusableView* reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier forIndexPath:indexPath];
    TransferModel *transferModel = _approvaledInfoArray[indexPath.section];
    reusableView.model = transferModel;
    [reusableView setDataWithModel:transferModel index:indexPath.section];
    return reusableView;
}


#pragma mark ----- 数据请求 -----
-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_model.order_number forKey:@"order_number"];
    [paramsDic setObject: [BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/transfer/records" params:paramsDic success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            _apply_info = responseObject[@"data"][@"apply_info"];
            NSInteger progress = [responseObject[@"data"][@"progress"] integerValue];
            NSString *account = responseObject[@"data"][@"applyer"];
            [self showBtnApprovalState:progress];
            NSDictionary *apply_infoDic = [JsonObject dictionaryWithJsonString:_apply_info];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic  setObject:@(progress) forKey:@"progress"];
            [mutableDic  setObject:account forKey:@"account"];
            [mutableDic addEntriesFromDictionary:apply_infoDic];
            [_transferTopView setValueWithData:mutableDic ];
            NSArray *approvaled_infoArr = responseObject[@"data"][@"approvaled_info"];
            for (NSDictionary *dic in approvaled_infoArr) {
                TransferModel *model = [[TransferModel alloc] initWithDict:dic];
                [_approvaledInfoArray addObject:model];
                if (progress == 1) {
                    for (TransferApproversModel *transferApproversModel in model.approversArray) {
                        if ([transferApproversModel.app_account_id isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
                            [self showBtnApprovalingState:transferApproversModel.progress];
                        }
                    }
                }
            }
        }else{
            [ProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        [self.collectionView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)showBtnApprovalState:(NSInteger)progress
{
    switch (progress) {
        case ApprovalAwait:
            _agreeApprovalBtn.hidden = NO;
            _refuseApprovalBtn.hidden = NO;
            _approvalStateBtn.hidden = YES;
            
            break;
        case Approvaling:
            _agreeApprovalBtn.hidden = YES;
            _refuseApprovalBtn.hidden = YES;
            _approvalStateBtn.hidden = NO;
            [_approvalStateBtn setTitle:TransferTopViewApprovaling forState:UIControlStateNormal];
            break;
        case ApprovalFail:
            _agreeApprovalBtn.hidden = YES;
            _refuseApprovalBtn.hidden = YES;
            _approvalStateBtn.hidden = NO;
            [_approvalStateBtn setTitle:TransferTopViewApprovalFail forState:UIControlStateNormal];
            break;
        case ApprovalSucceed:
            _agreeApprovalBtn.hidden = YES;
            _refuseApprovalBtn.hidden = YES;
            _approvalStateBtn.hidden = NO;
            [_approvalStateBtn setTitle:TransferTopViewApprovalSucceed forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)showBtnApprovalingState:(NSInteger)progress
{
    switch (progress) {
        case ApprovalAwait:
            _agreeApprovalBtn.hidden = NO;
            _refuseApprovalBtn.hidden = NO;
            _approvalStateBtn.hidden = YES;
            break;
        case Approvaling:
            _agreeApprovalBtn.hidden = YES;
            _refuseApprovalBtn.hidden = YES;
            _approvalStateBtn.hidden = NO;
            [_approvalStateBtn setTitle:TransferTopViewApprovaling forState:UIControlStateNormal];
            break;
        case ApprovalFail:
            _agreeApprovalBtn.hidden = YES;
            _refuseApprovalBtn.hidden = YES;
            _approvalStateBtn.hidden = NO;
            [_approvalStateBtn setTitle:TransferTopViewApprovalFail forState:UIControlStateNormal];
            break;
        case ApprovalSucceed:
            _agreeApprovalBtn.hidden = YES;
            _refuseApprovalBtn.hidden = YES;
            _approvalStateBtn.hidden = NO;
            [_approvalStateBtn setTitle:TransferTopViewApprovalAgreen forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)createTransferBtn
{
    _agreeApprovalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeApprovalBtn setTitle:TransferAwaitVCAgreeApprovalBtn forState:UIControlStateNormal];
    _agreeApprovalBtn.tag = 1001;
    [_agreeApprovalBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _agreeApprovalBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _agreeApprovalBtn.titleLabel.font = Font(15);
    [_agreeApprovalBtn addTarget:self action:@selector(approvalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreeApprovalBtn];
    [_agreeApprovalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH/2);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];
    
    _refuseApprovalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refuseApprovalBtn setTitle:TransferAwaitVCRefuseApprovalBtn forState:UIControlStateNormal];
    [_refuseApprovalBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _refuseApprovalBtn.tag = 1002;
    _refuseApprovalBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _refuseApprovalBtn.titleLabel.font = Font(15);
    [_refuseApprovalBtn addTarget:self action:@selector(approvalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refuseApprovalBtn];
    [_refuseApprovalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreeApprovalBtn.mas_right).offset(0);
        make.width.offset(SCREEN_WIDTH/2);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];
    
    _approvalStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_approvalStateBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _approvalStateBtn.backgroundColor = [UIColor colorWithHexString:@"#c9c9c9"];
    _approvalStateBtn.titleLabel.font = Font(15);
    //[_approvalStateBtn addTarget:self action:@selector(refuseApprovalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_approvalStateBtn];
    _approvalStateBtn.hidden = YES;
    [_approvalStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];
}

#pragma mark ----- PrivatePasswordViewDelegate -----
- (void)PrivatePasswordViewDelegate:(NSString *)passwordStr
{
    if (![passwordStr isEqualToString:[BoxDataManager sharedManager].passWord]) {
        [WSProgressHUD showErrorWithStatus:@"密码输入错误"];
        return;
    }
    [_privatePasswordView removeFromSuperview];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:_apply_info privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:_apply_info signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:_model.order_number forKey:@"order_number"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:@(_progress) forKey:@"progress"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/transfer/approval" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
            [self showBtnApprovalingState:_progress];
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"]];
        }
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
}

#pragma mark -----  同意审批/拒绝审批 -----
-(void)approvalAction:(UIButton *)btn
{
    if (btn.tag == 1001) {
        _progress = 3;
    }else{
        _progress= 2;
    }
    _privatePasswordView = [[PrivatePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _privatePasswordView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_privatePasswordView];
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
    if ([self.delegate respondsToSelector:@selector(backReflesh)]) {
        [self.delegate backReflesh];
    }
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
