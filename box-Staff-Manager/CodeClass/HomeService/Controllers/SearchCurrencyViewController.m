//
//  SearchCurrencyViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchCurrencyViewController.h"
#import "SearchCurrencyTableViewCell.h"

#define PageSize  12
#define CellReuseIdentifier  @"SearchCurrency"

@interface SearchCurrencyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation SearchCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _selectArray = [[NSMutableArray alloc] init];
    _sourceArray = [[NSMutableArray alloc] init];
    [self createTitle];
    [self createView];
    _page = 1;
    [self requestData];
}

#pragma mark ----- 数据请求 -----
-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/capital/currency/list" params:paramsDic success:^(id responseObject)
     {
         NSDictionary *dict = responseObject;
         if ([dict[@"code"] integerValue] == 0) {
             if (_page == 1) {
                 [_sourceArray removeAllObjects];
             }
             NSArray *listArr = dict[@"data"][@"currency_list"];
             for (NSDictionary *listDic in listArr) {
                 CurrencyModel *model = [[CurrencyModel alloc] initWithDict:listDic];
                 for (CurrencyModel *currencyModel in _currencyArray) {
                     if ([currencyModel.currency  isEqualToString:model.currency]) {
                         model.select = currencyModel.select;
                         model.state = currencyModel.state;
                     }
                 }
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

-(void)reloadAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
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
    [_tableView registerClass:[SearchCurrencyTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    CurrencyModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyModel *model = self.sourceArray[indexPath.row];
    if (model.state != 2) {
        model.select = !model.select;
        if (model.select) {
            model.state = 1;
        }else{
            model.state = 0;
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)createTitle
{
    UIView *titleBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    titleBgView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleBgView;
    
    UIView *titleSubView = [[UIView alloc] initWithFrame:CGRectMake(titleBgView.frame.origin.x, 0, SCREEN_WIDTH - 20 - 65 - 16, 30)];
    titleSubView.backgroundColor = [UIColor colorWithHexString:@"#eeeeef"];
    titleSubView.layer.masksToBounds = YES;
    titleSubView.layer.cornerRadius = 15.0;
    [titleBgView addSubview:titleSubView];
    
    UIImageView *searchImagePic = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14, 14)];
    searchImagePic.image = [UIImage imageNamed:@"searchImagePic_icon"];
    searchImagePic.contentMode = UIViewContentModeScaleAspectFit;
    [titleSubView addSubview:searchImagePic];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(searchImagePic.frame.origin.x + 14 + 5, 0, SCREEN_WIDTH - 20 - 65 - 10- 14 -5 - 16, 30)];
    _searchField.placeholder = SearchCurrency;
    _searchField.font = [UIFont systemFontOfSize:13];
    _searchField.delegate = self;
    _searchField.rightViewMode = UITextFieldViewModeWhileEditing;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.returnKeyType = UIReturnKeySearch;
    [titleSubView addSubview:self.searchField];
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:AddDepartmentVCComplete style:UIBarButtonItemStyleDone target:self action:@selector(completeButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
    self.navigationItem.leftBarButtonItem.customView.hidden=YES;
    [self createBarItem];
}

#pragma mark ----- createBarItem -----
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

-(void)completeButtonAction:(UIBarButtonItem *)barButtonItem
{
    for (CurrencyModel *currencyModel in _sourceArray) {
        if (currencyModel.select) {
            if (currencyModel.state == 1) {
                currencyModel.state = 2;
                [_selectArray addObject:currencyModel];
            }
            
        }
    }
    self.searchCurrencyBlock(_selectArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    _page = 1;
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [paramsDic setObject:textField.text forKey:@"key_words"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/capital/currency/list" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            if (_page == 1) {
                [_sourceArray removeAllObjects];
            }
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *listDic in listArray) {
                CurrencyModel *model = [[CurrencyModel alloc] initWithDict:listDic];
                for (CurrencyModel *currencyModel in _currencyArray) {
                    if ([currencyModel.currency  isEqualToString:model.currency]) {
                        model.select = currencyModel.select;
                        model.state = currencyModel.state;
                    }
                }
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
