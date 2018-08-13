//
//  TransferRecordDetailViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferRecordDetailViewController.h"
#import "TransferTopView.h"
#import "TransferCollectionViewCell.h"
#import "TransferCollectionReusableView.h"
#import "TransferCollectionViewCell.h"
#import "TransferModel.h"
#import "TransferApproversModel.h"
#import "ApprovalBusinessFooterView.h"
#import "ViewLogViewController.h"
#import "PrivatePasswordView.h"
#import "LoginBoxViewController.h"

#define CellReuseIdentifier  @"TransferRecordDetail"
#define headerReusableViewIdentifier  @"TransferCollectionReusable"

@interface TransferRecordDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApprovalBusinessFooterDelegate,PrivatePasswordViewDelegate>
{
    NSString *reasonStr;
}
@property(nonatomic, strong)TransferTopView *transferTopView;
@property(nonatomic, strong)ApprovalBusinessFooterView *approvalBusinessFooterView;
//布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *approvaledInfoArray;
@property(nonatomic, strong)PrivatePasswordView *privatePasswordView;

@end

@implementation TransferRecordDetailViewController

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
    _approvaledInfoArray = [[NSMutableArray alloc] init];
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11, 8,  SCREEN_WIDTH - 22, SCREEN_HEIGHT - 9 - kTopHeight) collectionViewLayout:_collectionFlowlayout];
    [_collectionView registerClass:[TransferCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator =NO;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _collectionView.contentInset = UIEdgeInsetsMake(338 - 30, 0, 0, 0);
    _transferTopView = [[TransferTopView alloc] initWithFrame: CGRectMake(0, -338 + 30, SCREEN_WIDTH - 22, 338 - 30) dic:nil];
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
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/transfer/records" params:paramsDic success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSString *apply_info = responseObject[@"data"][@"apply_info"];
            NSInteger progress = [responseObject[@"data"][@"progress"] integerValue];
            NSInteger arrived = [responseObject[@"data"][@"arrived"] integerValue];
            NSString *account = responseObject[@"data"][@"applyer"];
            NSString *apply_at = responseObject[@"data"][@"apply_at"];
            NSString *applyer_uid = responseObject[@"data"][@"applyer_uid"];
            NSString *flow_name = responseObject[@"data"][@"flow_name"];
            NSDictionary *apply_infoDic = [JsonObject dictionaryWithJsonString:apply_info];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic  setObject:@(progress) forKey:@"progress"];
            [mutableDic  setObject:account forKey:@"account"];
            [mutableDic  setObject:@(arrived) forKey:@"arrived"];
            [mutableDic  setObject:apply_at forKey:@"apply_at"];
            [mutableDic  setObject:flow_name forKey:@"flow_name"];
            [mutableDic addEntriesFromDictionary:apply_infoDic];
            [_transferTopView setValueWithData:mutableDic ];
            NSArray *approvaled_infoArr = responseObject[@"data"][@"approvaled_info"];
            [self footerViewChange:approvaled_infoArr applyer:applyer_uid progress:progress];
            for (NSDictionary *dic in approvaled_infoArr) {
                TransferModel *model = [[TransferModel alloc] initWithDict:dic];
                [_approvaledInfoArray addObject:model];
            }
        }else{
            [ProgressHUD showErrorWithStatus:responseObject[@"message"] code:[responseObject[@"code"] integerValue]];
        }
        [self.collectionView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)footerViewChange:(NSArray *)array applyer:(NSString *)applyer progress:(NSInteger)progress
{
    CGFloat aa = 0.0;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dic = array[0];
        TransferModel *model = [[TransferModel alloc] initWithDict:dic];
        NSInteger approversAll = 0;
        NSInteger approversIn = model.approversArray.count % 4;
        if (approversIn >= 1) {
            approversAll = model.approversArray.count / 4 + 1;
        }
        aa = aa + 30 + approversAll * 45 + 10;
    }
    CGFloat height = 60;
    NSInteger type = 2;
    if ([[BoxDataManager sharedManager].app_account_id isEqualToString:applyer] && (progress == 0 || progress == 1)) {
        height = 110;
        type = 3;
    }
    
    _collectionView.contentInset = UIEdgeInsetsMake(338 - 30, 0, height + 60, 0);
    _approvalBusinessFooterView = [[ApprovalBusinessFooterView alloc] initWithFrame: CGRectMake(0,aa, SCREEN_WIDTH - 22, height)];
    [_approvalBusinessFooterView setValueWithStatus:type];
    _approvalBusinessFooterView.delegate = self;
    [_collectionView addSubview: _approvalBusinessFooterView];
}

