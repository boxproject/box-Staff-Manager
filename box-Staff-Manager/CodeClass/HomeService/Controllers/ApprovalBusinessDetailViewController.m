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

#define CellReuseIdentifier  @"ApprovalBusinessDetail"
#define headerReusableViewIdentifier  @"ApprovalBusinessDetail"

#define ApprovalBusinessDetailApprovaling  @"审批中"
#define ApprovalBusinessDetailSucceed  @"审批通过"
#define ApprovalBusinessDetailFail  @"已拒绝审批"
#define ApprovalBusinessDetailAwait  @"待审批"

@interface ApprovalBusinessDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)ApprovalBusinessTopView *approvalBusinessTopView;
//布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *approvaledInfoArray;
@property(nonatomic, strong)UIButton *approvalStateBtn;

@end

@implementation ApprovalBusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = _model.flow_name;
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11, 8,  SCREEN_WIDTH - 22, SCREEN_HEIGHT - 8 - kTopHeight - 45) collectionViewLayout:_collectionFlowlayout];
    [_collectionView registerClass:[ApprovalBusinessCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator =NO;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _collectionView.contentInset = UIEdgeInsetsMake(72, 0, 0, 0);
    _approvalBusinessTopView = [[ApprovalBusinessTopView alloc] initWithFrame: CGRectMake(0, -72, SCREEN_WIDTH - 22, 72) dic:nil];
    [_collectionView addSubview: _approvalBusinessTopView];
    [_collectionView registerClass:[ApprovalBusinessCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier];
    [self.view addSubview:_collectionView];
    
    _approvalStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_approvalStateBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _approvalStateBtn.backgroundColor = [UIColor colorWithHexString:@"#c9c9c9"];
    _approvalStateBtn.titleLabel.font = Font(15);
    //[_approvalStateBtn addTarget:self action:@selector(refuseApprovalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_approvalStateBtn];
    [_approvalStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];

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

#pragma mark ----- 数据请求 -----
-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_model.flow_id forKey:@"flow_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    //[ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/business/flow/info" params:paramsDic success:^(id responseObject) {
        //[WSProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 0) {
            NSInteger progress = [responseObject[@"data"][@"progress"] integerValue];
            [self showBtnApprovalState:progress];
            NSString *single_limit = responseObject[@"data"][@"single_limit"];
            NSString *flow_name = responseObject[@"data"][@"flow_name"];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic  setObject:single_limit forKey:@"single_limit"];
            [mutableDic  setObject:flow_name forKey:@"flow_name"];
            [_approvalBusinessTopView setValueWithData:mutableDic ];
            NSArray *approvaled_infoArr = responseObject[@"data"][@"approval_info"];
            for (NSDictionary *dic in approvaled_infoArr) {
                ApprovalBusinessDetailModel *model = [[ApprovalBusinessDetailModel alloc] initWithDict:dic];
                [_approvaledInfoArray addObject:model];
            }
        }else{
            [ProgressHUD showStatus:[responseObject[@"code"] integerValue]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } fail:^(NSError *error) {
        //[WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
}

-(void)showBtnApprovalState:(NSInteger)progress
{
    switch (progress) {
        case ApprovalAwait:
            [_approvalStateBtn setTitle:ApprovalBusinessDetailAwait forState:UIControlStateNormal];
            break;
        case Approvaling:
            [_approvalStateBtn setTitle:ApprovalBusinessDetailApprovaling forState:UIControlStateNormal];
            break;
        case ApprovalFail:
            [_approvalStateBtn setTitle:ApprovalBusinessDetailFail forState:UIControlStateNormal];
            break;
        case ApprovalSucceed:
            [_approvalStateBtn setTitle:ApprovalBusinessDetailSucceed forState:UIControlStateNormal];
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
