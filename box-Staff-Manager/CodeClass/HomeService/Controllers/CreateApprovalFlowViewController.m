//
//  CreateApprovalFlowViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/4.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CreateApprovalFlowViewController.h"
#import "CreateApprovalFlowCollectionReusableView.h"
#import "CreateApprovalFlowCollectionViewCell.h"
#import "ApprovalBusinessDetailModel.h"
#import "ApprovalBusApproversModel.h"
#import "MenberInfoModel.h"
#import "AddApprovalMenberViewController.h"
#import "SetApprovalAmountViewController.h"

#define CellReuseIdentifier  @"CreateApprovalFlow"
#define headerReusableViewIdentifier  @"CreateApprovalFlow"

@interface CreateApprovalFlowViewController ()<UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CreateApprovalFlowCellDelegate>
{
    NSIndexPath *addIndexPath;
    NSInteger allowIn;
    NSInteger requireIn;
}

@property(nonatomic, strong)UIView *headerView;
@property(nonatomic, strong)UITextField *flowNameTf;
@property(nonatomic, strong)UITextField *flowLimitTf;
@property(nonatomic, strong)UIButton *addLevelsBtn;
//布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *approvaledInfoArray;
@property (nonatomic, strong) NSMutableArray *commitInfoArray;
@property (nonatomic, strong) NSMutableArray *addMenberArray;
@property(nonatomic, strong)UIButton *commitBtn;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation CreateApprovalFlowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = CreateApprovalFlowVCTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createBarItem];
    _approvaledInfoArray = [[NSMutableArray alloc] init];
    _commitInfoArray = [[NSMutableArray alloc] init];
    _addMenberArray = [[NSMutableArray alloc] init];
    [self layoutCollectionView];
    [self createCollectionView];
    [self getEmployeeInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMenber:) name:@"addMenber" object:nil];
}

#pragma mark ----- 根节点获取非直属下属的公钥信息 -----
-(void)getEmployeeInfo{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/employee/pubkeys/list" params:paramsDic success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSArray *dataArray = responseObject[@"data"];
            for (NSDictionary *dic in dataArray) {
                //上传公钥的员工账号唯一标识符
                NSString *applyer = dic[@"applyer"];
                //该员工账号的公钥
                NSString *pub_key = dic[@"pub_key"];
                //该员工账号直属上级账号唯一标识符
                NSString *captain = dic[@"captain"];
                //直属上级对其公钥的加密信息
                NSString *msg = dic[@"msg"];
                //员工账号
                NSString *applyer_account = dic[@"applyer_account"];
                //根据直属上级账号唯一标识符本地查出直属上级公钥
                NSArray *array = [[MenberInfoManager sharedManager] loadMenberInfo:captain];
                if (array.count == 1) {
                    MenberInfoModel *model = array[0];
                    NSString *captain_pub_key = model.publicKey;
                     BOOL verySign = [_aWrapper PKCSVerifyBytesSHA256withRSA:pub_key signature:msg publicStr:captain_pub_key];
                    if (verySign) {
                        MenberInfoModel *menberInfoModel = [[MenberInfoModel alloc] init];
                        menberInfoModel.menber_account = applyer_account;
                        menberInfoModel.menber_id = applyer;
                        menberInfoModel.publicKey = pub_key;
                        menberInfoModel.menber_random = @"0";
                        menberInfoModel.directIdentify = 0;
                        [[MenberInfoManager sharedManager] insertMenberInfoModel:menberInfoModel];
                    }
                }
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark ----- 布局 -----
-(void)layoutCollectionView
{
    _collectionFlowlayout = [[UICollectionViewFlowLayout alloc] init];
    //item大小
    _collectionFlowlayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 22 - 37 - 13)/4, 41);
    // 最小列间距
    _collectionFlowlayout.minimumInteritemSpacing = 0;
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
    _headerView = [[UIView alloc] initWithFrame: CGRectMake(11, 8, SCREEN_WIDTH - 22, 183 - 50)];
    _headerView.layer.cornerRadius = 3.0f;
    _headerView.layer.masksToBounds = YES;
    _headerView.backgroundColor = kWhiteColor;
    [self.view addSubview: _headerView];
    [self createHeaderView];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11, 188 - 50,  SCREEN_WIDTH - 22, SCREEN_HEIGHT - 188 - kTopHeight - 45 + 50 + (-kTabBarHeight + 49)) collectionViewLayout:_collectionFlowlayout];
    [_collectionView registerClass:[CreateApprovalFlowCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator =NO;
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CreateApprovalFlowCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier];
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    //_commitBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _commitBtn.enabled = NO;
    _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    _commitBtn.titleLabel.font = Font(15);
    [_commitBtn setTitle:NextStep forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitBtn];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    CreateApprovalFlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    
    ApprovalBusinessDetailModel *approvalBusinessDetailModel = _approvaledInfoArray[indexPath.section];
    ApprovalBusApproversModel *model = approvalBusinessDetailModel.approvers[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    [cell setDataWithModel:model indexPath:indexPath];
    return cell;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width - 22, 30);
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CreateApprovalFlowCollectionReusableView* reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier forIndexPath:indexPath];
    ApprovalBusinessDetailModel *approvalBusinessDetailModel = _approvaledInfoArray[indexPath.section];
    reusableView.model = approvalBusinessDetailModel;
    [reusableView setDataWithModel:approvalBusinessDetailModel index:indexPath.section];
    return reusableView;
}

