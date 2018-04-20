//
//  SearchApprovalViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchApprovalViewController.h"
#import "ApprovalBusinessTableViewCell.h"
#import "ApprovalBusinessDetailViewController.h"
#import "CreateApprovalFlowViewController.h"

#define PageSize  12
#define CellReuseIdentifier  @"ApprovalBusiness"
#define ApprovalBusinessVCTitle  @"审批流"
#define ApprovalBusinessVCCreateBtn  @"创建"

@interface SearchApprovalViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic, strong)UILabel *labelTip;
@property (nonatomic, strong) UITextField *searchField;

@end

@implementation SearchApprovalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
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
    [paramsDic setObject: @(_page) forKey:@"page"];
    [paramsDic setObject:@(PageSize) forKey:@"limit"];
    [paramsDic setObject: _searchField.text forKey:@"key_words"];
    //[ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/business/flows/list" params:paramsDic success:^(id responseObject) {
        //[WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            if (_page == 1) {
                [_sourceArray removeAllObjects];
            }
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *listDic in listArray) {
                ApprovalBusinessModel *model = [[ApprovalBusinessModel alloc] initWithDict:listDic];
                [_sourceArray addObject:model];
            }
            
        }else{
            [ProgressHUD showStatus:[dict[@"code"] integerValue]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        //[WSProgressHUD dismiss];
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
    [_tableView registerClass:[ApprovalBusinessTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self footerReflesh];
    [self headerReflesh];
}


#pragma mark ----- rightBarButtonItemAction -----
- (void)rightButtonAction:(UIBarButtonItem *)buttonItem{
    CreateApprovalFlowViewController *createApprovalFlowVc = [[CreateApprovalFlowViewController alloc] init];
    UINavigationController *createApprovalFlowNc = [[UINavigationController alloc] initWithRootViewController:createApprovalFlowVc];
    [self presentViewController:createApprovalFlowNc animated:YES completion:nil];
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApprovalBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    ApprovalBusinessModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApprovalBusinessModel *model = self.sourceArray[indexPath.row];
    self.approvalBlock(model);
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
    _searchField.placeholder = @"搜索审批流";
    _searchField.font = [UIFont systemFontOfSize:14];
    _searchField.delegate = self;
    _searchField.rightViewMode = UITextFieldViewModeWhileEditing;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.returnKeyType = UIReturnKeySearch;
    [titleSubView addSubview:self.searchField];
    
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonAction:)];
    //字体颜色
    //    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#50b4ff"]];
    
    self.navigationItem.rightBarButtonItem = buttonRight;
    //字体大小
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
}

-(void)cancelButtonAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    _page = 1;
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject: textField.text forKey:@"key_words"];
    [paramsDic setObject: @(_page) forKey:@"page"];
    [paramsDic setObject:@(PageSize) forKey:@"limit"];
    //[ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/business/flows/list" params:paramsDic success:^(id responseObject) {
        //[WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            if (_page == 1) {
                [_sourceArray removeAllObjects];
            }
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *listDic in listArray) {
                ApprovalBusinessModel *model = [[ApprovalBusinessModel alloc] initWithDict:listDic];
                [_sourceArray addObject:model];
            }
            
        }else{
            [ProgressHUD showStatus:[dict[@"code"] integerValue]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        //[WSProgressHUD dismiss];
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
