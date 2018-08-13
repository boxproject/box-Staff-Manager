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
#import "LoginBoxViewController.h"

@interface TransferViewController ()<UITextFieldDelegate,UIScrollViewDelegate,TransferViewDelegate,CurrencyViewDelegate>
{
    NSInteger typeIn;
}
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
@property (nonatomic, strong)TransferView *transferView;
@property (nonatomic,strong)CurrencyView *currencyView;
@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic, strong) UILabel *remainingSumLab;
@property (nonatomic, strong) NSMutableArray *currencyArray;
@property (nonatomic, strong) NSString *amountStr;
@property (nonatomic, strong) UIView *contractView;
@property (nonatomic, strong) UILabel *contractLab;
@property (nonatomic, strong) UILabel *contractContentLab;
@property (nonatomic, strong)PickerModel *pickerModel;

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _pickerView = [[ValuePickerView alloc] init];
    _currencyArray = [[NSMutableArray alloc] init];
    [self createTitleView];
    [self createBarItem];
    [self createView];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
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
    /*
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
     */
    NSString *str = TransferVCTitle;
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", str]];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, str.length + 1)];
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
   
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 30);
    [button addTarget:self action:@selector(topTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_viewLayer addSubview:button];
     */
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

-(void)showProgressWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:Affirm style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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
    
    //币种
    UIView *currencyView = [[UIView alloc] init];
    currencyView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:currencyView];
    [currencyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
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
    //_currencyTf.text = _mode.currency;
    _currencyTf.placeholder = AddDirectoryVCcurrencyInfo;
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
    
    UIImageView *rightImgOne = [[UIImageView alloc] init];
    rightImgOne.image = [UIImage imageNamed:@"right_icon"];
    [currencyView addSubview:rightImgOne];
    [rightImgOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(currencyLab);
        make.width.offset(20);
        make.height.offset(22);
    }];
    
    UIButton *selectCurrencyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectCurrencyBtn addTarget:self action:@selector(selectCurrencyAction:) forControlEvents:UIControlEventTouchUpInside];
    [currencyView addSubview:selectCurrencyBtn];
    [selectCurrencyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
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
    
    //审批流
    UIView *approvalProcessView = [[UIView alloc] init];
    approvalProcessView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:approvalProcessView];
    [approvalProcessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(0);
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
    
    //收款地址
    UIView *addressView = [[UIView alloc] init];
    addressView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(0);
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
    _addressTf.keyboardType = UIKeyboardTypeASCIICapable;
    _addressTf.placeholder = TransferVCReceiptAddressInfo;
    if ([_fromType isEqualToString:@"scanCode"]) {
        _addressTf.text = [self handleAddress:_address];
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
    
    //合约地址
    _contractView = [[UIView alloc] init];
    _contractView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:_contractView];
    [_contractView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(0);
    }];
    
    _contractLab= [[UILabel alloc] init];
    _contractLab.textAlignment = NSTextAlignmentLeft;
    _contractLab.font = Font(14);
    _contractLab.text = ContractAddress;
    _contractLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_contractView addSubview:_contractLab];
    [_contractLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _contractContentLab = [[UILabel alloc] init];
    _contractContentLab.font = Font(14);
    _contractContentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _contractContentLab.numberOfLines = 2;
    [_contractView addSubview:_contractContentLab];
    [_contractContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contractLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *contractLine= [[UIView alloc] init];
    contractLine.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:contractLine];
    [contractLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contractView.mas_bottom).offset(-1);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    //金额
    UIView *amountView = [[UIView alloc] init];
    amountView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:amountView];
    [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contractLine.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(70);
    }];
    
    UILabel *amountLab = [[UILabel alloc] init];
    amountLab.textAlignment = NSTextAlignmentLeft;
    amountLab.font = Font(14);
    amountLab.text = TransferVCAmount;
    amountLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [amountView addSubview:amountLab];
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.height.offset(20);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _remainingSumLab = [[UILabel alloc] init];
    _remainingSumLab.textAlignment = NSTextAlignmentLeft;
    _remainingSumLab.font = Font(12);
    _remainingSumLab.text = [NSString stringWithFormat:@"%@：%@", RemainingSum, @"0.00000000"];
    _remainingSumLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [amountView addSubview:_remainingSumLab];
    [_remainingSumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLab.mas_bottom).offset(5);
        make.height.offset(15);
        make.right.offset(-15);
        make.left.equalTo(amountLab.mas_right).offset(15);
    }];
    
    _amountTf = [[UITextField alloc] init];
    _amountTf.placeholder = TransferVCAmountInfo;
    _amountTf.tag = 101;
    _amountTf.font = Font(14);
    if (_amount == nil) {
        //_amountTf.text = @"0";
    }else{
       _amountTf.text = _amount;
    }
    _amountTf.delegate = self;
    _amountTf.keyboardType = UIKeyboardTypeDecimalPad;
    _amountTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [_amountTf addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    [amountView addSubview:_amountTf];
    [_amountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountLab.mas_right).offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(20);
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
    _progressSlider.maximumValue=0.01;
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

-(void)textViewEditChanged:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    if (textField == _addressTf) {
        // 需要限制的长度
        NSUInteger maxLength = 0;
        maxLength = 60;
        if (maxLength == 0) return;
        // text field 的内容
        NSString *contentText = textField.text;
        // 获取高亮内容的范围
        UITextRange *selectedRange = [textField markedTextRange];
        // 这行代码 可以认为是 获取高亮内容的长度
        NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        // 没有高亮内容时,对已输入的文字进行操作
        if (markedTextLength == 0) {
            // 如果 text field 的内容长度大于我们限制的内容长度
            if (contentText.length > maxLength) {
                // 截取从前面开始maxLength长度的字符串
                // textField.text = [contentText substringToIndex:maxLength];
                // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [contentText substringWithRange:rangeRange];
            }
        }
    }else if (textField == _applyReasonTf){
        // 需要限制的长度
        NSUInteger maxLength = 0;
        maxLength = 50;
        if (maxLength == 0) return;
        // text field 的内容
        NSString *contentText = textField.text;
        // 获取高亮内容的范围
        UITextRange *selectedRange = [textField markedTextRange];
        // 这行代码 可以认为是 获取高亮内容的长度
        NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        // 没有高亮内容时,对已输入的文字进行操作
        if (markedTextLength == 0) {
            // 如果 text field 的内容长度大于我们限制的内容长度
            if (contentText.length > maxLength) {
                // 截取从前面开始maxLength长度的字符串
                // textField.text = [contentText substringToIndex:maxLength];
                // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [contentText substringWithRange:rangeRange];
            }
        }
    }
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
    if (textField.tag == 101) {
        [self calculateLimitAmount];
    }
}

