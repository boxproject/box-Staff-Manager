//
//  AddApprovalMemberViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AddApprovalMemberViewController.h"
#import "SearchMenberModel.h"
#import "ApprovalBusApproversModel.h"
#import "DepartmentModel.h"
#import "AddApprovalMemberTableViewCell.h"
#import "AddApprovalMemberCollectionViewCell.h"
#import "DepartmemtInfoModel.h"
#import "ApprovalBusApproversModel.h"

#define PageSize  12
#define CellReuseIdentifier  @"AddApprovalMember"
#define UICollectionCellReuseIdentifier  @"AddApprovalMemberCollectionViewCell"

@interface AddApprovalMemberViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger OneCell;
}
@property (nonatomic, strong) NSMutableArray *sourceOneArray;
@property (nonatomic, strong) NSMutableArray *sourceTwoArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation AddApprovalMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    self.title = AddApprovalMenberVC;
    _sourceOneArray = [[NSMutableArray alloc] init];
    _sourceTwoArray = [[NSMutableArray alloc] init];
    _selectArray = [[NSMutableArray alloc] init];
    _aWrapper = [[DDRSAWrapper alloc] init];
    OneCell = 1;
    [self createView];
    [self layoutCollectionView];
    [self createCollectionView];
    [self requestData];
}

-(void)createView
{
    [self createBarItem];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.width.offset(100);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [_tableView registerClass:[AddApprovalMemberTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark ----- 布局 -----
-(void)layoutCollectionView
{
    _collectionFlowlayout = [[UICollectionViewFlowLayout alloc] init];
    //item大小
    _collectionFlowlayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 100 - 30 - 20)/3, 35);
    // 最小列间距
    _collectionFlowlayout.minimumInteritemSpacing = 10;
    // 最小行间距
    _collectionFlowlayout.minimumLineSpacing = 12;
    // 分区内容边间距（上，左， 下， 右）；
    _collectionFlowlayout.sectionInset = UIEdgeInsetsMake(12, 15, 12, 15);
    // 滑动方向
    //_flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //_assoFlowlayout.scrollDirection = NO;
}

#pragma mark - 添加群列表
-(void)createCollectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionFlowlayout];
    [_collectionView registerClass:[AddApprovalMemberCollectionViewCell class] forCellWithReuseIdentifier:UICollectionCellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator =NO;
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableView.mas_right).offset(0);
        make.top.offset(0);
        make.right.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
}

#pragma mark  ----- collectionView -----
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sourceTwoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddApprovalMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionCellReuseIdentifier forIndexPath:indexPath];
    DepartmemtInfoModel *model = self.sourceTwoArray[indexPath.item];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DepartmemtInfoModel *model = self.sourceTwoArray[indexPath.row];
        if (model.state != 2) {
            model.select = !model.select;
            if (model.select) {
                model.state = 1;
                [_selectArray addObject:model];
                NSArray *array = [[MenberInfoManager sharedManager] loadMenberInfo:model.AppID];
                if (array.count == 0) {
                    if (![model.AppID  isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
                        [self employeePubkeysInfo:model];
                    }
                }
            }else{
                model.state = 0;
                //[_selectArray removeObject:model];
                for (int i = 0; i < _selectArray.count; i++) {
                    DepartmemtInfoModel *infoModel = _selectArray[i];
                    if ([infoModel.AppID isEqualToString:model.AppID]) {
                        [_selectArray removeObjectAtIndex:i];
                    }
                }
            }
            if (_selectArray.count > 0) {
                [_rightButton setTitle: [NSString stringWithFormat:@"%@(%ld)", Affirm, _selectArray.count] forState:UIControlStateNormal];
                _rightButton.enabled = YES;
                UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
                self.navigationItem.rightBarButtonItem = barButton;
            }else{
                [_rightButton setTitle: Affirm forState:UIControlStateNormal];
                _rightButton.enabled = NO;
                UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
                self.navigationItem.rightBarButtonItem = barButton;
            }
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    });
}

