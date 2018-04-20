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
    if (![[BoxDataManager sharedManager].depth isEqualToString:@"0"]) {
        [_sourceArray removeObjectAtIndex:2];
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
        [self.navigationController pushViewController:organizationVc animated:YES];
    }else if(indexPath.row == 2){
        AssetAmountViewController *assetAmount = [[AssetAmountViewController alloc] init];
        assetAmount.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:assetAmount animated:YES];
    }
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