//限制小数位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 101) {
        //判断小数点的位数
        NSRange ran=[textField.text rangeOfString:@"."];
        NSInteger tt=range.location-ran.location;
        if (tt <= 8){
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

-(void)calculateLimitAmount
{
    NSDictionary *dict =  _approvalBusinessModel.flow_limit[0];
    NSString *limitDic = dict[@"limit"];
    if (dict[@"limit"] == nil) {
        limitDic = @"0";
    }
    NSDecimalNumber *aa = [NSDecimalNumber decimalNumberWithString:limitDic];
    NSString *amountString;
    if ([_amountTf.text isEqualToString:@""]) {
        amountString = @"0";
    }else{
        amountString = _amountTf.text;
    }
    NSDecimalNumber *bb = [NSDecimalNumber decimalNumberWithString:amountString];
    NSDecimalNumber *subtra = [aa decimalNumberBySubtracting:bb];
    NSString *string = subtra.stringValue;
    if ([string hasPrefix:@"-"]) {
        NSString *str = dict[@"limit"];
        _amountTf.text = _amountStr;
        _remainingSumLab.font = Font(12);
        if ([str rangeOfString:@"."].location == NSNotFound) {
            str = [NSString stringWithFormat:@"%@%@", str, @"."];
            for (int i = 0; i < 8; i ++) {
                str = [NSString stringWithFormat:@"%@%@",str, @"0"];
            }
        } else {
            NSRange range = [str rangeOfString:@"."];
            NSString *content = [str substringFromIndex:(range.location + range.length)];
            NSInteger count = 8 - content.length;
            if (count > 0) {
                for (int i = 0; i < count; i ++) {
                    str = [NSString stringWithFormat:@"%@%@",str, @"0"];
                }
            }
        }
        _remainingSumLab.text = [NSString stringWithFormat:@"%@：%@", RemainingSum, str];

    }
    NSDictionary *dic =  _approvalBusinessModel.flow_limit[0];
    NSString *limit = dic[@"limit"];
    if (dic == nil) {
        limit = @"0";
    }
    NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:limit];
    NSString *amountStr;
    if ([_amountTf.text isEqualToString:@""]) {
        amountStr = @"0";
    }else{
        amountStr = _amountTf.text;
    }
    NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:amountStr];
    NSDecimalNumber *subtract = [a decimalNumberBySubtracting:b];
    NSString *str = subtract.stringValue;
     if ([str rangeOfString:@"."].location == NSNotFound) {
        str = [NSString stringWithFormat:@"%@%@", str, @"."];
        for (int i = 0; i < 8; i ++) {
            str = [NSString stringWithFormat:@"%@%@",str, @"0"];
        }
    } else {
        NSRange range = [str rangeOfString:@"."];
        NSString *content = [str substringFromIndex:(range.location + range.length)];
        NSInteger count = 8 - content.length;
        if (count > 0) {
            for (int i = 0; i < count; i ++) {
                str = [NSString stringWithFormat:@"%@%@",str, @"0"];
            }
        }
    }
    _remainingSumLab.font = Font(12);
    _remainingSumLab.text = [NSString stringWithFormat:@"%@：%@", RemainingSum, str];
    _amountStr = _amountTf.text;
}

