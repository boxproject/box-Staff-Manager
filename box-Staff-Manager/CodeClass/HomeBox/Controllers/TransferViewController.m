//
//  TransferViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferViewController.h"
#import "ScanCodeViewController.h"
#import "TransferView.h"
#import "TransferRecordViewController.h"
#import "SearchApprovalViewController.h"
#import "UIARSAHandler.h"
#import "HomeDirectoryViewController.h"
#import "ApprovalBusinessModel.h"
#import "CurrencyView.h"

#define TransferVCTitle  @"转账"
#define TransferVCApprovalProcess  @"审批流"
#define TransferVCApprovalProcessInfo  @"请选择审批流"
#define TransferVCRightTitle  @"转账记录"
#define TransferVCCurrency  @"币种"
#define TransferVCReceiptAddress  @"收款地址"
#define TransferVCReceiptAddressInfo  @"请输入或者选择收款人"
#define TransferVCAmount  @"金额"
#define TransferVCAmountInfo  @"请输入转账金额"
#define TransferVCApplyReason  @"申请理由"
#define TransferVCApplyReasonInfo  @"如用于XXX投资"
#define TransferVCMinersFee  @"矿工费"
#define TransferVCMinersFeeSlow  @"慢"
#define TransferVCMinersFeeFast  @"快"
#define TransferVCBtnTitle  @"提交审批"

@interface TransferViewController ()<UITextFieldDelegate,UIScrollViewDelegate,TransferViewDelegate,CurrencyViewDelegate>
@property(nonatomic, strong)DDRSAWrapper *aWrapper;
@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong) UIView *viewLayer;
@property (nonatomic,strong)UILabel *topTitleLab;
@property (nonatomic,strong)UITextField *approvalProcessTf;
@property (nonatomic,strong)UITextField *currencyTf;
@property (nonatomic,strong)UITextField *addressTf;
@property (nonatomic,strong)UITextField *applyReasonTf;
@property (nonatomic,strong)UITextField *amountTf;
@property (nonatomic,strong)UISlider *progressSlider;
@property (nonatomic,strong)UILabel *minersFeeLab;
@property (nonatomic,strong)UIButton *commitBtn;
@property (nonatomic,strong)UIButton *scanBtn;
@property (nonatomic,strong)UIButton *addressTextBtn;
@property (nonatomic,strong)ApprovalBusinessModel *approvalBusinessModel;
@property (nonatomic, strong)IQKeyboardManager *manager;
@property (nonatomic, strong)TransferView *transferView;
@property (nonatomic,strong)CurrencyView *currencyView;

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    [self createTitleView];
    [self createBarItem];
    [self createView];
    [self initIQKeyboardManager];
    _aWrapper = [[DDRSAWrapper alloc] init];
}

-(void)initIQKeyboardManager
{
    _manager = [IQKeyboardManager sharedManager]; //处理键盘遮挡
    //[manager setCanAdjustTextView:YES];
    _manager.enable = YES;
    _manager.shouldResignOnTouchOutside = YES;
    _manager.shouldToolbarUsesTextFieldTintColor = YES;
    _manager.enableAutoToolbar = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *shadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = shadowImage;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor}];
}

-(NSMutableAttributedString *)attributedStringWithImage:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"%@%@", string, TransferVCTitle];
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", str]];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, str.length + 1)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"icon_pulldown_gray"];
    attch.bounds = CGRectMake(7, 0.5, 12, 9);
    //创建带有图片的富文本
    NSAttributedString *stringAt = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    //[attri appendAttributedString:string];
    //将图片放在第一位
    [attri insertAttributedString:stringAt atIndex:str.length];
    return attri;
}

-(void)createTitleView
{
    _viewLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _viewLayer.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = self.viewLayer;
    _topTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _topTitleLab.textAlignment = NSTextAlignmentCenter;
    _topTitleLab.font = Font(16);
    _topTitleLab.attributedText = [self attributedStringWithImage:_mode.currency];
    _topTitleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _topTitleLab.numberOfLines = 1;
    [_viewLayer addSubview:_topTitleLab];
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 30);
    [button addTarget:self action:@selector(topTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_viewLayer addSubview:button];
}


#pragma mark ----- topTitleTapAction -----
-(void)topTitleAction:(UIButton *)tap
{
    _currencyView = [[CurrencyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _currencyView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_currencyView];
}

#pragma mark ----- CurrencyViewDelegate -----
- (void)didSelectItem:(CurrencyModel *)model
{
    _mode = model;
    _topTitleLab.attributedText = [self attributedStringWithImage:model.currency];
    _currencyTf.text = model.currency;
}

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:TransferVCRightTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#666666"];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15), NSFontAttributeName, nil] forState:UIControlStateNormal];
}