#pragma mark ----- createHeaderView -----
-(void)createHeaderView
{
    //审批流名称
    UILabel *flowNameLab = [[UILabel alloc] init];
    flowNameLab.textAlignment = NSTextAlignmentLeft;
    flowNameLab.font = Font(14);
    flowNameLab.text = CreateApprovalFlowVCflowNameLab;
    flowNameLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_headerView addSubview:flowNameLab];
    [flowNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(23);
        make.height.offset(20);
        make.left.offset(14);
        make.width.offset(90);
    }];
    
    _flowNameTf = [[UITextField alloc] init];
    _flowNameTf.placeholder = CreateApprovalFlowVCflowNameInfo;
    _flowNameTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    _flowNameTf.font = Font(14);
    _flowNameTf.delegate = self;
    _flowNameTf.keyboardType = UIKeyboardTypeDefault;
    _flowNameTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [_flowNameTf addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [_headerView addSubview:_flowNameTf];
    [_flowNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flowNameLab.mas_right).offset(15);
        make.centerY.equalTo(flowNameLab);
        make.height .offset(20);
        make.right.offset(-15);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_headerView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(flowNameLab.mas_bottom).offset(16);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 22 - 30);
        make.height.offset(1);
    }];
    
    /*
    //审批金额上限
    UILabel *flowLimitLab = [[UILabel alloc] init];
    flowLimitLab.textAlignment = NSTextAlignmentLeft;
    flowLimitLab.font = Font(14);
    flowLimitLab.text = CreateApprovalFlowVCflowLimitLab;
    flowLimitLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_headerView addSubview:flowLimitLab];
    [flowLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(15);
        make.height.offset(20);
        make.left.offset(14);
        make.width.offset(90);
    }];
    
    _flowLimitTf = [[UITextField alloc] init];
    _flowLimitTf.placeholder = CreateApprovalFlowVCflowLimitInfo;
    _flowLimitTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    _flowLimitTf.font = Font(14);
    _flowLimitTf.delegate = self;
    _flowLimitTf.keyboardType = UIKeyboardTypeDecimalPad;
    _flowLimitTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [_flowLimitTf addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [_headerView addSubview:_flowLimitTf];
    [_flowLimitTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flowLimitLab.mas_right).offset(15);
        make.centerY.equalTo(flowLimitLab);
        make.height .offset(20);
        make.right.offset(-15);
    }];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_headerView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(flowLimitLab.mas_bottom).offset(16);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 22 - 30);
        make.height.offset(1);
    }];
     */
    
    //审核层级
    UILabel *levelsLab = [[UILabel alloc] init];
    levelsLab.textAlignment = NSTextAlignmentLeft;
    levelsLab.font = Font(14);
    levelsLab.text = CreateApprovalFlowVCApprovalLevels;
    levelsLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_headerView addSubview:levelsLab];
    [levelsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(15);
        make.height.offset(20);
        make.left.offset(14);
        make.width.offset(90);
    }];
    
    _addLevelsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addLevelsBtn setTitle:CreateApprovalFlowVCAddLevels forState:UIControlStateNormal];
    [_addLevelsBtn setImage: [UIImage imageNamed:@"icon_add_white"] forState:UIControlStateNormal];
    [_addLevelsBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _addLevelsBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _addLevelsBtn.titleLabel.font = Font(13);
    _addLevelsBtn.layer.masksToBounds = YES;
    _addLevelsBtn.layer.cornerRadius = 3.0f;
    [_addLevelsBtn addTarget:self action:@selector(addLevelsAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_addLevelsBtn];
    [_addLevelsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(levelsLab);
        make.right .offset(-15);
        make.width.offset(87);
        make.height.offset(30);
    }];
    
    UIView *lineThree = [[UIView alloc] init];
    lineThree.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_headerView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelsLab.mas_bottom).offset(16);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 22 - 30);
        make.height.offset(1);
    }];
}

