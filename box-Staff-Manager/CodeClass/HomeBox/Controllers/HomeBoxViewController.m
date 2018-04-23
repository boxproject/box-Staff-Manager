//
//  HomeBoxViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeBoxViewController.h"
#import "TBView.h"
#import "ScanCodeViewController.h"
#import "TransferViewController.h"
#import "tansferCodeViewController.h"
#import "TransferAwaitViewController.h"
#import "TransferRecordViewController.h"
#import "TransferAwaitModel.h"
#import "TransferRecordView.h"
#import "TransferRecordDetailViewController.h"
#import "CurrencyView.h"
#import "CurrencyModel.h"

#define HomeBoxVCScanTitle  @"扫一扫"
#define HomeBoxVCTransferTitle  @"转账"
#define HomeBoxVCPaymentCodeTitle  @"付款码"
#define HomeBoxVCPaymentCodeTitle  @"付款码"
#define HomeBoxVCTaskTitle  @"代办任务"
#define HomeBoxVCTransferAwait  @"待审批转账"
#define HomeBoxVCcheckDetailBtn  @"查看详情"
#define HomeBoxVCsystemInfo  @"系统通知"
#define HomeBoxVCsystemUpdate  @"立即升级"
#define HomeBoxVCTransferRecord  @"转账记录"
#define HomeBoxVCTransferExamine @"查看全部"
#define HomeBoxVCInitiate  @"我发起的"
#define HomeBoxVCParticipateIn  @"我参与的"
#define HomeBoxVCTransferSubLab  @"暂无待审批转账"

@interface HomeBoxViewController ()<UIScrollViewDelegate,TransferRecordViewDelegate,CurrencyViewDelegate,TransferAwaitDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong)UIImageView *topView;
@property (nonatomic,strong)UILabel *topTitleLab;
@property (nonatomic,strong)UIImageView *topFollowView;
@property (nonatomic,strong)UIView *taskView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UILabel *transRecordLab;
@property (nonatomic,strong)UILabel *examineLab;
@property (nonatomic,strong)UIImageView *rightImg;
@property (nonatomic,strong)UIButton *examineBtn;
/** 扫一扫 */
@property (nonatomic,strong)TBView *scanView;
/** 转账 */
@property (nonatomic,strong)TBView *transferView;
/** 付款码 */
@property (nonatomic,strong)TBView *paymentCodeView;
@property (nonatomic,strong)UILabel *transferSubLab;
@property (nonatomic,strong)UILabel *amountLab;
@property (nonatomic,strong)UILabel *awaitTransferLab;
@property (nonatomic,strong)UIView *oneView;
@property (nonatomic,strong)UIImageView *transferSubImg;
@property (nonatomic,strong)UIButton *checkDetailBtn;
@property (nonatomic,strong)UILabel *systemInfoSubLab;
@property (nonatomic,strong)UIButton *systemUpdateBtn;
@property (nonatomic,strong)TransferRecordView *transferRecordView;
@property (nonatomic,strong)CurrencyView *currencyView;
@property (nonatomic,strong)CurrencyModel *currencyModel;

@end

@implementation HomeBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(243.0, 243.0, 246.0);
    [self createView];
    [self requesttransferAwait];
    [self requestCurrencyData];
}

#pragma mark  ----- 币种拉取 -----
-(void)requestCurrencyData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/capital/currency/list" params:paramsDic success:^(id responseObject)
     {
         NSDictionary *dict = responseObject;
         if ([dict[@"code"] integerValue] == 0) {
             NSArray *listArr = dict[@"data"][@"currency_list"];
             NSDictionary *dic = listArr[0];
             CurrencyModel *model = [[CurrencyModel alloc] initWithDict:dic];
             _currencyModel = model;
             _topTitleLab.attributedText = [self addAttributedText:model.currency];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"currencyList" object:model];
         }
     } fail:^(NSError *error) {
         NSLog(@"%@", error.description);
     }];
}

