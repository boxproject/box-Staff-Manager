//
//  SetApprovalAmountViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SetApprovalAmountViewController.h"
#import "SetApprovalAmountTableViewCell.h"
#import "CurrencyModel.h"
#import "SearchCurrencyViewController.h"

#define CellReuseIdentifier  @"SetApprovalAmountTableViewCell"

@interface SetApprovalAmountViewController ()<UITableViewDelegate, UITableViewDataSource,SetApprovalAmountDelegate>

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UITextField *limitTimeTf;
@property (nonatomic,strong) UILabel *menberLab;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic, strong)UIButton *submitBtn;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation SetApprovalAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = SetApprovalAmountVCTitle;
    _sourceArray = [[NSMutableArray alloc] init];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createBarItem];
    [self createView];
    
}

-(void)createView
{
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kTopHeight);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(110);
    }];
    
    UILabel *limitTimeLab = [[UILabel alloc] init];
    limitTimeLab.textAlignment = NSTextAlignmentLeft;
    limitTimeLab.font = Font(14);
    limitTimeLab.text = LimitTimes;
    limitTimeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_topView addSubview:limitTimeLab];
    [limitTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.height.offset(60);
        make.left.offset(15);
        make.width.offset(90);
    }];
    
    _limitTimeTf = [[UITextField alloc] init];
    _limitTimeTf.font = Font(14);
    _limitTimeTf.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:LimitTimesPlaceholder];
    [placeholder addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexString:@"#cccccc"]
                           range:NSMakeRange(0, LimitTimesPlaceholder.length)];
    [placeholder addAttribute:NSFontAttributeName
                           value:Font(13)
                           range:NSMakeRange(0, LimitTimesPlaceholder.length)];
    _limitTimeTf.attributedPlaceholder = placeholder;
    _limitTimeTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _limitTimeTf.keyboardType = UIKeyboardTypeDecimalPad;
    [_limitTimeTf addTarget:self action:@selector(textViewEditChanged) forControlEvents:UIControlEventEditingChanged];
    [_topView addSubview:_limitTimeTf];
    [_limitTimeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(limitTimeLab.mas_right).offset(8);
        make.right.offset(-75);
        make.top .offset(0);
        make.height.offset(60);
    }];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.font = Font(14);
    timeLab.text = AccountPasswordHour;
    timeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_topView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-32);
        make.width.offset(30);
        make.top.offset(0);
        make.height.offset(60);
    }];
    
    UIImageView *queryImg = [[UIImageView alloc] init];
    queryImg.image = [UIImage imageNamed:@"icon_question"];
    [_topView addSubview:queryImg];
    [queryImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(timeLab);
        make.width.offset(12);
        make.height.offset(12);
        
    }];
    
    UIButton *queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryBtn addTarget:self action:@selector(queryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:queryBtn];
    [queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLab);
        make.right.offset(-5);
        make.width.offset(35);
        make.height.offset(50);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_topView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(59);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    UILabel *currencyLab = [[UILabel alloc] init];
    currencyLab.textAlignment = NSTextAlignmentLeft;
    currencyLab.font = Font(14);
    currencyLab.text = ApplyForCurrency;
    currencyLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_topView addSubview:currencyLab];
    [currencyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(60);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [UIImage imageNamed:@"right_icon"];
    [_topView addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-11);
        make.centerY.equalTo(currencyLab);
        make.width.offset(20);
        make.height.offset(22);
        
    }];
    
    UIButton *applyCurrencyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyCurrencyBtn addTarget:self action:@selector(applyCurrencyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:applyCurrencyBtn];
    [applyCurrencyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(currencyLab);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(50);
    }];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_topView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(109);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.right.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight + 49 - 46);
    }];
    [_tableView registerClass:[SetApprovalAmountTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.editing = YES;
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setTitle:SubmitApproval forState:(UIControlState)UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    //_submitBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _submitBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    _submitBtn.titleLabel.font = Font(16);
    [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(46);
    }];
}

-(void)textViewEditChanged
{
    [self submitBtnBackgroundColor];
}

#pragma mark ----- 额度恢复时间说明 -----
-(void)queryBtnAction:(UIButton *)btn
{
    [self showProgressWithMessage:LimitAlertContent title:LimitAlertTitle actionWithTitle:LimitAlertAffirm];
}

-(void)showProgressWithMessage:(NSString *)message title:(NSString *)title actionWithTitle:(NSString *)actionWithTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:actionWithTitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ----- 提交审批 -----
-(void)submitBtnAction:(UIButton *)btn
{
    CGFloat limitFloat = [_limitTimeTf.text floatValue];
    if (limitFloat < 0 || limitFloat > 240) {
        [self showProgressWithMessage:LimitAlert title:nil actionWithTitle:Affirm];
        return;
    }
    for (CurrencyModel *currencyModel in _sourceArray) {
        if (currencyModel.limit == nil) {
            [self showProgressWithMessage:[NSString stringWithFormat:@"%@%@%@", PleaseInput, currencyModel.currency,ApplyForLimit] title:nil actionWithTitle:Affirm];
            return;
        }
    }
    NSMutableArray *currencyArr = [[NSMutableArray alloc] init];
    for (CurrencyModel *currencyModel in _sourceArray) {
        NSDictionary *dic = @{@"currency":currencyModel.currency, @"limit": currencyModel.limit};
        [currencyArr addObject:dic];
    }
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam addEntriesFromDictionary:_paramDic];
    [dicParam setObject:_limitTimeTf.text forKey:@"period"];
    [dicParam setObject:currencyArr forKey:@"flow_limit"];
    NSString *dicString = [JsonObject dictionaryToJson:dicParam];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:dicString privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:dicString signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setObject:dicString forKey:@"flow"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/business/flow" params:paramsDic success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            UIViewController *vc = self.presentingViewController;
            while (vc.presentingViewController) {
                vc = vc.presentingViewController;
            }
            [vc dismissViewControllerAnimated:YES completion:NULL];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"createApprovalSucceed" object:nil];
            [WSProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            
        }else{
            [ProgressHUD showErrorWithStatus:responseObject[@"message"] code:[responseObject[@"code"] integerValue]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark ----- 申请币种 -----
-(void)applyCurrencyAction:(UIButton *)btn
{
    SearchCurrencyViewController *searchCurrencyVc = [[SearchCurrencyViewController alloc] init];
    searchCurrencyVc.currencyArray = _sourceArray;
    searchCurrencyVc.searchCurrencyBlock = ^(NSArray *array){
        for (CurrencyModel *currencyModel in array) {
            [_sourceArray addObject:currencyModel];
        }
        [self.tableView reloadData];
        [self submitBtnBackgroundColor];
    };
    [self.navigationController pushViewController:searchCurrencyVc animated:YES];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SetApprovalAmountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    CurrencyModel *model = self.sourceArray[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    [cell setDataWithModel:model indexPath:indexPath];
    return cell;
}

- (void)textViewEdit:(NSString *)text indexPath:(NSIndexPath *)indexPath
{
    CurrencyModel *model = self.sourceArray[indexPath.row];
    model.limit = text;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    [_sourceArray removeObjectAtIndex:indexPath.row];
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self submitBtnBackgroundColor];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:delete handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 删除模型
        [_sourceArray removeObjectAtIndex:indexPath.row];
        // 刷新
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self submitBtnBackgroundColor];
    }];
    return @[action1];
}

-(void)submitBtnBackgroundColor
{
    if (![_limitTimeTf.text isEqualToString:@""] && _sourceArray.count > 0) {
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
        _submitBtn.enabled = YES;
    }else{
        _submitBtn.enabled = NO;
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
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