#pragma mark ----- 提交审批数据提取 -----
-(void)handleData
{
    allowIn = 0;
    [_commitInfoArray removeAllObjects];
    for (ApprovalBusinessDetailModel *approvalBusinessDetailModel in _approvaledInfoArray) {
        NSMutableArray *array;
        array = [[NSMutableArray alloc] init];
        if (approvalBusinessDetailModel.approvers.count >= 1) {
            if(approvalBusinessDetailModel.approvers.count == 1){
                allowIn = 1;
            }
            for (int i = 0; i < approvalBusinessDetailModel.approvers.count - 1; i ++) {
                ApprovalBusApproversModel *model = approvalBusinessDetailModel.approvers[i];
                NSDictionary *dic = [model createDictionayFromModelProperties];
                [array addObject:dic];
            }
        }
        ApprovalBusinessDetailModel *approvaModel = [[ApprovalBusinessDetailModel alloc] init];
        approvaModel.approvers = array;
        approvaModel.require = approvalBusinessDetailModel.require;
        approvaModel.total = approvalBusinessDetailModel.total;
        
        NSDictionary *dic = [approvaModel createDictionayFromModelProperties];
        [_commitInfoArray addObject:dic];
    }
}

#pragma mark ----- 提交审批 -----
-(void)commitAction:(UIButton *)btn
{
    if ( [_flowNameTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:CreateApprovalFlowVCflowNameInfo];
        return;
    }
    /*
    if ([_flowLimitTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:CreateApprovalFlowVCflowLimitInfo];
        return;
    }
     */
    if (_approvaledInfoArray.count == 0) {
        [WSProgressHUD showErrorWithStatus:CreateApprovalFlowVCAddLevelsAleart];
        return;
    }
    [_commitInfoArray removeAllObjects];
    for (ApprovalBusinessDetailModel *approvalBusinessDetailModel in _approvaledInfoArray) {
        NSMutableArray *array;
        array = [[NSMutableArray alloc] init];
        if (approvalBusinessDetailModel.approvers.count >= 1) {
            if(approvalBusinessDetailModel.approvers.count == 1){
                [WSProgressHUD showErrorWithStatus:CreateApprovalFlowVCBlankAleart];
                return;
            }
            for (int i = 0; i < approvalBusinessDetailModel.approvers.count - 1; i ++) {
                ApprovalBusApproversModel *model = approvalBusinessDetailModel.approvers[i];
                NSDictionary *dic = [model createDictionayFromModelProperties];
                [array addObject:dic];
            }
        }
        ApprovalBusinessDetailModel *approvaModel = [[ApprovalBusinessDetailModel alloc] init];
        approvaModel.approvers = array;
        approvaModel.require = approvalBusinessDetailModel.require;
        approvaModel.total = approvalBusinessDetailModel.total;
        NSDictionary *dic = [approvaModel createDictionayFromModelProperties];
        [_commitInfoArray addObject:dic];
        if (approvaModel.require == 0) {
            [WSProgressHUD showErrorWithStatus:CreateApprovalFlowVCBlankAleartZero];
            return;
        }
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_flowNameTf.text forKey:@"flow_name"];
    [dic setObject:@"" forKey:@"single_limit"];
    [dic setObject:_commitInfoArray forKey:@"approval_info"];
    SetApprovalAmountViewController *setApprovalAmountVc = [[SetApprovalAmountViewController alloc] init];
    setApprovalAmountVc.paramDic = dic;
    UINavigationController *setApprovalAmountNc = [[UINavigationController alloc] initWithRootViewController:setApprovalAmountVc];
    [self presentViewController:setApprovalAmountNc animated:YES completion:nil];
}