-(void)createView
{
    _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight)];
    _topView.image = [UIImage imageNamed:@"HomeBoxTopImg"];
    //_topView.backgroundColor = kBlueColor;
    [self.view addSubview:_topView];
    [self createTopView];
    
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTabBarHeight - kTopHeight)];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - kTabBarHeight - kTopHeight);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.backgroundColor = RGB(243.0, 243.0, 246.0);
    [self.view addSubview:_contentView];
    
    _contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    
    _topFollowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCREEN_WIDTH * (190.0/375.0))];
    _topFollowView.image = [UIImage imageNamed:@"HomeBoxTopFollowImg"];
    //_topFollowView.backgroundColor = kBlueColor;
    [_contentView addSubview:_topFollowView];
    [self createTopFollow];
    
    _taskView = [[UIView alloc] init];
    _taskView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:_taskView];
    _taskView.layer.cornerRadius = 3.f;
    _taskView.layer.masksToBounds = YES;
    [_taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scanView.mas_bottom).offset(21);
        make.left.offset(10);
        make.width.offset(SCREEN_WIDTH - 20);
        make.height.offset(203);
    }];
    [self createTaskView];

    _footView = [[UIView alloc] init];
    _footView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:_footView];
    _footView.layer.cornerRadius = 3.f;
    _footView.layer.masksToBounds = YES;
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taskView.mas_bottom).offset(10);
        make.left.offset(10);
        make.width.offset(SCREEN_WIDTH - 20);
        make.height.offset(160);
    }];
    [self createFootView];
}


#pragma mark ----- createTaskView -----
-(void)createTaskView
{
    UILabel *taskLab = [[UILabel alloc] init];
    taskLab.textAlignment = NSTextAlignmentLeft;
    taskLab.font = FontBold(19);
    taskLab.text = HomeBoxVCTaskTitle;
    taskLab.textColor = [UIColor colorWithHexString:@"#323232"];
    taskLab.numberOfLines = 1;
    [_taskView addSubview:taskLab];
    [taskLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(23);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(26);
    }];
    
    _oneView = [[UIView alloc] init];
    _oneView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_taskView addSubview:_oneView];
    [_oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskLab.mas_bottom).offset(9);
        make.left.offset(0);
        make.right.offset(-0);
        make.height.offset(72.5);
    }];
    
    UIImageView *transferImg = [[UIImageView alloc] init];
    transferImg.image = [UIImage imageNamed:@"transferImg"];
    [_oneView addSubview:transferImg];
    [transferImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_oneView);
        make.left.offset(15);
        make.height.offset(20);
        make.width.offset(20);
    }];
    
    _awaitTransferLab = [[UILabel alloc] init];
    _awaitTransferLab.textAlignment = NSTextAlignmentLeft;
    _awaitTransferLab.font = Font(14);
    _awaitTransferLab.text = HomeBoxVCTransferAwait;
    _awaitTransferLab.textColor = [UIColor colorWithHexString:@"#323232"];
    _awaitTransferLab.numberOfLines = 1;
    [_oneView addSubview:_awaitTransferLab];
    [_awaitTransferLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(17);
        make.left.equalTo(transferImg.mas_right).offset(12);
        make.height.offset(20);
    }];

    _transferSubLab = [[UILabel alloc] init];
    _transferSubLab.textAlignment = NSTextAlignmentLeft;
    _transferSubLab.font = Font(13);
    _transferSubLab.textColor = [UIColor colorWithHexString:@"#7c7c7c"];
    [_oneView addSubview:_transferSubLab];
    [_transferSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_awaitTransferLab.mas_bottom).offset(0);
        make.left.offset(70);
        make.height.offset(20);
        make.right.offset(-95);
        make.height.offset(18);
    }];
    _transferSubLab.text = @"";
    
    _transferSubImg = [[UIImageView alloc] init];
    _transferSubImg.image = [UIImage imageNamed:@"transferSubImg"];
    [_oneView addSubview:_transferSubImg];
    [_transferSubImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_transferSubLab);
        make.left.equalTo(transferImg.mas_right).offset(12);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    _checkDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkDetailBtn setTitle:HomeBoxVCcheckDetailBtn forState:UIControlStateNormal];
    _checkDetailBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _checkDetailBtn.titleLabel.font = Font(12);
    [_checkDetailBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _checkDetailBtn.layer.cornerRadius = 29.0/2.0;
    _checkDetailBtn.layer.masksToBounds = YES;
    [_checkDetailBtn addTarget:self action:@selector(checkDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    [_oneView addSubview:_checkDetailBtn];
    [_checkDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_oneView);
        make.right.offset(-16);
        make.width.offset(75);
        make.height.offset(29);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_taskView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneView.mas_bottom).offset(0);
        make.left.equalTo(transferImg.mas_right).offset(12);
        make.right.offset(-16);
        make.height.offset(1);
    }];
    
    UIView *twoView = [[UIView alloc] init];
    twoView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_taskView addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(-0);
        make.height.offset(72.5);
    }];
    
    UIImageView *systemInfoImg = [[UIImageView alloc] init];
    systemInfoImg.image = [UIImage imageNamed:@"systemInfoImg"];
    [twoView addSubview:systemInfoImg];
    [systemInfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoView);
        make.left.offset(15);
        make.height.offset(20);
        make.width.offset(20);
    }];
    
    
    UILabel *systemInfoLab = [[UILabel alloc] init];
    systemInfoLab.textAlignment = NSTextAlignmentLeft;
    systemInfoLab.font = Font(14);
    systemInfoLab.text = HomeBoxVCsystemInfo;
    systemInfoLab.textColor = [UIColor colorWithHexString:@"#323232"];
    systemInfoLab.numberOfLines = 1;
    [twoView addSubview:systemInfoLab];
    [systemInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(17);
        make.left.equalTo(systemInfoImg.mas_right).offset(12);
        make.right.offset(-95);
        make.height.offset(20);
    }];
    
    _systemInfoSubLab = [[UILabel alloc] init];
    _systemInfoSubLab.textAlignment = NSTextAlignmentLeft;
    _systemInfoSubLab.font = Font(13);
    _systemInfoSubLab.textColor = [UIColor colorWithHexString:@"#7c7c7c"];
    [twoView addSubview:_systemInfoSubLab];
    [_systemInfoSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(systemInfoLab.mas_bottom).offset(0);
        make.left.equalTo(systemInfoImg.mas_right).offset(12);
        make.right.offset(-95);
        make.height.offset(18);
    }];
    _systemInfoSubLab.text = @"暂无系统通知";
    
    _systemUpdateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_systemUpdateBtn setTitle:HomeBoxVCsystemUpdate forState:UIControlStateNormal];
    //_systemUpdateBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _systemUpdateBtn.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    _systemUpdateBtn.titleLabel.font = Font(12);
    [_systemUpdateBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _systemUpdateBtn.layer.cornerRadius = 29.0/2.0;
    _systemUpdateBtn.layer.masksToBounds = YES;
    [_systemUpdateBtn addTarget:self action:@selector(systemUpdateAction:) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:_systemUpdateBtn];
    [_systemUpdateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoView);
        make.right.offset(-16);
        make.width.offset(75);
        make.height.offset(29);
    }];
}

