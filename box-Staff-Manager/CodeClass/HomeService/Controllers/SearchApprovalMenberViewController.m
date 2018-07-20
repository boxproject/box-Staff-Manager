//
//  SearchApprovalMenberViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/8.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchApprovalMenberViewController.h"
#import "SearchMenberTableViewCell.h"
#import "SearchMenberModel.h"
#import "AddApprovalMenberViewController.h"
#import "ApprovalBusApproversModel.h"

#define PageSize  12
#define CellReuseIdentifier  @"SearchApprovalMenber"

@interface SearchApprovalMenberViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic, strong) UITextField *searchField;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation SearchApprovalMenberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createTitle];
    [self createView];
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
    _searchField.placeholder = SearchMember;
    _searchField.font = [UIFont systemFontOfSize:14];
    _searchField.delegate = self;
    _searchField.rightViewMode = UITextFieldViewModeWhileEditing;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.returnKeyType = UIReturnKeySearch;
    [titleSubView addSubview:self.searchField];
    
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:Cancel style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    //字体大小
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
}

-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject: @(_page) forKey:@"page"];
    [paramsDic setObject:@(PageSize) forKey:@"limit"];
    [paramsDic setObject:_searchField.text forKey:@"key_words"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
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
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self reloadAction];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    _page = 1;
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject: @(_page) forKey:@"page"];
    [paramsDic setObject:@(PageSize) forKey:@"limit"];
    [paramsDic setObject:textField.text forKey:@"key_words"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
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
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self reloadAction];
    }];
    return YES;
}

-(void)cancelButtonAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [_tableView registerClass:[SearchMenberTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
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

-(void)reloadAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1.00];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 40)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = [UIColor colorWithHexString:@"#4380fa"];
    [headerView addSubview:lb];
    if (section == 0) {
        lb.text = AddApprovalMenberVCSectionOne;
    }else if(section == 1){
        lb.text = AddApprovalMenberVCSectionTwo;
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchMenberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    SearchMenberModel *model = self.sourceArray[indexPath.row];
    cell.array = _addArray;
    cell.model = model;
    [cell setDataWithModel:model indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SearchMenberModel *model = self.sourceArray[indexPath.row];
        if ([model.app_account_id  isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
            return;
        }
        if (model.employee_num > 0) {
            AddApprovalMenberViewController *addApprovalMenberVc = [[AddApprovalMenberViewController alloc] init];
            addApprovalMenberVc.addArray = _addArray;
            addApprovalMenberVc.app_account_id = model.app_account_id;
            [self.navigationController pushViewController:addApprovalMenberVc animated:YES];
        }
    }else if (indexPath.section == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SearchMenberModel *model = self.sourceArray[indexPath.row];
            for (ApprovalBusApproversModel *approvalBusModel in _addArray) {
                if ([approvalBusModel.app_account_id  isEqualToString:model.app_account_id]) {
                    return;
                }
            }
            NSArray *array = [[MenberInfoManager sharedManager] loadMenberInfo:model.app_account_id];
            if (array.count == 0) {
                if ([model.app_account_id  isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
                    NSDictionary *dic = @{
                                          @"account":[BoxDataManager sharedManager].applyer_account,
                                          @"app_account_id":[BoxDataManager sharedManager].app_account_id,
                                          @"pub_key":[BoxDataManager sharedManager].publicKeyBase64,
                                          @"itemType":@(0)
                                          };
                    ApprovalBusApproversModel *approvalBusApproversModel = [[ApprovalBusApproversModel alloc] initWithDict:dic];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"addMenber" object:approvalBusApproversModel];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    return;
                }
                [self employeePubkeysInfo:model];
            }else{
                MenberInfoModel *menberInfoModel = array[0];
                NSDictionary *dic = @{
                                      @"account":model.account,
                                      @"app_account_id":model.app_account_id,
                                      @"pub_key":menberInfoModel.publicKey,
                                      @"itemType":@(0)
                                      };
                ApprovalBusApproversModel *approvalBusApproversModel = [[ApprovalBusApproversModel alloc] initWithDict:dic];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addMenber" object:approvalBusApproversModel];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }
}

#pragma mark ----- 根节点获取指定非直属下属的公钥信息 -----
-(void)employeePubkeysInfo:(SearchMenberModel *)model{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"manager_account_id"];
    [paramsDic setObject:model.app_account_id forKey:@"employee_account_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    //[ProgressHUD showProgressHUD];
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
                    
                    NSDictionary *dic = @{
                                          @"account":model.account,
                                          @"app_account_id":model.app_account_id,
                                          @"pub_key":pub_key,
                                          @"itemType":@(0)
                                          };
                    ApprovalBusApproversModel *approvalBusApproversModel = [[ApprovalBusApproversModel alloc] initWithDict:dic];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"addMenber" object:approvalBusApproversModel];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }else{
            [ProgressHUD showErrorWithStatus:responseObject[@"message"] code:[responseObject[@"code"] integerValue]];
        }
        
    } fail:^(NSError *error) {
        //[WSProgressHUD dismiss];
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
