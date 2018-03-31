//
//  HomeServiceViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeServiceViewController.h"
#import "HomeSeviceTableViewCell.h"
#import "HomeServiceModel.h"
#import "ApprovalBusinessViewController.h"
#import "OrganizationViewController.h"
#import "AssetAmountViewController.h"

#define HomeServiceVCTitle  @"服务"
#define CellReuseIdentifier  @"HomeService"

@interface HomeServiceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation HomeServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = HomeServiceVCTitle;
    
    _sourceArray = [[NSMutableArray alloc] init];
    [self createView];
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"titleName":@"审批流", @"imgTitle":@"icon_service_shenpi"},
                                   @{@"titleName":@"组织", @"imgTitle":@"icon_service_zuzhi"},
                                   @{@"titleName":@"财务", @"imgTitle":@"icon_service_finance"}
                                   ]
                           };
    
    for (NSDictionary *dataDic in dict[@"data"]) {
        HomeServiceModel *model = [[HomeServiceModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
    
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
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
    [_tableView registerClass:[HomeSeviceTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
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

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    }];
}

-(void)requestData
{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeSeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    HomeServiceModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ApprovalBusinessViewController *approvalBusinessVc = [[ApprovalBusinessViewController alloc] init];
        approvalBusinessVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:approvalBusinessVc animated:YES];
    }else if(indexPath.row == 1){
        OrganizationViewController *organizationVc = [[OrganizationViewController alloc] init];
        organizationVc.hidesBottomBarWhenPushed = YES;
        organizationVc.superiorTitle = @"上海科技有限公司";
        organizationVc.fromService = 1;
        [self.navigationController pushViewController:organizationVc animated:YES];
    }else if(indexPath.row == 2){
        AssetAmountViewController *assetAmount = [[AssetAmountViewController alloc] init];
        assetAmount.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:assetAmount animated:YES];
    }
}


/**
 *  左滑cell时出现什么按钮
 */
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//
//        // 收回左滑出现的按钮(退出编辑模式)
//        tableView.editing = NO;
//    }];
//
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [self.sourceArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
//
//    return @[action1, action0];
//}



/**
 *  只要实现了这个方法，左滑出现Delete按钮的功能就有了
 *  点击了“左滑出现的Delete按钮”会调用这个方法
 */
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    [self.sourceArray removeObjectAtIndex:indexPath.row];
    
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}
 */

/**
 *  修改Delete按钮文字为“删除”
 */
/*
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
 */




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