#pragma mark ----- createFootView -----
-(void)createFootView
{
    _transRecordLab = [[UILabel alloc] init];
    _transRecordLab.textAlignment = NSTextAlignmentLeft;
    _transRecordLab.font = FontBold(19);
    _transRecordLab.text = HomeBoxVCTransferRecord;
    _transRecordLab.textColor = [UIColor colorWithHexString:@"#323232"];
    _transRecordLab.numberOfLines = 1;
    [_footView addSubview:_transRecordLab];
    [_transRecordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
        make.width.offset(90);
        make.height.offset(26);
    }];
    
    _examineLab = [[UILabel alloc] init];
    _examineLab.textAlignment = NSTextAlignmentRight;
    _examineLab.font = Font(12);
    _examineLab.text = HomeBoxVCTransferExamine;
    _examineLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _examineLab.numberOfLines = 1;
    [_footView addSubview:_examineLab];
    [_examineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_transRecordLab);
        make.right.offset(-35);
        make.width.offset(60);
        make.height.offset(17);
    }];
    
    _rightImg = [[UIImageView alloc] init];
    _rightImg.image = [UIImage imageNamed:@"right_icon"];
    [_footView addSubview:_rightImg];
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_transRecordLab);
        make.right.offset(-15);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    _examineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_examineBtn addTarget:self action:@selector(approvalProcessAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_examineBtn];
    [_examineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_transRecordLab);
        make.right.offset(-10);
        make.width.offset(90);
        make.height.offset(20);
    }];
    
    _transferRecordView = [[TransferRecordView alloc] initWithFrame:CGRectZero];
    _transferRecordView.delegate = self;
    [_footView addSubview:_transferRecordView];
    [_transferRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.left.offset(0);
        make.right.offset(-0);
        make.height.offset(150 - 50);
    }];
}

#pragma mark  ----- 刷新数据 -----
-(void)headRefresh
{   [_transferRecordView requestData];
    [self requesttransferAwait];
}

#pragma mark  ----- TransferAwaitDelegate -----
- (void)backReflesh
{
    [self requesttransferAwait];
}

