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

#define CellReuseIdentifier  @"TransferRecordDetail"
#define headerReusableViewIdentifier  @"TransferCollectionReusable"

@interface TransferRecordDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApprovalBusinessFooterDelegate>

@property(nonatomic, strong)TransferTopView *transferTopView;
@property(nonatomic, strong)ApprovalBusinessFooterView *approvalBusinessFooterView;
//布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *approvaledInfoArray;

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
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/transfer/records" params:paramsDic success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSString *apply_info = responseObject[@"data"][@"apply_info"];
            NSInteger progress = [responseObject[@"data"][@"progress"] integerValue];
            NSInteger arrived = [responseObject[@"data"][@"arrived"] integerValue];
            NSString *account = responseObject[@"data"][@"applyer"];
            NSDictionary *apply_infoDic = [JsonObject dictionaryWithJsonString:apply_info];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic  setObject:@(progress) forKey:@"progress"];
            [mutableDic  setObject:account forKey:@"account"];
            [mutableDic  setObject:@(arrived) forKey:@"arrived"];
            [mutableDic addEntriesFromDictionary:apply_infoDic];
            [_transferTopView setValueWithData:mutableDic ];
            NSArray *approvaled_infoArr = responseObject[@"data"][@"approvaled_info"];
            [self footerViewChange:approvaled_infoArr];
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

-(void)footerViewChange:(NSArray *)array
{
    CGFloat aa = 0.0;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dic = array[0];
        TransferModel *model = [[TransferModel alloc] initWithDict:dic];
        NSInteger approversAll = 0;
        NSInteger approversIn = model.approversArray.count % 4;
        if (approversIn >= 1) {
            approversAll = model.approversArray.count / 4 + approversIn;
        }
        aa = aa + 30 + approversAll * 45 + 10;
    }
    _collectionView.contentInset = UIEdgeInsetsMake(338, 0, 100, 0);
    _approvalBusinessFooterView = [[ApprovalBusinessFooterView alloc] initWithFrame: CGRectMake(0,aa, SCREEN_WIDTH - 22, 60)];
    [_approvalBusinessFooterView setValueWithStatus:ApprovalFooterTransfer];
    _approvalBusinessFooterView.delegate = self;
    [_collectionView addSubview: _approvalBusinessFooterView];
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
