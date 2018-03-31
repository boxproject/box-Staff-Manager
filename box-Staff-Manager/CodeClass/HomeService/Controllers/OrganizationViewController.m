//
//  OrganizationViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "OrganizationViewController.h"
#import "OrganizationTableViewCell.h"
#import "OrganizationModel.h"
#import "OrganizationListViewController.h"
#import "SearchMenberViewController.h"

#define PageSize  12
#define CellReuseIdentifier  @"Organization"
 

@interface OrganizationViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *topScrollview;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) UILabel *topTitlelab;
@property (nonatomic,strong) UIView *line;
@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _superiorTitle;
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createView];
    
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"titleName":@"王钥匙", @"subTitle":@"90"},
                                   @{@"titleName":@"热狗", @"subTitle":@"0"},
                                   @{@"titleName":@"王钥匙", @"subTitle":@"90"},
                                   @{@"titleName":@"热狗", @"subTitle":@"80"},
                                   @{@"titleName":@"王钥匙", @"subTitle":@"1"},
                                   @{@"titleName":@"热狗", @"subTitle":@"80"},
                                   @{@"titleName":@"王钥匙", @"subTitle":@"90"},
                                   @{@"titleName":@"热狗", @"subTitle":@"80"},
                                   @{@"titleName":@"王钥匙", @"subTitle":@"90"},
                                   @{@"titleName":@"热狗", @"subTitle":@"80"} 
                                   ]
                           
                           };
    
    
    for (NSDictionary *dataDic in dict[@"data"]) {
        OrganizationModel *model = [[OrganizationModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
    
}

-(void)createView
{
    [self createBarItem];
    
    if (_fromService == 0) {
        _topScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, 60)];
        _topScrollview.delegate = self;
        _topScrollview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _topScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 60);
        _topScrollview.showsVerticalScrollIndicator = NO;
        _topScrollview.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_topScrollview];
        
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [self.view addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topScrollview.mas_bottom).offset(0);
            make.left.offset(0);
            make.right.offset(-0);
            make.height.offset(1);
        }];
        
        _topTitlelab = [[UILabel alloc] init];
        _topTitlelab.font = Font(14);
        _topTitlelab.text = _currentTitle;
        CGSize size = [_topTitlelab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName,nil]];
        if (size.width + 30 > CGRectGetWidth(self.view.frame)) {
            _topScrollview.contentOffset = CGPointMake(size.width + 30 + 15, 0);
            _topScrollview.contentSize = CGSizeMake(size.width + 30 + 15, 60);
            
        }
        _topTitlelab.textColor = [UIColor colorWithHexString:@"#4c7afd"];
        [_topScrollview addSubview:_topTitlelab];
        [_topTitlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(15);
            make.height.offset(60);
        }];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        if (_fromService == 1) {
            make.top.offset(0);
            
        }else{
            make.top.equalTo(_line.mas_bottom).offset(0);
        }
        make.right.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [_tableView registerClass:[OrganizationTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
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


#pragma mark ----- backAction -----
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
    
    OrganizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    OrganizationModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationModel *model = self.sourceArray[indexPath.row];
    if ([model.subTitle integerValue] == 0) {
        return;
    }
    OrganizationListViewController *organizationListVc = [[OrganizationListViewController alloc] init];
    if (_fromService == 1) {
        organizationListVc.currentTitle = [NSString stringWithFormat:@"%@ > %@", _superiorTitle, model.titleName];
    }else{
        organizationListVc.currentTitle = [NSString stringWithFormat:@"%@ > %@", _currentTitle, model.titleName];
    }
    
    organizationListVc.superiorTitle = model.titleName;
    [self.navigationController pushViewController:organizationListVc animated:YES];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationModel *model = self.sourceArray[indexPath.row];
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"替换" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 收回左滑出现的按钮(退出编辑模式)
        //tableView.editing = NO;
        SearchMenberViewController *searchMenberVc = [[SearchMenberViewController alloc] init];
        searchMenberVc.menberBlock = ^(NSString *text){
            model.titleName = text;
            [self.sourceArray replaceObjectAtIndex:indexPath.row withObject:model];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController pushViewController:searchMenberVc animated:YES];
        
        
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.sourceArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    return @[action1, action0];
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
