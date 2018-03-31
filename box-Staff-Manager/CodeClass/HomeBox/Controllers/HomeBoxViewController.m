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
#define HomeBoxVCInitiate  @"我发起的"
#define HomeBoxVCParticipateIn  @"我参与的"

@interface HomeBoxViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong)UIImageView *topView;
@property (nonatomic,strong)UILabel *topTitleLab;
@property (nonatomic,strong)UIImageView *topFollowView;
@property (nonatomic,strong)UIView *taskView;
@property (nonatomic,strong)UIView *footView;

/** 扫一扫 */
@property (nonatomic,strong)TBView *scanView;
/** 转账 */
@property (nonatomic,strong)TBView *transferView;
/** 付款码 */
@property (nonatomic,strong)TBView *paymentCodeView;

@property (nonatomic,strong)UILabel *transferSubLab;
@property (nonatomic,strong)UIImageView *transferSubImg;
@property (nonatomic,strong)UIButton *checkDetailBtn;
@property (nonatomic,strong)UILabel *systemInfoSubLab;
@property (nonatomic,strong)UIButton *systemUpdateBtn;

@end

@implementation HomeBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(243.0, 243.0, 246.0);
    [self createView];
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
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), [UIScreen mainScreen].bounds.size.width*(750.0/700.0) - 64 + 484.0/2.0 - 44 + 10 + 200 + 30);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.backgroundColor = RGB(243.0, 243.0, 246.0);
    [self.view addSubview:_contentView];
    
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
        make.height.offset(161);
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
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_taskView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskLab.mas_bottom).offset(9);
        make.left.offset(0);
        make.right.offset(-0);
        make.height.offset(72.5);
    }];
    
    UIImageView *transferImg = [[UIImageView alloc] init];
    transferImg.image = [UIImage imageNamed:@"transferImg"];
    transferImg.backgroundColor = kRedColor;
    [oneView addSubview:transferImg];
    [transferImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oneView);
        make.left.offset(15);
        make.height.offset(20);
        make.width.offset(20);
    }];
    
    
    UILabel *awaitTransferLab = [[UILabel alloc] init];
    awaitTransferLab.textAlignment = NSTextAlignmentLeft;
    awaitTransferLab.font = Font(14);
    awaitTransferLab.text = HomeBoxVCTransferAwait;
    awaitTransferLab.textColor = [UIColor colorWithHexString:@"#323232"];
    awaitTransferLab.numberOfLines = 1;
    [oneView addSubview:awaitTransferLab];
    [awaitTransferLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(17);
        make.left.equalTo(transferImg.mas_right).offset(12);
        make.right.offset(-95);
        make.height.offset(20);
    }];
    
    _transferSubLab = [[UILabel alloc] init];
    _transferSubLab.textAlignment = NSTextAlignmentLeft;
    _transferSubLab.font = Font(13);
    _transferSubLab.textColor = [UIColor colorWithHexString:@"#7c7c7c"];
    [oneView addSubview:_transferSubLab];
    [_transferSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(awaitTransferLab.mas_bottom).offset(0);
        make.left.offset(70);
        make.height.offset(20);
        make.right.offset(-95);
        make.height.offset(18);
    }];
    _transferSubLab.text = @"黄大大申请转出290个ETH";
    
    _transferSubImg = [[UIImageView alloc] init];
    _transferSubImg.image = [UIImage imageNamed:@"transferSubImg"];
    _transferSubImg.backgroundColor = kBlueColor;
    [oneView addSubview:_transferSubImg];
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
    [oneView addSubview:_checkDetailBtn];
    [_checkDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oneView);
        make.right.offset(-16);
        make.width.offset(75);
        make.height.offset(29);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_taskView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneView.mas_bottom).offset(0);
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
    systemInfoImg.backgroundColor = kRedColor;
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
    _systemInfoSubLab.text = @"1.2.1最新版本上线啦";
    
    _systemUpdateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_systemUpdateBtn setTitle:HomeBoxVCsystemUpdate forState:UIControlStateNormal];
    _systemUpdateBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
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
    UILabel *transRecordLab = [[UILabel alloc] init];
    transRecordLab.textAlignment = NSTextAlignmentLeft;
    transRecordLab.font = FontBold(19);
    transRecordLab.text = HomeBoxVCTransferRecord;
    transRecordLab.textColor = [UIColor colorWithHexString:@"#323232"];
    transRecordLab.numberOfLines = 1;
    [_footView addSubview:transRecordLab];
    [transRecordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(26);
    }];
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_footView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transRecordLab.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(-0);
        make.height.offset(55);
    }];
    
    UITapGestureRecognizer *initiateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(initiateAction:)];
    _footView.userInteractionEnabled = YES;
    oneView.userInteractionEnabled = YES;
    [oneView addGestureRecognizer:initiateTap];
    
    UILabel *initiateLab = [[UILabel alloc]init];
    initiateLab.font = Font(15);
    initiateLab.text = HomeBoxVCInitiate;
    initiateLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [oneView addSubview:initiateLab];
    [initiateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.right.offset(-80);
        
    }];
    
    UIImageView *oneRightImg = [[UIImageView alloc] init];
    oneRightImg.image = [UIImage imageNamed:@"right_icon"];
    [oneView addSubview:oneRightImg];
    [oneRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(oneView);
        make.width.offset(20);
        make.height.offset(22);
        
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_footView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneView.mas_bottom).offset(0);
        make.left.offset(15);
        make.right.offset(-16);
        make.height.offset(1);
    }];
    
    UIView *twoView = [[UIView alloc] init];
    twoView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_footView addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(-0);
        make.height.offset(55);
    }];
    
    UITapGestureRecognizer *paticipateInTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paticipateInAction:)];
    _footView.userInteractionEnabled = YES;
    twoView.userInteractionEnabled = YES;
    [twoView addGestureRecognizer:paticipateInTap];
    
    UILabel *paticipateInLab = [[UILabel alloc]init];
    paticipateInLab.font = Font(15);
    paticipateInLab.text = HomeBoxVCParticipateIn;
    paticipateInLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [twoView addSubview:paticipateInLab];
    [paticipateInLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.right.offset(-80);
        
    }];
    
    UIImageView *twoRightImg = [[UIImageView alloc] init];
    twoRightImg.image = [UIImage imageNamed:@"right_icon"];
    [twoView addSubview:twoRightImg];
    [twoRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(twoView);
        make.width.offset(20);
        make.height.offset(22);
        
    }];
    
    
    
    
    
    
    
}