#pragma mark ----- rightBarButtonItemAction -----
- (void)rightButtonAction:(UIBarButtonItem *)buttonItem{
    TransferRecordViewController *transferRecordVc = [[TransferRecordViewController alloc] init];
    transferRecordVc.fromVC = @"transferVC";
    [self.navigationController pushViewController:transferRecordVc animated:YES];
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    _manager.enable = NO;
    _manager.shouldResignOnTouchOutside = NO;
    _manager.shouldToolbarUsesTextFieldTintColor = NO;
    _manager.enableAutoToolbar = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64))];
    _contentView.delegate = self;
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 60);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    //审批流
    UIView *approvalProcessView = [[UIView alloc] init];
    approvalProcessView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:approvalProcessView];
    [approvalProcessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *approvalProcessLab = [[UILabel alloc] init];
    approvalProcessLab.textAlignment = NSTextAlignmentLeft;
    approvalProcessLab.font = Font(14);
    approvalProcessLab.text = TransferVCApprovalProcess;
    approvalProcessLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [approvalProcessView addSubview:approvalProcessLab];
    [approvalProcessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _approvalProcessTf = [[UITextField alloc] init];
    _approvalProcessTf.font = Font(14);
    _approvalProcessTf.placeholder = TransferVCApprovalProcessInfo;
    _approvalProcessTf.delegate = self;
    _approvalProcessTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _approvalProcessTf.keyboardType = UIKeyboardTypeAlphabet;
    [_approvalProcessTf addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    [approvalProcessView addSubview:_approvalProcessTf];
    [_approvalProcessTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(approvalProcessLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [UIImage imageNamed:@"right_icon"];
    [approvalProcessView addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(approvalProcessView);
        make.width.offset(20);
        make.height.offset(22);
        
    }];
    
    UIButton *approvalProcessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [approvalProcessBtn addTarget:self action:@selector(approvalProcessAction:) forControlEvents:UIControlEventTouchUpInside];
    [approvalProcessView addSubview:approvalProcessBtn];
    [approvalProcessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(approvalProcessView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];

    //币种
    UIView *currencyView = [[UIView alloc] init];
    currencyView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:currencyView];
    [currencyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *currencyLab = [[UILabel alloc] init];
    currencyLab.textAlignment = NSTextAlignmentLeft;
    currencyLab.font = Font(14);
    currencyLab.text = TransferVCCurrency;
    currencyLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [currencyView addSubview:currencyLab];
    [currencyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _currencyTf = [[UITextField alloc] init];
    _currencyTf.font = Font(14);
    _currencyTf.text = _mode.currency;
    _currencyTf.delegate = self;
    _currencyTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _currencyTf.keyboardType = UIKeyboardTypeAlphabet;
    [_currencyTf addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    [currencyView addSubview:_currencyTf];
    [_currencyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currencyLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currencyView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    //收款地址
    UIView *addressView = [[UIView alloc] init];
    addressView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textAlignment = NSTextAlignmentLeft;
    addressLab.font = Font(14);
    addressLab.text = TransferVCReceiptAddress;
    addressLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [addressView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _addressTf = [[UITextField alloc] init];
    _addressTf.font = Font(14);
    _addressTf.delegate = self;
    _addressTf.placeholder = TransferVCReceiptAddressInfo;
    if ([_fromType isEqualToString:@"scanCode"]) {
        _addressTf.text = _mode.address;
    }
    _addressTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [_addressTf addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [addressView addSubview:_addressTf];
    [_addressTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLab.mas_right).offset(15);
        make.right.offset(-70);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    UIImageView *addressImg = [[UIImageView alloc] init];
    addressImg.image = [UIImage imageNamed:@"icon_address"];
    [addressView addSubview:addressImg];
    [addressImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView);
        make.right.offset(-15);
        make.width.offset(21);
        make.height.offset(21);
    }];
    
    _addressTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addressTextBtn addTarget:self action:@selector(addressTextAction:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:_addressTextBtn];
    [_addressTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView);
        make.right.offset(-10);
        make.width.offset(31);
        make.height.offset(50);
    }];
    
    UIImageView *scanImg = [[UIImageView alloc] init];
    scanImg.image = [UIImage imageNamed:@"icon_scan_gray"];
    [addressView addSubview:scanImg];
    [scanImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView);
        make.right.equalTo(addressImg.mas_left).offset(-10);
        make.width.offset(21);
        make.height.offset(21);
    }];
    
    _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView);
        make.right.equalTo(_addressTextBtn.mas_left).offset(0);
        make.width.offset(31);
        make.height.offset(50);
    }];
    
    //金额
    UIView *amountView = [[UIView alloc] init];
    amountView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:amountView];
    [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *amountLab = [[UILabel alloc] init];
    amountLab.textAlignment = NSTextAlignmentLeft;
    amountLab.font = Font(14);
    amountLab.text = TransferVCAmount;
    amountLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [amountView addSubview:amountLab];
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _amountTf = [[UITextField alloc] init];
    _amountTf.placeholder = TransferVCAmountInfo;
    _amountTf.font = Font(14);
    _amountTf.delegate = self;
    _amountTf.keyboardType = UIKeyboardTypeDecimalPad;
    _amountTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [_amountTf addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    [amountView addSubview:_amountTf];
    [_amountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineThree = [[UIView alloc] init];
    lineThree.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [amountView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    //申请理由
    UIView *applyReasonView = [[UIView alloc] init];
    applyReasonView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:applyReasonView];
    [applyReasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *applyReasonLab = [[UILabel alloc] init];
    applyReasonLab.textAlignment = NSTextAlignmentLeft;
    applyReasonLab.font = Font(14);
    applyReasonLab.text = TransferVCApplyReason;
    applyReasonLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [applyReasonView addSubview:applyReasonLab];
    [applyReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _applyReasonTf = [[UITextField alloc] init];
    _applyReasonTf.placeholder = TransferVCApplyReasonInfo;
    _applyReasonTf.font = Font(14);
    _applyReasonTf.delegate = self;
    _applyReasonTf.keyboardType = UIKeyboardTypeDefault;
    _applyReasonTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [_applyReasonTf addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [applyReasonView addSubview:_applyReasonTf];
    [_applyReasonTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyReasonLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineFour= [[UIView alloc] init];
    lineFour.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineFour];
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyReasonView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    //矿工费用
    UIView *minersFeeView = [[UIView alloc] init];
    minersFeeView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:minersFeeView];
    [minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineFour.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(108);
    }];
    
    UILabel *minersFeeLab = [[UILabel alloc] init];
    minersFeeLab.textAlignment = NSTextAlignmentLeft;
    minersFeeLab.font = Font(14);
    minersFeeLab.text = TransferVCMinersFee;
    minersFeeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [minersFeeView addSubview:minersFeeLab];
    [minersFeeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(23);
        make.height.offset(20);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
    }];
    
    _progressSlider = [[UISlider alloc]init];
    //设置滑动条最大值
    _progressSlider.maximumValue=0.001;
    //设置滑动条的最小值，可以为负值
    _progressSlider.minimumValue=0;
    //设置滑动条的滑块位置float值
    _progressSlider.value=0.0;
    //左侧滑条背景颜色
    //x_progressSlider.minimumTrackTintColor=[UIColor colorWithHexString:@"#4c7afd"];
    //右侧滑条背景颜色
    //_progressSlider.maximumTrackTintColor=[UIColor colorWithHexString:@"#cfcfcf"];
    //设置滑块的颜色
    //_progressSlider.thumbTintColor = [UIColor colorWithHexString:@"#ffffff"];
    //对滑动条添加事件函数
    [_progressSlider addTarget:self action:@selector(pressSlider:) forControlEvents:UIControlEventValueChanged];
    minersFeeView.userInteractionEnabled = YES;
    [minersFeeView addSubview:_progressSlider];
    [_progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeLab.mas_bottom).offset(21);
        make.height.offset(35);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
    }];
    
    UILabel *slowLab = [[UILabel alloc] init];
    slowLab.textAlignment = NSTextAlignmentLeft;
    slowLab.font = Font(12);
    slowLab.text = TransferVCMinersFeeSlow;
    slowLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [minersFeeView addSubview:slowLab];
    [slowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressSlider.mas_bottom).offset(24);
        make.width.offset(40);
        make.left.offset(15);
        make.height.offset(17);
    }];
    
    _minersFeeLab = [[UILabel alloc] init];
    _minersFeeLab.textAlignment = NSTextAlignmentCenter;
    _minersFeeLab.font = Font(12);
    _minersFeeLab.text = @"0.00000000";
    _minersFeeLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [minersFeeView addSubview:_minersFeeLab];
    [_minersFeeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressSlider.mas_bottom).offset(24);
        make.width.offset(SCREEN_WIDTH - 55*2);
        make.centerX.equalTo(applyReasonView);
        make.height.offset(17);
    }];
    
    UILabel *fastLab = [[UILabel alloc] init];
    fastLab.textAlignment = NSTextAlignmentRight;
    fastLab.font = Font(12);
    fastLab.text = TransferVCMinersFeeFast;
    fastLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [minersFeeView addSubview:fastLab];
    [fastLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressSlider.mas_bottom).offset(24);
        make.width.offset(40);
        make.right.offset(-15);
        make.height.offset(17);
    }];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setTitle:TransferVCBtnTitle forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    //_commitBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    _commitBtn.titleLabel.font = Font(16);
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.layer.cornerRadius = 2.0f;
    [_commitBtn addTarget:self action:@selector(cormfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_commitBtn];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.top.offset(SCREEN_HEIGHT - (kTopHeight - 64) - kTopHeight - 63- 46);
        make.height.offset(46);
    }];
    _commitBtn.enabled = NO;
}

