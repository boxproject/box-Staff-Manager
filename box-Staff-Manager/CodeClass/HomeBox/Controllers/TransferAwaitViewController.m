//
//  TransferAwaitViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferAwaitViewController.h"
#import "TransferAwaitTableViewCell.h"
#import "TransferAwaitModel.h"
#import "TransferAwaitDetailViewController.h"

#define PageSize  12
#define CellReuseIdentifier  @"TransferAwait"
#define TransferAwaitVCTitle  @"待审批转账"

@interface TransferAwaitViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation TransferAwaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    self.title = TransferAwaitVCTitle;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createView];
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"approvalTitle":@"二秒科技待审批一", @"approvalState":@(0)},
                                   @{@"approvalTitle":@"二秒科技待审批二", @"approvalState":@(0)},
                                   @{@"approvalTitle":@"二秒科技待审批三", @"approvalState":@(1)},
                                   @{@"approvalTitle":@"二秒科技待审批四", @"approvalState":@(2)},
                                   @{@"approvalTitle":@"二秒科技待审批五", @"approvalState":@(1)},
                                   @{@"approvalTitle":@"二秒科技待审批六", @"approvalState":@(1)},
                                   @{@"approvalTitle":@"二秒科技待审批七", @"approvalState":@(0)}
                                   ]
                           
                           };
    
    
    for (NSDictionary *dataDic in dict[@"data"]) {
        TransferAwaitModel *model = [[TransferAwaitModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
}

-(void)createView
{
    [self createBarItem];
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
    [_tableView registerClass:[TransferAwaitTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
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
    
    TransferAwaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    TransferAwaitModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        TransferAwaitModel *model = self.sourceArray[indexPath.row];
        TransferAwaitDetailViewController *transferAwaitDetailVc = [[TransferAwaitDetailViewController alloc] init];
        UINavigationController *transferAwaitDetailNc = [[UINavigationController alloc] initWithRootViewController:transferAwaitDetailVc];
        [self presentViewController:transferAwaitDetailNc animated:NO completion:nil];
    });
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
