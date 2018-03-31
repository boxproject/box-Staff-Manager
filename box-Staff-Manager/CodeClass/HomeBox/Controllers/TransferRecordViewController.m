//
//  TransferRecordViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferRecordViewController.h"
#import "TransferRecordTableViewCell.h"
#import "TransferRecordModel.h"
#import "TransferRecordDetailViewController.h"

#define CellReuseIdentifier  @"TransferRecord"

@interface TransferRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

/**< 我发起的／我参与的 */
@property (nonatomic,strong) UISegmentedControl *segmentedView;
@property (nonatomic,strong) UIView *viewLayer;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation TransferRecordViewController

//@property (nonatomic,strong) NSString *topLeft;
//@property (nonatomic,assign) NSInteger timeIn;
//@property (nonatomic,strong) NSString *topRight;
//@property(nonatomic, assign) TransferState tansferStateState;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    //self.title = _titleName;
    _sourceArray = [[NSMutableArray alloc] init];
    NSInteger currentTime = [[NSDate date]timeIntervalSince1970] * 1000;
    [self createSegmentedView];
    [self createView];
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"topLeft":@"用于黄大大买EOS", @"timeIn":@(currentTime),@"topRight":@"-50.98ETH", @"tansferStateState":@(2)},
                                   @{@"topLeft":@"用于黄大大买EOS", @"timeIn":@(currentTime),@"topRight":@"-50.98ETH", @"tansferStateState":@(2)},
                                   @{@"topLeft":@"用于黄大大买EOS", @"timeIn":@(currentTime),@"topRight":@"-50.98ETH", @"tansferStateState":@(2)},
                                   @{@"topLeft":@"用于黄大大买EOS", @"timeIn":@(currentTime),@"topRight":@"50.98ETH", @"tansferStateState":@(2)},
                                   @{@"topLeft":@"用于黄大大买EOS", @"timeIn":@(currentTime),@"topRight":@"-50.98ETH", @"tansferStateState":@(2)},
                                   @{@"topLeft":@"用于黄大大买BOX", @"timeIn":@(currentTime),@"topRight":@"-50.98ETH", @"tansferStateState":@(1)},
                                   @{@"topLeft":@"用于黄大大买BOX", @"timeIn":@(currentTime),@"topRight":@"-50.98ETH", @"tansferStateState":@(1)},
                                   @{@"topLeft":@"用于黄大大买BOX", @"timeIn":@(currentTime),@"topRight":@"-50.98ETH", @"tansferStateState":@(1)}
                                   ]
                           
                           };
    
    
    for (NSDictionary *dataDic in dict[@"data"]) {
        TransferRecordModel *model = [[TransferRecordModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
    
    
}

-(void)createSegmentedView
{
    self.navigationItem.titleView = self.viewLayer;
}

- (UIView *)viewLayer{
    if(_viewLayer) return _viewLayer;
    _viewLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _viewLayer.backgroundColor = [UIColor clearColor];
    _segmentedView = [[UISegmentedControl alloc]initWithItems:@[@"我发起的",@"我参与的"]];
    [_segmentedView addTarget:self action:@selector(segmentedChangle) forControlEvents:UIControlEventValueChanged];
    [_viewLayer addSubview:self.segmentedView];
    self.segmentedView.frame = CGRectMake(30, 0, 200 - 60, 30);
    _segmentedView.selectedSegmentIndex = 0;
    return _viewLayer;
}


-(void)segmentedChangle
{
    if (_segmentedView.selectedSegmentIndex == 1) {
        //[_sourceArray removeAllObjects];
        //[self.tableView reloadData];
    }else{
        //[_sourceArray removeAllObjects];
        //[self.tableView reloadData];
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
    }];
}

-(void)requestData
{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TransferRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    TransferRecordModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TransferRecordModel *model = self.sourceArray[indexPath.row];
        TransferRecordDetailViewController *transferRecordDetailVc = [[TransferRecordDetailViewController alloc] init];
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
