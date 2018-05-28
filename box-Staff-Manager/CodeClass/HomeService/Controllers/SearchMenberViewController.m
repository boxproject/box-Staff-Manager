//
//  SearchMenberViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchMenberViewController.h"
#import "OrganizationTableViewCell.h"
#import "OrganizationModel.h"

#define PageSize  12
#define CellReuseIdentifier  @"SearchMenber"

@interface SearchMenberViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic, strong)UILabel *labelTip;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic,strong) DDRSAWrapper *aWrapper;

@end

@implementation SearchMenberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createTitle];
    [self createView];
    _page = 1;
    [self requestData];
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
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [_tableView registerClass:[OrganizationTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
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
        [self requestData];
    }];
}

-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject: @(_page) forKey:@"page"];
    [paramsDic setObject:@(PageSize) forKey:@"limit"];
    [paramsDic setObject:_searchField.text forKey:@"key_words"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/accounts/list" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            if (_page == 1) {
                [_sourceArray removeAllObjects];
            }
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *listDic in listArray) {
                SearchMenberModel *model = [[SearchMenberModel alloc] initWithDict:listDic];
                if (![model.app_account_id isEqualToString:_employee_account_id]) {
                    [_sourceArray addObject:model];
                }
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
    dispatch_async(dispatch_get_main_queue(), ^{
        SearchMenberModel *model = self.sourceArray[indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //获取该下属下属账号详情
            [self gainAccountsInfo:model];
        }];
        [alert addAction:actionOk];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark ----- 获取下属账号详情 -----
-(void)gainAccountsInfo:(SearchMenberModel *)model
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"manager_account_id"];
    [paramsDic setObject:_employee_account_id forKey:@"employee_account_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/accounts/info" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *listArray = dict[@"data"][@"employee_accounts_info"];
            NSMutableArray *employeeInfoArr = [[NSMutableArray alloc] init];
            NSArray *replaceMenberArr = [[MenberInfoManager sharedManager] loadMenberInfo:_employee_account_id];
            NSArray *menberArr = [[MenberInfoManager sharedManager] loadMenberInfo:model.app_account_id];
            if (replaceMenberArr.count == 0 || menberArr == 0) {
                return ;
            }
            //替换者
            MenberInfoModel *replaceMenberModel = [[MenberInfoManager sharedManager] loadMenberInfo:_employee_account_id][0];
            //被替换者
            MenberInfoModel *menberModel = [[MenberInfoManager sharedManager] loadMenberInfo:model.app_account_id][0];
            for (NSDictionary *dic in listArray) {
                NSString *app_account_id = dic[@"app_account_id"];
                NSString *cipher_text = dic[@"cipher_text"];
                NSArray *menberEmployeeArr = [[MenberInfoManager sharedManager] loadMenberInfo:app_account_id];
                if (menberEmployeeArr.count == 0) {
                    return;
                }
                //下属员工
                MenberInfoModel *menberEmployeeModel = [[MenberInfoManager sharedManager] loadMenberInfo:app_account_id][0];
                //被替换者
                NSString *menber_random = menberModel.menber_random;
                //替换者
                NSString *replace_menber_random = replaceMenberModel.menber_random;
                //替换者下属
                NSString *employee_publicKey = menberEmployeeModel.publicKey;
                if (employee_publicKey != nil && menber_random != nil && replace_menber_random != nil) {
                    NSString *employeeHmacSHA256 = [UIARSAHandler hmac:employee_publicKey withKey:replace_menber_random];
                    if ([cipher_text isEqualToString:employeeHmacSHA256]) {
                        NSString *hmacSHA256 = [UIARSAHandler hmac: employee_publicKey withKey:menber_random];
                        NSDictionary *employeeDic = @{
                                                      @"app_account_id":app_account_id,
                                                      @"cipher_text":hmacSHA256
                                                      };
                        [employeeInfoArr addObject:employeeDic];
                    }
                }else{
                    if (employee_publicKey == nil && menber_random != nil && replace_menber_random != nil) {
                        [self employeePubkeysInfo:app_account_id completeLoad:^(MenberInfoModel *completeModel) {
                            if (completeModel != nil) {
                                NSString *employeeHmacSHA256 = [UIARSAHandler hmac: completeModel.publicKey withKey:replace_menber_random];
                                if ([cipher_text isEqualToString:employeeHmacSHA256]) {
                                    NSString *hmacSHA256 = [UIARSAHandler hmac:employee_publicKey withKey:menber_random];
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
            //替换该员工账号
            [self replaceEmployeeAccount:model array:employeeInfoArr];
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self reloadAction];
    }];
}

#pragma mark ----- 替换该员工账号 -----
-(void)replaceEmployeeAccount:(SearchMenberModel *)model array:(NSArray *)array
{
    NSString *cipher_texts = [JsonObject dictionaryToarrJson:array];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:_employee_account_id privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:model.app_account_id signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"manager_account_id"];
    [paramsDic setObject:_employee_account_id forKey:@"employee_account_id"];
    [paramsDic setObject:model.app_account_id forKey:@"replacer_account_id"];
    [paramsDic setObject:cipher_texts forKey:@"cipher_texts"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/employee/account/change" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
            if ([self.delegate respondsToSelector:@selector(replaceMenberReflesh)]) {
                [self.delegate replaceMenberReflesh];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
        [self reloadAction];
    }];
}

#pragma mark ----- 根节点获取指定非直属下属的公钥信息 -----
- (void)employeePubkeysInfo:(NSString *)appAccountId completeLoad:(void (^)(MenberInfoModel *completeModel))complete{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"manager_account_id"];
    [paramsDic setObject:appAccountId forKey:@"employee_account_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/accounts/employee/info" params:paramsDic success:^(id responseObject) {
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

-(void)createTitle
{
    //自定义搜索框
    UIView *titleBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    titleBgView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleBgView;
    
    UIView *titleSubView = [[UIView alloc] initWithFrame:CGRectMake(titleBgView.frame.origin.x + 15, 0, SCREEN_WIDTH - 20 - 65, 30)];
    titleSubView.backgroundColor = [UIColor colorWithHexString:@"#eeeeef"];
    titleSubView.layer.masksToBounds = YES;
    titleSubView.layer.cornerRadius = 15.0;
    [titleBgView addSubview:titleSubView];
    
    UIImageView *searchImagePic = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14, 14)];
    searchImagePic.image = [UIImage imageNamed:@"searchImagePic_icon"];
    searchImagePic.contentMode = UIViewContentModeScaleAspectFit;
    [titleSubView addSubview:searchImagePic];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(searchImagePic.frame.origin.x + 14 + 5, 0, SCREEN_WIDTH - 20 - 65 - 10- 14 -5, 30)];
    _searchField.placeholder = @"搜索下属";
    _searchField.font = [UIFont systemFontOfSize:14];
    _searchField.delegate = self;
    _searchField.rightViewMode = UITextFieldViewModeWhileEditing;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.returnKeyType = UIReturnKeySearch;
    [titleSubView addSubview:self.searchField];
    
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    //字体大小
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _page = 1;
    [self requestData];
    [self.view endEditing:YES];
    return YES;
}

-(void)cancelButtonAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
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
