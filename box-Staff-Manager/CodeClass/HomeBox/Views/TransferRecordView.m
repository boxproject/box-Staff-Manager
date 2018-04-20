//
//  TransferRecordView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferRecordView.h"
#import "TransferRecordTableViewCell.h"


#define PageSize  12
#define CellReuseIdentifier  @"TransferRecord"

@interface TransferRecordView ()<UITableViewDelegate, UITableViewDataSource>

/**< 我发起的／我参与的 */
@property (nonatomic,strong) UISegmentedControl *segmentedView;
@property (nonatomic,strong) UIView *viewLayer;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) UILabel *labelTip;

@end

@implementation TransferRecordView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.backgroundColor = kWhiteColor;
    //self.title = _titleName;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createSegmentedView];
    [self createTableView];
    //0作为发起者
    _type = 1;
    _page = 1;
    [self requestData];
}


-(void)createSegmentedView{
    _viewLayer = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 10, 200, 30)];
    _viewLayer.backgroundColor = [UIColor clearColor];
    [self addSubview:_viewLayer];
    _segmentedView = [[UISegmentedControl alloc]initWithItems:@[@"我参与的",@"我发起的"]];
    [_segmentedView addTarget:self action:@selector(segmentedChangle) forControlEvents:UIControlEventValueChanged];
    [_viewLayer addSubview:self.segmentedView];
    self.segmentedView.frame = CGRectMake(30, 0, 200 - 60, 30);
    _segmentedView.selectedSegmentIndex = 0;
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
    //[ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/transfer/records/list" params:paramsDic success:^(id responseObject) {
        //[WSProgressHUD dismiss];
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
            [ProgressHUD showStatus:[dict[@"code"] integerValue]];
        }
        if (_sourceArray.count == 0) {
            _labelTip.hidden = NO;
        }else{
            _labelTip.hidden = YES;
        }
        if ([self.delegate respondsToSelector:@selector(refleshViewHight:)]) {
            [self.delegate refleshViewHight:_sourceArray.count];
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

-(void)segmentedChangle
{
    if (_segmentedView.selectedSegmentIndex == 0) {
        _page = 1;
        _type = 1;
        [self requestData];
    }else{
        _page = 1;
        _type = 0;
        [self requestData];
    }
}


-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.scrollEnabled  = NO;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(_viewLayer.mas_bottom).offset(15);
        make.right.offset(-0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    [_tableView registerClass:[TransferRecordTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _labelTip = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 30)];
    _labelTip.text = @"暂无转账记录";
    _labelTip.textAlignment = NSTextAlignmentCenter;
    _labelTip.textColor = [UIColor colorWithHue:0.00 saturation:0.00 brightness:0.66 alpha:1.00];
    _labelTip.font = [UIFont systemFontOfSize:17];
    _labelTip.hidden = NO;
    [_tableView addSubview:_labelTip];
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
    TransferAwaitModel *model = self.sourceArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(transferRecordViewDidTableView:)]) {
        [self.delegate transferRecordViewDidTableView:model];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