#pragma mark ----- 查看详情 -----
-(void)checkDetailAction:(UIButton *)btn
{
    TransferAwaitViewController *transferAwaitVC = [[TransferAwaitViewController alloc] init];
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
    scrollView.bounces = (scrollView.contentOffset.y <= 0) ? NO : YES;
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


-(void)createTopView
{
    NSString *btcStr = @"BTC";
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
    
    _topTitleLab = [[UILabel alloc] init];
    _topTitleLab.textAlignment = NSTextAlignmentCenter;
    _topTitleLab.font = Font(16);
    _topTitleLab.attributedText = attri;
    _topTitleLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _topTitleLab.numberOfLines = 1;
    [_topView addSubview:_topTitleLab];
    [_topTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kTopHeight - 32);
        make.centerX.equalTo(_topView);
        make.height.offset(22);
        make.width.offset(100);
    }];
    UITapGestureRecognizer *topTitleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topTitleTapAction:)];
    _topTitleLab.userInteractionEnabled = YES;
    _topView.userInteractionEnabled = YES;
    [_topTitleLab addGestureRecognizer:topTitleTap];
    
    
}


#pragma mark ----- paticipateInAction -----
-(void)paticipateInAction:(UITapGestureRecognizer *)tap
{
    TransferRecordViewController *transferVC = [[TransferRecordViewController alloc] init];
    transferVC.titleName = HomeBoxVCParticipateIn;
    BoxNavigationController *transferNC = [[BoxNavigationController alloc] initWithRootViewController:transferVC];
    [self presentViewController:transferNC animated:YES completion:nil];
}

#pragma mark ----- initiateAction -----
-(void)initiateAction:(UITapGestureRecognizer *)tap
{
    TransferRecordViewController *transferVC = [[TransferRecordViewController alloc] init];
    transferVC.titleName = HomeBoxVCInitiate;
    BoxNavigationController *transferNC = [[BoxNavigationController alloc] initWithRootViewController:transferVC];
    [self presentViewController:transferNC animated:YES completion:nil];
}


#pragma mark ----- topTitleTapAction -----
-(void)topTitleTapAction:(UITapGestureRecognizer *)tap
{
    
}

#pragma mark ----- 扫一扫 -----
-(void)scanTapAction:(UITapGestureRecognizer *)tap
{
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    scanCodeVC.fromFunction = fromHomeBox;
    BoxNavigationController *scanCodeNC = [[BoxNavigationController alloc] initWithRootViewController:scanCodeVC];
    [self presentViewController:scanCodeNC animated:NO completion:nil];
    
}

#pragma mark ----- 转账 -----
-(void)transferAction:(UITapGestureRecognizer *)tap
{
    
    TransferViewController *transferVC = [[TransferViewController alloc] init];
    BoxNavigationController *transferNC = [[BoxNavigationController alloc] initWithRootViewController:transferVC];
    [self presentViewController:transferNC animated:YES completion:nil];
}


#pragma mark ----- 收款码 -----
-(void)paymentCodeAction:(UITapGestureRecognizer *)tap
{
    tansferCodeViewController *transferCodeVC = [[tansferCodeViewController alloc] init];
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
