//
//  DepartmentDetailViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "DepartmentDetailViewController.h"
#import "AddDepartmentViewController.h"
#import "Person.h"
#import "DepartmemtInfoModel.h"

#define CellReuseIdentifier  @"DepartmentDetail"

@interface DepartmentDetailViewController () <AddDepartmentDelegate, UITableViewDelegate, UITableViewDataSource>
{
NSMutableArray<Person *> *dataArray;
}
@property (nonatomic,strong) UILabel *departmentDetailLab;
@property (nonatomic,strong) UIImageView *rightImg;
@property (nonatomic,strong) UIButton *departmentBtn;
@property (nonatomic,strong) UILabel *menberLab;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *sourceArray;

@end

@implementation DepartmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = DepartmentDetailVCTitle;
    _sourceArray = [[NSMutableArray alloc] init];
    [self createView];
    [self loadData];
}

//加载数据
-(void)loadData{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:@(_model.ID) forKey:@"bid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/branch/info" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            dataArray = [[NSMutableArray alloc] initWithCapacity:0];
            [_sourceArray removeAllObjects];
            NSArray *listArray = dict[@"data"][@"EmployeesList"];
            for (NSDictionary *listDic in listArray) {
                DepartmemtInfoModel *model = [[DepartmemtInfoModel alloc] initWithDict:listDic];
                [_sourceArray addObject:model.Account];
            }
            for (int i = 0; i<[_sourceArray count]; i++) {
                Person *p = [[Person alloc] init];
                p.name = [_sourceArray objectAtIndex:i];
                p.number = i;
                [dataArray addObject:p];
            }
            //根据Person对象的 name 属性 按中文 对 Person数组 排序
            self.indexArray = [BMChineseSort IndexWithArray:dataArray Key:@"name"];
            self.letterResultArr = [BMChineseSort sortObjectArray:dataArray Key:@"name"];
            [self.tableView reloadData];
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)createView
{
    [self createBarItem];
    [self createTopView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(102 + kTopHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
}

#pragma mark ----- create TopView -----
-(void)createTopView
{
    UIView *departmentView = [[UIView alloc] init];
    departmentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:departmentView];
    [departmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kTopHeight);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *departmentLab = [[UILabel alloc] init];
    departmentLab.textAlignment = NSTextAlignmentLeft;
    departmentLab.font = Font(14);
    departmentLab.text = DepartmentDetailVCDepartmentlab;
    departmentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [departmentView addSubview:departmentLab];
    [departmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _departmentDetailLab = [[UILabel alloc] init];
    _departmentDetailLab.font = Font(14);
    _departmentDetailLab.textAlignment = NSTextAlignmentRight;
    _departmentDetailLab.text = _model.Name;
    _departmentDetailLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [departmentView addSubview:_departmentDetailLab];
    [_departmentDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(departmentLab.mas_right).offset(15);
        make.right.offset(-35);
        make.top.bottom.offset(0);
    }];
    
    _rightImg = [[UIImageView alloc] init];
    _rightImg.image = [UIImage imageNamed:@"right_icon"];
    [departmentView addSubview:_rightImg];
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(departmentView);
        make.width.offset(20);
        make.height.offset(22);
        
    }];
    
    _departmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_departmentBtn addTarget:self action:@selector(departmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [departmentView addSubview:_departmentBtn];
    [_departmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    if (![[BoxDataManager sharedManager].depth isEqualToString:@"0"]) {
        _rightImg.hidden = YES;
        [_departmentDetailLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(departmentLab.mas_right).offset(15);
            make.right.offset(-16);
            make.top.bottom.offset(0);
        }];
        _departmentBtn.userInteractionEnabled = NO;
        
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [departmentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(departmentView.mas_bottom).offset(-1);
        make.left.right.offset(0);
        make.height.offset(1);
    }];
    
    UIView *menberView = [[UIView alloc] init];
    menberView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:menberView];
    [menberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(departmentView.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    _menberLab = [[UILabel alloc] init];
    _menberLab.textAlignment = NSTextAlignmentLeft;
    _menberLab.font = Font(14);
    _menberLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _menberLab.text = [NSString stringWithFormat:@"%@（%ld）", DepartmentDetailVCMember, _model.Employees];
    [menberView addSubview:_menberLab];
    [_menberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(15);
        make.right.offset(-15);
    }];
}

#pragma mark ----- Modify department -----
-(void)departmentBtnAction:(UIButton *)btn
{
    if (_model.ID == 1) {
        return;
    }
    AddDepartmentViewController *addDepartmentVc = [[AddDepartmentViewController alloc] init];
    addDepartmentVc.delegate = self;
    addDepartmentVc.type = DepartmentEditType;
    addDepartmentVc.model = _model;
    [self.navigationController pushViewController:addDepartmentVc animated:YES];
}

#pragma mark ----- AddDepartmentDelegate -----
- (void)editDepartmentWithModel:(DepartmentModel *)model
{
    _departmentDetailLab.text = model.Name;
    _menberLab.text = [NSString stringWithFormat:@"%@（%ld）", DepartmentDetailVCMember, model.Employees];
    [self loadData];
}

#pragma mark ----- createBarItem -----
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

#pragma mark - UITableView -
//section的titleHeader
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellReuseIdentifier];
    }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //获得对应的Person对象<替换为你自己的model对象>
    Person *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = p.name;
    cell.textLabel.font = Font(15);
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    return cell;
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