#pragma mark ----- 选择币种 -----
-(void)selectCurrencyAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    [self requestCurrencyList];
}

-(void)showPickerView
{
     if (_currencyArray.count == 0) {
        return;
    }
    self.pickerView = [[ValuePickerView alloc]init];
    if (_pickerModel == nil) {
        NSInteger countIn = 0;
        countIn = _currencyArray.count/2;
        if (_currencyArray.count == 1) {
            countIn = 1;
        }
        PickerModel *model = _currencyArray[countIn - 1];
        [_currencyArray addObject:model];
    }else{
        [_currencyArray addObject:_pickerModel];
    }
    self.pickerView.dataSource = _currencyArray;
    self.pickerView.pickerTitle = SelectCurrency;
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(PickerModel *pickerModel){
        weakSelf.pickerModel = pickerModel;
        weakSelf.currencyTf.text = pickerModel.title;
        weakSelf.approvalProcessTf.text = @"";
        weakSelf.approvalBusinessModel = nil;
        weakSelf.amountTf.text = @"";
        weakSelf.remainingSumLab.text = [NSString stringWithFormat:@"%@：%@", RemainingSum, @"0.00000000"];
         if ([pickerModel.content hasPrefix:@"0x"] && pickerModel.content.length == 42 && ![pickerModel.title isEqualToString:@"ETH"]) {
            weakSelf.contractContentLab.text = pickerModel.content;
            [weakSelf.contractView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(52);
            }];
        }else{
            weakSelf.contractContentLab.text = @"";
            [weakSelf.contractView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
        }
        if ([pickerModel.title isEqualToString:@"ETH"]) {
            [weakSelf showProgressWithMessage: TransferVCETHAlert];
        }
    };
    [self.pickerView show];
}

#pragma mark  ----- 币种拉取 -----
-(void)requestCurrencyList
{
    if (typeIn == 1) {
        return;
    }
    typeIn = 1;
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/capital/currency/list" params:paramsDic success:^(id responseObject)
     {
         NSDictionary *dict = responseObject;
         if ([dict[@"code"] integerValue] == 0) {
             [_currencyArray removeAllObjects];
             for (NSDictionary *dataDic in dict[@"data"][@"currency_list"]) {
                 CurrencyModel *model = [[CurrencyModel alloc] initWithDict:dataDic];
                 PickerModel *pickerModel = [[PickerModel alloc] init];
                 pickerModel.title = model.currency;
                 pickerModel.content = model.tokenAddr;
                 [_currencyArray addObject:pickerModel];
             }
             [self showPickerView];
             typeIn = 0;
         }else{
             [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
         }
     } fail:^(NSError *error) {
         typeIn = 0;
         NSLog(@"%@", error.description);
     }];
}

#pragma mark ----- currencyAction -----
-(void)approvalProcessAction:(UIButton *)btn
{
     if ([_currencyTf.text isEqualToString:@""]) {
        return;
    }
    SearchApprovalViewController *searchApprovalVc = [[SearchApprovalViewController alloc] init];
    searchApprovalVc.currency = _currencyTf.text;
    searchApprovalVc.approvalBlock = ^(ApprovalBusinessModel *model){
        _approvalProcessTf.text = model.flow_name;
        _approvalBusinessModel = model;
        _amountTf.text = @"";
        [self calculateLimitAmount];
    };
    [self.navigationController pushViewController:searchApprovalVc animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _currencyTf) {
        return NO;
    }
    return YES;
}

-(NSString *)handleAddress:(NSString *)address
{
    /*
    NSString *str1 = [address substringToIndex:12];
    NSString *str2 = [address substringFromIndex:address.length - 12];
    NSString *str3 = [NSString stringWithFormat:@"%@...%@", str1, str2];
    */
    return address;
}