#pragma mark ----- 获取待审批转账 -----
-(void)requesttransferAwait
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:@(1) forKey:@"type"];
    [paramsDic setObject:@(0) forKey:@"progress"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/transfer/records/list" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *listArray = dict[@"data"][@"list"];
            if (listArray.count >= 1) {
                NSInteger accountIn = [dict[@"data"][@"count"] integerValue];
                NSString *accountStr = [NSString stringWithFormat:@"%ld",accountIn];
                [self createAccountLab:accountStr];
                NSDictionary *listDic = listArray[0];
                TransferAwaitModel *model = [[TransferAwaitModel alloc] initWithDict:listDic];
                _transferSubLab.text = model.tx_info;
            }else{
                _transferSubLab.text = HomeBoxVCTransferSubLab;
                [_amountLab removeFromSuperview];
            }
        }else{
            [ProgressHUD showStatus:[dict[@"code"] integerValue]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_contentView.mj_header endRefreshing];
        });
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_contentView.mj_header endRefreshing];
        });
    }];
}

-(void)createAccountLab:(NSString *)string
{
    [_amountLab removeFromSuperview];
    _amountLab = [[UILabel alloc]init];
    _amountLab.font = Font(12);
    _amountLab.backgroundColor = kRedColor;
    _amountLab.layer.cornerRadius = 16.0/2;
    _amountLab.layer.masksToBounds = YES;
    _amountLab.text = string;
    _amountLab.textAlignment = NSTextAlignmentCenter;
    CGSize size = [_amountLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(12),NSFontAttributeName,nil]];
    _amountLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [_oneView addSubview:_amountLab];
    [_amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_awaitTransferLab);
        make.left.equalTo(_awaitTransferLab.mas_right).offset(10);
        make.height.offset(16);
        make.width.offset(size.width + 12);
    }];
}

#pragma mark ----- CurrencyViewDelegate -----
- (void)didSelectItem:(CurrencyModel *)model
{
    _currencyModel = model;
    _topTitleLab.attributedText = [self addAttributedText:model.currency];
}

#pragma mark ----- 查看详情 -----
-(void)checkDetailAction:(UIButton *)btn
{
    TransferAwaitViewController *transferAwaitVC = [[TransferAwaitViewController alloc] init];
    transferAwaitVC.delegate = self;
    BoxNavigationController *transferAwaitNC = [[BoxNavigationController alloc] initWithRootViewController:transferAwaitVC];
    [self presentViewController:transferAwaitNC animated:YES completion:nil];
}

#pragma mark ----- 立即更新 -----
-(void)systemUpdateAction:(UIButton *)btn
{
    
}

#pragma mark ----- scrollview取消弹簧效果 -----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView.bounces = (scrollView.contentOffset.y <= 0) ? NO : YES;
}

-(void)createTopFollow
{
    _topFollowView.userInteractionEnabled = YES;
    _scanView = [[TBView alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"scanTBImage"] title:HomeBoxVCScanTitle];
    [_topFollowView addSubview:_scanView];
    [_scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(45);
        make.width.offset(55);
        make.height.offset(59);
    }];
    UITapGestureRecognizer *scanTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanTapAction:)];
    _scanView.userInteractionEnabled = YES;
    [_scanView addGestureRecognizer:scanTap];
    
    _transferView = [[TBView alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"transferTBImage"] title:HomeBoxVCTransferTitle];
    [_topFollowView addSubview:_transferView];
    [_transferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.centerX.equalTo(_topFollowView);
        make.width.offset(55);
        make.height.offset(59);
    }];
    UITapGestureRecognizer *transferTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transferAction:)];
    _transferView.userInteractionEnabled = YES;
    [_transferView addGestureRecognizer:transferTap];
    
    _paymentCodeView = [[TBView alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"paymentCodeTBImage"] title:HomeBoxVCPaymentCodeTitle];
    [_topFollowView addSubview:_paymentCodeView];
    [_paymentCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.right.offset(-45);
        make.width.offset(55);
        make.height.offset(59);
    }];
    UITapGestureRecognizer *paymentCodeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paymentCodeAction:)];
    _paymentCodeView.userInteractionEnabled = YES;
    [_paymentCodeView addGestureRecognizer:paymentCodeTap];
}

-(NSMutableAttributedString *)addAttributedText:(NSString *)text
{
    NSString *btcStr = text;
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", btcStr]];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffffff"] range:NSMakeRange(0, btcStr.length + 1)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"icon_pulldown"];
    attch.bounds = CGRectMake(7, 0.5, 12, 9);
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    //[attri appendAttributedString:string];
    //将图片放在第一位
    [attri insertAttributedString:string atIndex:btcStr.length];
    return attri;
}

