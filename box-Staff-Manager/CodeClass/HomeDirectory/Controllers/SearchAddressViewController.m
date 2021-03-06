//
//  SearchAddressViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchAddressViewController.h"
#import "SearchAddressTableViewCell.h"
#import "SearchAddressModel.h"

#define PageSize  12
#define CellReuseIdentifier  @"SearchAddress"

@interface SearchAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic, strong)UILabel *labelTip;
@property (nonatomic, strong) UITextField *searchField;

@end

@implementation SearchAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createTitle];
    [self createView];
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
    [_tableView registerClass:[SearchAddressTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self headerReflesh];
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
    [paramsDic setObject: _searchField.text forKey:@"key_words"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/capital/currency/list" params:paramsDic success:^(id responseObject)
    {
        [_sourceArray removeAllObjects];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            for (NSDictionary *dataDic in dict[@"data"][@"currency_list"]) {
                SearchAddressModel *model = [[SearchAddressModel alloc] initWithDict:dataDic];
                [_sourceArray addObject:model];
            }
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    SearchAddressModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchAddressModel *model = self.sourceArray[indexPath.row];
    self.currencyBlock(model.currency);
    [self.navigationController popViewControllerAnimated:YES];
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
    _searchField.placeholder = SearchCurrency;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
