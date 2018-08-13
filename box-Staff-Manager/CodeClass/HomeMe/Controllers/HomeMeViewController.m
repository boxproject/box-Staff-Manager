//
//  HomeMeViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeMeViewController.h"
#import "HomeMeTableViewCell.h"
#import "HomeMeModel.h"
#import "AboutBoxViewController.h"
#import "AccountAdressViewController.h"
#import "ScanAdressViewController.h"
#import "ModificatePasswordViewController.h"
#import "ModifyServerAddressViewController.h"
#import "DepartmentModel.h"
#import "LanguageSwitchViewController.h"

#define CellReuseIdentifier  @"HomeMe"

@interface HomeMeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger typeIn;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic, strong)NSMutableArray *departmentArray;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;
@property (nonatomic, strong)PickerModel *pickerModel;

@end

@implementation HomeMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    _departmentArray = [[NSMutableArray alloc] init];
    [self createView];
    _aWrapper = [[DDRSAWrapper alloc] init];
    NSString *applyer_account = [BoxDataManager sharedManager].applyer_account;
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"titleName":UserName, @"subTitle":applyer_account, @"type":@"account"},
                                   @{@"titleName":AccountAddress, @"subTitle":@"",@"type":@"currency"},
                                   @{@"titleName":BindCode, @"subTitle":@"",@"type":@"QRCode"},
                                   @{@"titleName":ServerAddress, @"subTitle":@"",@"type":@"server"},
                                   @{@"titleName":Departments, @"subTitle":PleaseSelect,@"type":@"department"},
                                   @{@"titleName":ModifyPassword, @"subTitle":@"",@"type":@"pwd"},
                                   @{@"titleName":LanguageSwitchTitle, @"subTitle":@"",@"type":@"language"},
                                   @{@"titleName":AboutBOX, @"subTitle":@"",@"type":@"box"}
                                   ]
                           };
    
    for (NSDictionary *dataDic in dict[@"data"]) {
        HomeMeModel *model = [[HomeMeModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
    [self getAccountsDetail];
}

#pragma mark ----- get accounts detail -----
-(void)getAccountsDetail
{
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:[BoxDataManager sharedManager].app_account_id privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/accounts/detail" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSDictionary *departmentDic = dict[@"data"][@"Department"];
            NSString *Name = departmentDic[@"Name"];
            NSString *ID = [NSString stringWithFormat:@"%ld", [departmentDic[@"ID"] integerValue]];
            if ([ID integerValue] == 1) {
                Name = Other;
            }
            NSDictionary *dic = @{@"titleName":Departments, @"subTitle":Name,@"type":@"department"};
            HomeMeModel *model = [[HomeMeModel alloc] initWithDict:dic];
            [_sourceArray replaceObjectAtIndex:4 withObject:model];
            [[BoxDataManager sharedManager] saveDataWithCoding:@"departMemtName" codeValue:Name];
            [[BoxDataManager sharedManager] saveDataWithCoding:@"ID" codeValue:ID];
            _pickerModel = [[PickerModel alloc] init];
            _pickerModel.title = Name;
            _pickerModel.ID = [ID integerValue];
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
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.right.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
    [_tableView registerClass:[HomeMeTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self headerReflesh];
}

-(void)headerReflesh
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getAccountsDetail];
    }];
}
 
#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    HomeMeModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model row:indexPath.row];
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeMeModel *model = self.sourceArray[indexPath.row];
    if ([model.type isEqualToString:@"currency"]) {
        AccountAdressViewController *accountAdressVc = [[AccountAdressViewController alloc] init];
        accountAdressVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountAdressVc animated:YES];
    }else if([model.type isEqualToString:@"QRCode"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            ScanAdressViewController *scanAdressVC = [[ScanAdressViewController alloc] init];
            UINavigationController *scanAdressNV = [[UINavigationController alloc] initWithRootViewController:scanAdressVC];
            [self presentViewController:scanAdressNV animated:NO completion:nil];
        });
    }else if([model.type isEqualToString:@"server"]){
        ModifyServerAddressViewController *modifyAdress = [[ModifyServerAddressViewController alloc] init];
        [self.navigationController pushViewController:modifyAdress animated:YES];
    }
    else if([model.type isEqualToString:@"pwd"]){
        ModificatePasswordViewController *modificatePasswordVc = [[ModificatePasswordViewController alloc] init];
        [self.navigationController pushViewController:modificatePasswordVc animated:YES];
    }
    else if([model.type isEqualToString:@"department"]){
        [self getDepartmentList];
    }else if([model.type isEqualToString:@"box"]){
        AboutBoxViewController *aboutBoxVc = [[AboutBoxViewController alloc] init];
        aboutBoxVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutBoxVc animated:YES];
    }else if([model.type isEqualToString:@"language"]){
        LanguageSwitchViewController *languageSwitchVc = [[LanguageSwitchViewController alloc] init];
        languageSwitchVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:languageSwitchVc animated:YES];
    }
}

#pragma mark ----- 获取部门列表 -----
-(void)getDepartmentList
{
    if (typeIn == 1) {
        return;
    }
    typeIn = 1;
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/branch/list" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *listArray = dict[@"data"][@"list"];
            [_departmentArray removeAllObjects];
            for (NSDictionary *listDic in listArray) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithDict:listDic];
                if ([model.Name isEqualToString:@"其他"]) {
                    model.Name = Other;
                }
                PickerModel *pickerModel = [[PickerModel alloc] init];
                pickerModel.title = model.Name;
                pickerModel.ID = model.ID;
                [_departmentArray addObject:pickerModel];
            }
            typeIn = 0;
            [self showPickerView];
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
        }
    } fail:^(NSError *error) {
        typeIn = 0;
        NSLog(@"%@", error.description);
    }];
}

-(void)showPickerView
{
    self.pickerView = [[ValuePickerView alloc]init];
    if (_pickerModel == nil) {
        NSInteger countIn = 0;
        countIn = _departmentArray.count/2;
        if (_departmentArray.count == 1) {
            countIn = 1;
        }
        PickerModel *model = _departmentArray[countIn - 1];
        [_departmentArray addObject:model];
    }else{
        [_departmentArray addObject:_pickerModel];
    }
    self.pickerView.dataSource = _departmentArray;
    self.pickerView.pickerTitle = SelectDepartmemt;
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(PickerModel *pickerModel){
        [weakSelf finishSelectDepartment:pickerModel];
        weakSelf.pickerModel = pickerModel;
    };
    [self.pickerView show];
}

-(void)finishSelectDepartment:(PickerModel *)pickerModel
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:@(pickerModel.ID) forKey:@"bid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/branch/select" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSDictionary *dic = @{@"titleName":Departments, @"subTitle":pickerModel.title,@"type":@"department"};
            HomeMeModel *model = [[HomeMeModel alloc] initWithDict:dic];
            [weakSelf.sourceArray replaceObjectAtIndex:4 withObject:model];
            [weakSelf.tableView reloadData];
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