#pragma mark ----- textFieldDidChange -----
- (void)textFieldDidChange:(UITextField *)textField
{
    if (_approvalProcessTf.text.length > 0 && _currencyTf.text.length > 0 && _addressTf.text.length > 0 && _amountTf.text.length > 0 && _applyReasonTf.text.length > 0) {
        _commitBtn.enabled = YES;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    }else{
        _commitBtn.enabled = NO;
        _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    }
}

#pragma mark ----- currencyAction -----
-(void)approvalProcessAction:(UIButton *)btn
{
    SearchApprovalViewController *searchApprovalVc = [[SearchApprovalViewController alloc] init];
    searchApprovalVc.approvalBlock = ^(ApprovalBusinessModel *model){
        _approvalProcessTf.text = model.flow_name;
        _approvalBusinessModel = model;
    };
    [self.navigationController pushViewController:searchApprovalVc animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _currencyTf) {
        return NO;
    }
    return YES;
}

#pragma mark -----  地址簿 -----
-(void)addressTextAction:(UIButton *)btn
{
    HomeDirectoryViewController *directoryVC = [[HomeDirectoryViewController alloc] init];
    directoryVC.model = _mode;
    directoryVC.addressBlock = ^(NSString *addressText){
        _addressTf.text = addressText;
    };
    directoryVC.type = @"getAddress";
    [self.navigationController pushViewController:directoryVC animated:YES];
}