-(void)createTopView
{
    _topTitleLab = [[UILabel alloc] init];
    _topTitleLab.textAlignment = NSTextAlignmentCenter;
    _topTitleLab.font = Font(16);
    _topTitleLab.attributedText = [self addAttributedText:@"BTC"];
    CurrencyModel *model = [[CurrencyModel alloc] init];
    model.currency = @"BTC";
    model.address = @"";
    _currencyModel = model;
    _topTitleLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _topTitleLab.numberOfLines = 1;
    [_topView addSubview:_topTitleLab];
    [_topTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kTopHeight - 32);
        make.centerX.equalTo(_topView);
        make.height.offset(22);
        make.width.offset(200);
    }];
    
    UITapGestureRecognizer *topTitleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topTitleTapAction:)];
    _topTitleLab.userInteractionEnabled = YES;
    _topView.userInteractionEnabled = YES;
    [_topTitleLab addGestureRecognizer:topTitleTap];
}

#pragma mark ----- 查看全部 -----
-(void)approvalProcessAction:(UIButton *)btn
{
    TransferRecordViewController *transferVC = [[TransferRecordViewController alloc] init];
    transferVC.titleName = HomeBoxVCParticipateIn;
    BoxNavigationController *transferNC = [[BoxNavigationController alloc] initWithRootViewController:transferVC];
    [self presentViewController:transferNC animated:YES completion:nil];
}


#pragma mark ----- TransferRecordViewDelegate -----
- (void)transferRecordViewDidTableView:(TransferAwaitModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TransferRecordDetailViewController *transferDetailVc = [[TransferRecordDetailViewController alloc] init];
        transferDetailVc.model = model;
        UINavigationController *transferDetailNc = [[UINavigationController alloc] initWithRootViewController:transferDetailVc];
        [self presentViewController:transferDetailNc animated:NO completion:nil];
    });
}

- (void)refleshViewHight:(NSInteger)integer
{
    CGFloat contentSizeHeight = 15 + 59 + 21 + 203 + 10 + 50 + 10 + 30 + 15 + 59*integer;
    if (contentSizeHeight > SCREEN_HEIGHT - kTabBarHeight - kTopHeight) {
        _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), contentSizeHeight + 20);
    }else{
        _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - kTabBarHeight - kTopHeight);
    }
    
    [_footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taskView.mas_bottom).offset(10);
        make.left.offset(10);
        make.width.offset(SCREEN_WIDTH - 20);
        make.height.offset(50 + 10 + 30 + 15 + 59*integer);
    }];
    
    [_transRecordLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
        make.width.offset(90);
        make.height.offset(26);
    }];
    
    [_examineLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_transRecordLab);
        make.right.offset(-35);
        make.width.offset(60);
        make.height.offset(17);
    }];
    
    [_rightImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_transRecordLab);
        make.right.offset(-15);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    
    [_examineBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_transRecordLab);
        make.right.offset(-10);
        make.width.offset(90);
        make.height.offset(20);
    }];
    
    [_transferRecordView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.left.offset(0);
        make.right.offset(-0);
        make.height.offset(10 + 30 + 15 + 59 * integer);
    }];
}

#pragma mark ----- topTitleTapAction -----
-(void)topTitleTapAction:(UITapGestureRecognizer *)tap
{
    _currencyView = [[CurrencyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _currencyView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_currencyView];
}

#pragma mark ----- 扫一扫 -----
-(void)scanTapAction:(UITapGestureRecognizer *)tap
{
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    scanCodeVC.fromFunction = fromHomeBox;
    scanCodeVC.model = _currencyModel;
    BoxNavigationController *scanCodeNC = [[BoxNavigationController alloc] initWithRootViewController:scanCodeVC];
    [self presentViewController:scanCodeNC animated:NO completion:nil];
    
}

#pragma mark ----- 转账 -----
-(void)transferAction:(UITapGestureRecognizer *)tap
{
    TransferViewController *transferVC = [[TransferViewController alloc] init];
    transferVC.mode = _currencyModel;
    BoxNavigationController *transferNC = [[BoxNavigationController alloc] initWithRootViewController:transferVC];
    [self presentViewController:transferNC animated:YES completion:nil];
}


#pragma mark ----- 收款码 -----
-(void)paymentCodeAction:(UITapGestureRecognizer *)tap
{
    tansferCodeViewController *transferCodeVC = [[tansferCodeViewController alloc] init];
    transferCodeVC.model = _currencyModel;
    BoxNavigationController *transferCodeNC = [[BoxNavigationController alloc] initWithRootViewController:transferCodeVC];
    [self presentViewController:transferCodeNC animated:YES completion:nil];
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
