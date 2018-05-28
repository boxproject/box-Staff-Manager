//
//  OrganizationViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "OrganizationViewController.h"
#import "OrganizationTableViewCell.h"
#import "OrganizationModel.h"
#import "SearchMenberViewController.h"

#define PageSize  12
#define CellReuseIdentifier  @"Organization"

@interface OrganizationViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,SearchMenberDelegate>

@property(nonatomic, strong)UIScrollView *topScrollview;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) UILabel *topTitlelab;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) DDRSAWrapper *aWrapper;
@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_app_account_id == nil) {
        self.title = [BoxDataManager sharedManager].applyer_account;
        _aWrapper = [[DDRSAWrapper alloc] init];
        [self getEmployeeInfo];
    }else{
        self.title = _searchMenberModel.account;;
    }
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createView];
    _page = 1;
    [self requestData];
}

#pragma mark ----- 根节点获取非直属下属的公钥信息 -----
-(void)getEmployeeInfo{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
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

-(void)createView
{
    [self createBarItem];
    if (_app_account_id != nil) {
        _topScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, 60)];
        _topScrollview.delegate = self;
        _topScrollview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _topScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 60);
        _topScrollview.showsVerticalScrollIndicator = NO;
        _topScrollview.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_topScrollview];
        
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [self.view addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topScrollview.mas_bottom).offset(0);
            make.left.offset(0);
            make.right.offset(-0);
            make.height.offset(1);
        }];
        
        _topTitlelab = [[UILabel alloc] init];
        _topTitlelab.font = Font(14);
        _topTitlelab.text = _currentTitle;
        CGSize size = [_topTitlelab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName,nil]];
        if (size.width + 30 > CGRectGetWidth(self.view.frame)) {
            _topScrollview.contentOffset = CGPointMake(size.width + 30 + 15, 0);
            _topScrollview.contentSize = CGSizeMake(size.width + 30 + 15, 60);
            
        }
        _topTitlelab.textColor = [UIColor colorWithHexString:@"#4c7afd"];
        [_topScrollview addSubview:_topTitlelab];
        [_topTitlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(15);
            make.height.offset(60);
        }];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        if (_app_account_id == nil) {
            make.top.offset(0);
            
        }else{
            make.top.equalTo(_line.mas_bottom).offset(0);
        }
        make.right.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [_tableView registerClass:[OrganizationTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self footerReflesh];
    [self headerReflesh];
}

#pragma mark - createBarItem
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
        [self requestData];
    }];
}

#pragma mark ----- 上级管理员获取下属账号列表 -----
-(void)requestData
{
    NSString *account_id;
    if (_app_account_id == nil) {
        account_id = [BoxDataManager sharedManager].app_account_id;
    }else{
        account_id = _app_account_id;
    }
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:account_id forKey:@"app_account_id"];
    [paramsDic setObject: @(_page) forKey:@"page"];
    [paramsDic setObject:@(PageSize) forKey:@"limit"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/accounts/list" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            if (_page == 1) {
                [_sourceArray removeAllObjects];
            }
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *listDic in listArray) {
                SearchMenberModel *model = [[SearchMenberModel alloc] initWithDict:listDic];
                [_sourceArray addObject:model];
            }
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"]];
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
        [self.tableView.mj_footer endRefreshing];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    SearchMenberModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchMenberModel *model = self.sourceArray[indexPath.row];
    if (model.employee_num == 0) {
        return;
    }
    OrganizationViewController *organizationVc = [[OrganizationViewController alloc] init];
    organizationVc.app_account_id = model.app_account_id;
    organizationVc.searchMenberModel = model;
    organizationVc.currentTitle = [NSString stringWithFormat:@"%@ > %@", self.title, model.account];
    [self.navigationController pushViewController:organizationVc animated:YES];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchMenberModel *model = self.sourceArray[indexPath.row];
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"替换" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 收回左滑出现的按钮(退出编辑模式)
        //tableView.editing = NO;
        SearchMenberViewController *searchMenberVc = [[SearchMenberViewController alloc] init];
        searchMenberVc.delegate = self;
        searchMenberVc.employee_account_id = model.app_account_id;
        [self.navigationController pushViewController:searchMenberVc animated:YES];
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //获取该下属账号详情
            [self gainAccountsInfo:model];
        }];
        [alert addAction:actionOk];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    if (![[BoxDataManager sharedManager].depth isEqualToString:@"0"]) {
        return @[];
    }
    if (_app_account_id == nil) {
        if (model.employee_num > 0) {
            return @[action1, action0];
        }else{
            return @[action1];
        }
    }else{
       return @[];
    }
}