#pragma mark ----- 撤回转账申请 -----
- (void)cancelApprovalBusiness
{
    [self showInputReason];
}

- (void)textViewEditChanged:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *textField = alertController.textFields.firstObject;
        UIAlertAction *submitAction = alertController.actions.lastObject;
        submitAction.enabled = textField.text.length > 0;
        // 需要限制的长度
        NSUInteger maxLength = 0;
        maxLength = 50;
        if (maxLength == 0) return;
        // text field 的内容
        NSString *contentText = textField.text;
        // 获取高亮内容的范围
        UITextRange *selectedRange = [textField markedTextRange];
        // 这行代码 可以认为是 获取高亮内容的长度
        NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        // 没有高亮内容时,对已输入的文字进行操作
        if (markedTextLength == 0) {
            // 如果 text field 的内容长度大于我们限制的内容长度
            if (contentText.length > maxLength) {
                // 截取从前面开始maxLength长度的字符串
                // textField.text = [contentText substringToIndex:maxLength];
                // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [contentText substringWithRange:rangeRange];
            }
        }
    }
}

-(void)showInputReason
{
    NSString *title = RefuseTransfer;
    NSString *message = RefuseTransferInfo;
    NSString *cancelTitle = Cancel;
    NSString *submitTitle = RefuseTransferSubmit;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = RefuseApprovalPlacehode;
        textField.secureTextEntry = NO;
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    [alertDialog addAction:actionCancel];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:submitTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertDialog.textFields.firstObject;
        reasonStr = textField.text;
        [self showPrivatePasswordView];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    submit.enabled = NO;
    [alertDialog addAction:submit];
    [self presentViewController:alertDialog animated:YES completion:nil];
}

#pragma mark ----- PrivatePasswordViewDelegate -----
- (void)PrivatePasswordViewDelegate:(NSString *)passwordStr
{
    [self handleTransferApplicationCancel:passwordStr];
}

-(void)handleTransferApplicationCancel:(NSString *)passwordStr
{
    NSString *hmacSHA256 = [UIARSAHandler hmac: passwordStr withKey:[BoxDataManager sharedManager].encryptKey];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_model.order_number forKey:@"order_number"];
    [paramsDic setObject:reasonStr forKey:@"reason"];
    [paramsDic setObject:hmacSHA256 forKey:@"password"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/transfer/application/cancel" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [self showProgressWithMessage:dict[@"message"]];
            [_privatePasswordView removeFromSuperview];
            [_transferTopView setValueWithtateCancel];
            [_approvalBusinessFooterView setValueWithProgress:ApprovalCancel type:ApprovalFooterTransferCancel];
        }else{
            //code == 1018时提示解冻时间戳
            if ([dict[@"code"] integerValue] == 1018) {
                [ProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%@", AccountLockup, [self getElapseTimeToString:[dict[@"data"][@"frozenTo"] integerValue]]] code:[dict[@"code"] integerValue]];
                if ([BoxDataManager sharedManager].launchState == LoginState) {
                    return ;
                }
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

- (NSString *)getElapseTimeToString:(NSInteger)second{
    NSDateFormatter  *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval1 = second;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval1];
    NSString *dateStr1=[dateformatter1 stringFromDate:date1];
    return dateStr1;
}

-(void)showProgressWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:Affirm style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showPrivatePasswordView
{
    _privatePasswordView = [[PrivatePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _privatePasswordView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_privatePasswordView];
}

#pragma mark ----- ViewLog -----
- (void)enterViewLog
{
    ViewLogViewController *viewLogVC = [[ViewLogViewController alloc] init];
    viewLogVC.transferAwaitModel = _model;
    viewLogVC.type = 1;
    UINavigationController *viewLogNC = [[UINavigationController alloc] initWithRootViewController:viewLogVC];
    [self presentViewController:viewLogNC animated:YES completion:nil];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