#pragma mark -----  扫描二维码获取地址 -----
-(void)scanAction:(UIButton *)btn
{
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    scanCodeVC.fromFunction = fromTransfer;
    scanCodeVC.codeBlock = ^(NSString *codeText){
        _addressTf.text = codeText;
    };
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

#pragma mark -----  设置矿工费 -----
-(void)pressSlider:(UISlider *)slider
{
    CGFloat value = slider.value;
    _minersFeeLab.text = [NSString stringWithFormat:@"%.8f", value];
}

#pragma mark -----  提交审批 -----
-(void)cormfirmAction:(UIButton *)btn
{
    CGFloat amountFloat= [_amountTf.text floatValue];
    CGFloat flowLimit = [_approvalBusinessModel.single_limit floatValue];
    if (amountFloat > flowLimit) {
        [WSProgressHUD showErrorWithStatus:@"金额超出上限"];
        return;
    }
    NSInteger timestampIn = [[NSDate date]timeIntervalSince1970] * 1000;
    NSString *timestamp = [NSString stringWithFormat:@"%ld", timestampIn];
    NSDictionary *applyInfoDic = @{@"currency":_currencyTf.text,
                                   @"to_address":_addressTf.text,
                                   @"amount":_amountTf.text,
                                   @"tx_info":_applyReasonTf.text,
                                   @"miner":_minersFeeLab.text,
                                   @"timestamp":timestamp
                                   };
    
    _transferView = [[TransferView alloc] initWithFrame:[UIScreen mainScreen].bounds dic:applyInfoDic flowName:_approvalBusinessModel.flow_name];
    _transferView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_transferView];
}

#pragma mark -----  TransferViewDelegate -----
-(void)transferDidAchieve
{
    _manager.enable = NO;
    _manager.shouldResignOnTouchOutside = NO;
    _manager.shouldToolbarUsesTextFieldTintColor = NO;
    _manager.enableAutoToolbar = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showProgressHUD
{
    [WSProgressHUD setProgressHUDIndicatorStyle:WSProgressHUDIndicatorBigGray];
    [WSProgressHUD show];
}

#pragma mark -----  TransferViewDelegate -----
- (void)transferViewDelegate:(NSDictionary *)dic
{
    NSString *applyInfo = [JsonObject dictionaryToJson:dic];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:applyInfo privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:applyInfo signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:applyInfo forKey:@"apply_info"];
    [paramsDic setObject:_approvalBusinessModel.flow_id forKey:@"flow_id"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/transfer/application" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
            [_transferView createAchieveView];
        }else{
            [ProgressHUD showStatus:[dict[@"code"] integerValue]];
        }
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
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