#pragma mark ----- SearchMenberDelegate -----
- (void)replaceMenberReflesh
{
    //刷新新的成员列表
    self.page = 1;
    [self requestData];
}

#pragma mark ----- 获取下属账号详情 -----
-(void)gainAccountsInfo:(SearchMenberModel *)model
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"manager_account_id"];
    [paramsDic setObject:model.app_account_id forKey:@"employee_account_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/accounts/info" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *listArray = dict[@"data"][@"employee_accounts_info"];
            NSMutableArray *employeeInfoArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in listArray) {
                NSString *app_account_id = dic[@"app_account_id"];
                NSString *cipher_text = dic[@"cipher_text"];
                NSArray *menberArray = [[MenberInfoManager sharedManager] loadMenberInfo:model.app_account_id];
                NSArray *menberEmployeeArray = [[MenberInfoManager sharedManager] loadMenberInfo:app_account_id];
                if (menberArray.count == 0 || menberEmployeeArray == 0) {
                    return ;
                }
                MenberInfoModel *menberModel = [[MenberInfoManager sharedManager] loadMenberInfo:model.app_account_id][0];
                MenberInfoModel *menberEmployeeModel = [[MenberInfoManager sharedManager] loadMenberInfo:app_account_id][0];
                NSString *menber_random = menberModel.menber_random;
                NSString *employee_publicKey = menberEmployeeModel.publicKey;
                if (employee_publicKey != nil && menber_random != nil) {
                    NSString *employeeHmacSHA256 = [UIARSAHandler hmac:employee_publicKey withKey:menber_random];
                    if ([cipher_text isEqualToString:employeeHmacSHA256]) {
                        NSString *hmacSHA256 = [UIARSAHandler hmac: employee_publicKey withKey:[BoxDataManager sharedManager].app_account_random];
                        NSDictionary *employeeDic = @{
                                              @"app_account_id":app_account_id,
                                              @"cipher_text":hmacSHA256
                                              };
                        [employeeInfoArr addObject:employeeDic];
                    }
                }else{
                    if (employee_publicKey == nil && menber_random != nil) {
                        [self employeePubkeysInfo:app_account_id completeLoad:^(MenberInfoModel *completeModel) {
                            if (completeModel != nil) {
                                NSString *employeeHmacSHA256 = [UIARSAHandler hmac: completeModel.publicKey withKey:menber_random];
                                if ([cipher_text isEqualToString:employeeHmacSHA256]) {
                                    NSString *hmacSHA256 = [UIARSAHandler hmac:employee_publicKey withKey:[BoxDataManager sharedManager].app_account_random];
                                    NSDictionary *employeeDic = @{
                                                                  @"app_account_id":app_account_id,
                                                                  @"cipher_text":hmacSHA256
                                                                  };
                                    [employeeInfoArr addObject:employeeDic];
                                }
                            }
                        }];
                    }
                }
            }
            //删除员工账号
            [self deleteEmployeeAccount:model array:employeeInfoArr];
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark ----- 删除员工账号 -----
-(void)deleteEmployeeAccount:(SearchMenberModel *)model array:(NSArray *)array
{
    NSString *cipher_texts = [JsonObject dictionaryToarrJson:array];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:model.app_account_id privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:model.app_account_id signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"manager_account_id"];
    [paramsDic setObject:model.app_account_id forKey:@"employee_account_id"];
    [paramsDic setObject:cipher_texts forKey:@"cipher_texts"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/employee/account/change" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
            //刷新新的成员列表
            self.page = 1;
            [self requestData];
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"]];
        }
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
}

#pragma mark ----- 根节点获取指定非直属下属的公钥信息 -----
- (void)employeePubkeysInfo:(NSString *)appAccountId completeLoad:(void (^)(MenberInfoModel *completeModel))complete{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"manager_account_id"];
    [paramsDic setObject:appAccountId forKey:@"employee_account_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/accounts/employee/info" params:paramsDic success:^(id responseObject) {
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
                    complete(menberInfoModel);
                }else{
                   complete(nil);
                }
            }else{
                complete(nil);
            }
        }else{
            [ProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        complete(nil);
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