#pragma mark ----- 添加层级 -----
-(void)addLevelsAction:(UIButton *)btn
{

    NSDictionary *dic = @{
                          @"require":@(0),@"total":@(0),@"approvers":@[@{
                                                                           @"account":@"",
                                                                           @"app_account_id":@"",
                                                                           @"pub_key":@"",
                                                                           @"itemType":@(ItemTypeAdd)
                                                                           }
                                                                       ]
                          };
    
    ApprovalBusinessDetailModel *model = [[ApprovalBusinessDetailModel alloc] initWithDict:dic];
    [_approvaledInfoArray addObject:model];
    [self.collectionView reloadData];
}

-(void)addMenber:(NSNotification *)notification
{
    ApprovalBusApproversModel *approvalBusApproversModel = notification.object;
    [_addMenberArray addObject:approvalBusApproversModel];
    ApprovalBusinessDetailModel *approvalBusinessDetailModel = _approvaledInfoArray[addIndexPath.section];
    approvalBusinessDetailModel.total = addIndexPath.row + 1;
    [approvalBusinessDetailModel.approvers insertObject:approvalBusApproversModel atIndex:addIndexPath.row];
    [self.collectionView reloadData];
}

#pragma mark ----- CreateApprovalFlowCellDelegate - addMenberAction  -----
- (void)addMenberAction:(NSIndexPath *)indexPath
{
    addIndexPath = indexPath;
    AddApprovalMenberViewController *addApprovalMenberVC = [[AddApprovalMenberViewController alloc] init];
    addApprovalMenberVC.addArray = _addMenberArray;
    UINavigationController *addApprovalMenberNC = [[UINavigationController alloc] initWithRootViewController:addApprovalMenberVC];
    [self presentViewController:addApprovalMenberNC animated:YES completion:nil];
}

#pragma mark ----- CreateApprovalFlowCellDelegate - deleteMenberAction  -----
- (void)deleteMenberAction:(NSIndexPath *)indexPath
{
    ApprovalBusinessDetailModel *approvalBusinessDetailModel = _approvaledInfoArray[indexPath.section];
    ApprovalBusApproversModel *approvalBusApproversModel = approvalBusinessDetailModel.approvers[indexPath.row];
    
    for (int i = 0; i < _addMenberArray.count; i ++) {
        ApprovalBusApproversModel *busApproversModel = _addMenberArray[i];
        if ([approvalBusApproversModel.app_account_id isEqualToString:busApproversModel.app_account_id]) {
            [_addMenberArray removeObjectAtIndex:i];
        }
    }
    [approvalBusinessDetailModel.approvers removeObjectAtIndex:indexPath.row];
    if (approvalBusinessDetailModel.require == approvalBusinessDetailModel.total) {
        approvalBusinessDetailModel.require = approvalBusinessDetailModel.approvers.count - 1;
    }
    approvalBusinessDetailModel.total = approvalBusinessDetailModel.approvers.count - 1;
    [self.collectionView reloadData];
}

#pragma mark ----- textFieldDidChange -----
- (void)textFieldDidChange:(UITextField *)textField
{
    if (_flowNameTf.text.length > 0) {
        _commitBtn.enabled = YES;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    }else{
        _commitBtn.enabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
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
    [self.view endEditing:YES];
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
