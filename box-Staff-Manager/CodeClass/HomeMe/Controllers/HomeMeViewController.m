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

#define HomeMeVCTitle  @"我"
#define CellReuseIdentifier  @"HomeMe"

@interface HomeMeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;

@end

@implementation HomeMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createView];
    NSString *applyer_account = [BoxDataManager sharedManager].applyer_account;
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"titleName":@"用户名", @"subTitle":applyer_account},
                                   @{@"titleName":@"账户地址", @"subTitle":@""},
                                   @{@"titleName":@"绑定二维码", @"subTitle":@""},
                                   @{@"titleName":@"服务器地址", @"subTitle":@""},
                                   @{@"titleName":@"修改密码", @"subTitle":@""},
                                   @{@"titleName":@"关于BOX", @"subTitle":@""}
                                   ]
                           };
    
    for (NSDictionary *dataDic in dict[@"data"]) {
        HomeMeModel *model = [[HomeMeModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
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
    if (indexPath.row == 1) {
        AccountAdressViewController *accountAdressVc = [[AccountAdressViewController alloc] init];
        accountAdressVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountAdressVc animated:YES];
        
    }else if(indexPath.row == 2){
        dispatch_async(dispatch_get_main_queue(), ^{
            ScanAdressViewController *scanAdressVC = [[ScanAdressViewController alloc] init];
            UINavigationController *scanAdressNV = [[UINavigationController alloc] initWithRootViewController:scanAdressVC];
            [self presentViewController:scanAdressNV animated:NO completion:nil];
        });
        
    }else if(indexPath.row == 3){
        ModifyServerAddressViewController *modifyAdress = [[ModifyServerAddressViewController alloc] init];
        [self.navigationController pushViewController:modifyAdress animated:YES];
        
    }else if(indexPath.row == 4){
        ModificatePasswordViewController *modificatePasswordVc = [[ModificatePasswordViewController alloc] init];
        [self.navigationController pushViewController:modificatePasswordVc animated:YES];
        
    }else if(indexPath.row == 5){
        AboutBoxViewController *aboutBoxVc = [[AboutBoxViewController alloc] init];
        aboutBoxVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutBoxVc animated:YES];
        
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