#pragma mark -----  地址簿 -----
-(void)addressTextAction:(UIButton *)btn
{
    HomeDirectoryViewController *directoryVC = [[HomeDirectoryViewController alloc] init];
    if (![_currencyTf.text isEqualToString:@""]) {
        directoryVC.currency = _currencyTf.text;
    }else{
        directoryVC.currency = @"ETH";
    }
    directoryVC.model = _mode;
    directoryVC.addressBlock = ^(NSString *addressText){
        _addressTf.text = [self handleAddress:addressText];
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
        _addressTf.text = [self handleAddress:codeText];
        _amountTf.text = @"";
    };
    scanCodeVC.codeArrBlock = ^(NSArray *codeArr){
        _addressTf.text = [self handleAddress:codeArr[0]];
        _amountTf.text = codeArr[1];
        [self calculateLimitAmount];
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
    BOOL checkBool = [AddressVerifyManager checkAddressVerify:_addressTf.text type:_currencyTf.text];
    if (!checkBool) {
        [WSProgressHUD showErrorWithStatus:AddressVerifyETHError];
        return;
    }
    CGFloat minerFloat = [_minersFeeLab.text floatValue];
    if (minerFloat == 0.0) {
        [WSProgressHUD showErrorWithStatus:MinersFeeLabAlert];
        return;
    }
    NSInteger timestampIn = [[NSDate date]timeIntervalSince1970] * 1000;
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)timestampIn];
    NSDictionary *applyInfoDic = @{@"currency":_currencyTf.text,
                                   @"to_address":_addressTf.text,
                                   @"amount":_amountTf.text,
                                   @"tx_info":_applyReasonTf.text,
                                   @"miner":_minersFeeLab.text,
                                   @"timestamp":timestamp
                                   };
    
    _transferView = [[TransferView alloc] initWithFrame:[UIScreen mainScreen].bounds dic:applyInfoDic flowName:_approvalBusinessModel.flow_name contractAddress:_contractContentLab.text];
    _transferView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_transferView];
}

#pragma mark -----  TransferViewDelegate -----
-(void)transferDidAchieve
{
    if ([self.delegate respondsToSelector:@selector(backRefleshTransfer)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        UIViewController *vc = self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:NULL];
        [self.delegate backRefleshTransfer];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        UIViewController *vc = self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:NULL];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshBox" object:nil];
    }
}

-(void)showProgressHUD
{
    [WSProgressHUD setProgressHUDIndicatorStyle:WSProgressHUDIndicatorBigGray];
    [WSProgressHUD show];
}

#pragma mark -----  TransferViewDelegate -----
- (void)transferViewDelegate:(NSDictionary *)dic password:(NSString *)password
{
    NSString *applyInfo = [JsonObject dictionaryToJson:dic];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:applyInfo privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:applyInfo signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSString *hmacSHA256 = [UIARSAHandler hmac: password withKey:[BoxDataManager sharedManager].encryptKey];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [paramsDic setObject:applyInfo forKey:@"apply_info"];
    [paramsDic setObject:_approvalBusinessModel.flow_id forKey:@"flow_id"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:hmacSHA256 forKey:@"password"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/transfer/application" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
            [_transferView createAchieveView];
        }else{
            //code == 1018时提示解冻时间戳
            if ([dict[@"code"] integerValue] == 1018) {
                [ProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%@", AccountLockup, [self getElapseTimeToString:[dict[@"data"][@"frozenTo"] integerValue]]] code:[dict[@"code"] integerValue]];
                if ([BoxDataManager sharedManager].launchState == LoginState) {
                    return ;
                }
                LoginBoxViewController *loginVc = [[LoginBoxViewController alloc] init];
                loginVc.fromFunction = FromAppDelegate;
                [self presentViewController:loginVc animated:YES completion:nil];
                [[BoxDataManager sharedManager] saveDataWithCoding:@"launchState" codeValue:@"2"];
            }
            //输入密码错误且未被冻结
            else if ([dict[@"code"] integerValue] == 1016) {
                [ProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%ld%@%@%ld%@", AccountPasswordError,[dict[@"data"][@"frozenFor"] integerValue], AccountPasswordHour, AccountPasswordAlert,[dict[@"data"][@"attempts"] integerValue], AccountPasswordTimes] code:[dict[@"code"] integerValue]];
            }else{
                [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
            }        }
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
}

- (NSString *)getElapseTimeToString:(NSInteger)second{
    NSDateFormatter  *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval1 = second;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval1];
    NSString *dateStr1=[dateformatter1 stringFromDate:date1];
    return dateStr1;
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