#pragma mark ----- createBarItem -----
- (void)createBarItem{
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithTitle:Cancel style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle: Affirm forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = barButton;
    [_rightButton addTarget:self action:@selector(rightBarButton) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.enabled = NO;
}


#pragma mark ----- Affirm -----
-(void)rightBarButton
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (DepartmemtInfoModel *infoModel in _selectArray) {
        NSArray *array = [[MenberInfoManager sharedManager] loadMenberInfo:infoModel.AppID];
        if (array.count == 0) {
            if ([infoModel.AppID isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
                NSDictionary *dic = @{
                                      @"account":[BoxDataManager sharedManager].applyer_account,
                                      @"app_account_id":[BoxDataManager sharedManager].app_account_id,
                                      @"pub_key":[BoxDataManager sharedManager].publicKeyBase64,
                                      @"itemType":@(0)
                                      };
                ApprovalBusApproversModel *approvalBusApproversModel = [[ApprovalBusApproversModel alloc] initWithDict:dic];
                [arr addObject:approvalBusApproversModel];
            }
        }else{
            MenberInfoModel *menberInfoModel = array[0];
            NSDictionary *dic = @{
                                  @"account":infoModel.Account,
                                  @"app_account_id":infoModel.AppID,
                                  @"pub_key":menberInfoModel.publicKey,
                                  @"itemType":@(0)
                                  };
            ApprovalBusApproversModel *approvalBusApproversModel = [[ApprovalBusApproversModel alloc] initWithDict:dic];
            [arr addObject:approvalBusApproversModel];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addMenber" object:arr];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ----- 根节点获取指定非直属下属的公钥信息 -----
-(void)employeePubkeysInfo:(DepartmemtInfoModel *)model{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"manager_account_id"];
    [paramsDic setObject:model.AppID forKey:@"employee_account_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/employee/pubkeys/info" params:paramsDic success:^(id responseObject) {
        //[WSProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 0) {
            NSDictionary *dic = responseObject[@"data"];
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
                MenberInfoModel *menberModel = array[0];
                NSString *captain_pub_key = menberModel.publicKey;
                BOOL verySign = [_aWrapper PKCSVerifyBytesSHA256withRSA:pub_key signature:msg publicStr:captain_pub_key];
                if (verySign == YES) {
                    MenberInfoModel *menberInfoModel = [[MenberInfoModel alloc] init];
                    menberInfoModel.menber_account = applyer_account;
                    menberInfoModel.menber_id = applyer;
                    menberInfoModel.publicKey = pub_key;
                    menberInfoModel.menber_random = @"0";
                    menberInfoModel.directIdentify = 0;
                    [[MenberInfoManager sharedManager] insertMenberInfoModel:menberInfoModel];
                }
            }
        }else{
            [ProgressHUD showErrorWithStatus:responseObject[@"message"] code:[responseObject[@"code"] integerValue]];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark ----- backAction -----
-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/branch/list" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *listDic in listArray) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithDict:listDic];
                [_sourceOneArray addObject:model];
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
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:index];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceOneArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddApprovalMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    DepartmentModel *model = self.sourceOneArray[indexPath.row];
    cell.model = model;
    cell.OneCell = OneCell;
    OneCell = 0;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sourceOneArray.count == 0) {
        return;
    }
    DepartmentModel *model = self.sourceOneArray[indexPath.row];
    [self loadDataBranchInfo:model];
    if (indexPath.row != 0) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    }
    AddApprovalMemberTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.title.textColor = [UIColor colorWithHexString:@"#4c7afd"];
    cell.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddApprovalMemberTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.title.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.backgroundColor = [UIColor whiteColor];
}

-(void)loadDataBranchInfo:(DepartmentModel *)model{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:@(model.ID) forKey:@"bid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/branch/info" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [_sourceTwoArray removeAllObjects];
            NSArray *listArray = dict[@"data"][@"EmployeesList"];
            for (NSDictionary *listDic in listArray) {
                DepartmemtInfoModel *model = [[DepartmemtInfoModel alloc] initWithDict:listDic];
                for (ApprovalBusApproversModel *approvalBusModel in _addArray) {
                    if ([approvalBusModel.app_account_id  isEqualToString:model.AppID]) {
                        model.select = YES;
                        model.state = 2;
                    }
                }
                for (DepartmemtInfoModel *infoModel in _selectArray) {
                    if ([infoModel.AppID  isEqualToString:model.AppID]) {
                        model.select = YES;
                        model.state = 1;
                    }
                }
                [_sourceTwoArray addObject:model];
            }
            [self.collectionView reloadData];
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
