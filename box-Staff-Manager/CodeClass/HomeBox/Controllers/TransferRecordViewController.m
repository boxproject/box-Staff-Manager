//
//  TransferRecordViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferRecordViewController.h"
#import "TransferRecordTableViewCell.h"
#import "TransferRecordDetailViewController.h"
#import "TransferAwaitModel.h"

#define PageSize  12
#define CellReuseIdentifier  @"TransferRecord"

@interface TransferRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

/**< 我发起的／我参与的 */
@property (nonatomic,strong) UISegmentedControl *segmentedView;
@property (nonatomic,strong) UIView *viewLayer;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger type;

@end

@implementation TransferRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createSegmentedView];
    [self createView];
    //0作为发起者
    _type = 0;
    _page = 1;
    [self requestData];
}

#pragma mark ----- 数据请求 -----
-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:@(_type) forKey:@"type"];
    [paramsDic setObject:@(-1) forKey:@"progress"];
    [paramsDic setObject: @(_page) forKey:@"page"];
    [paramsDic setObject:@(PageSize) forKey:@"limit"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/transfer/records/list" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            if (_page == 1) {
                [_sourceArray removeAllObjects];
            }
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *listDic in listArray) {
                TransferAwaitModel *model = [[TransferAwaitModel alloc] initWithDict:listDic];
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

-(void)createSegmentedView
{
    self.navigationItem.titleView = self.viewLayer;
}

- (UIView *)viewLayer{
    if(_viewLayer) return _viewLayer;
    _viewLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _viewLayer.backgroundColor = [UIColor clearColor];
    _segmentedView = [[UISegmentedControl alloc]initWithItems:@[HomeBoxVCInitiate,HomeBoxVCParticipateIn]];
    [_segmentedView addTarget:self action:@selector(segmentedChangle) forControlEvents:UIControlEventValueChanged];
    [_viewLayer addSubview:self.segmentedView];
    self.segmentedView.frame = CGRectMake(30, 0, 200 - 60, 30);
    _segmentedView.selectedSegmentIndex = 0;
    return _viewLayer;
}

-(void)segmentedChangle
{
    if (_segmentedView.selectedSegmentIndex == 0) {
        _page = 1;
        _type = 0;
        [self requestData];
        
    }else{
        _page = 1;
        _type = 1;
        [self requestData];
    }
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
    [_tableView registerClass:[TransferRecordTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
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
    if ([_fromVC isEqualToString:@"transferVC"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    return 59;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TransferRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    TransferAwaitModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TransferAwaitModel *model = self.sourceArray[indexPath.row];
        TransferRecordDetailViewController *transferRecordDetailVc = [[TransferRecordDetailViewController alloc] init];
        transferRecordDetailVc.model = model;
        UINavigationController *transferRecordDetailNc = [[UINavigationController alloc] initWithRootViewController:transferRecordDetailVc];
        [self presentViewController:transferRecordDetailNc animated:NO completion:nil];
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
