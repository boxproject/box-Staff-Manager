//
//  TransferView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferView.h"

@interface TransferView ()<UITextFieldDelegate>
/** 密码 */
@property (nonatomic,strong)UITextField *passwordTf;
/** 取消 */
@property (nonatomic,strong)UIButton *cancelBtn;
/** 确认 */
@property (nonatomic,strong)UIButton *confirmBtn;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *mainView;
@property (nonatomic,strong)UIView *mainTwoView;
@property (nonatomic,strong)UILabel *titlelab;
@property (nonatomic,strong)UILabel *approvalLab;
@property (nonatomic,strong)UILabel *currencyInfoLab;
@property (nonatomic,strong)UILabel *adressInfoLab;
@property (nonatomic,strong)UILabel *amountInfoLab;
@property (nonatomic,strong)UILabel *applyReasonInfoLab;
@property (nonatomic,strong)UILabel *minersFeeInfoLab;
@property (nonatomic,strong)UIButton *commitBtn;
@property (nonatomic,strong)UIButton *submitBtn;
@property (nonatomic,strong)UILabel *titleTwolab;
@property (nonatomic,strong)UIView *fullView;
@property (nonatomic,strong)NSDictionary *dict;

@end

@implementation TransferView

-(id)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic flowName:(NSString *)flowName{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView:dic flowName:flowName];
        _dict = dic;
    }
    return self;
}

-(void)createView:(NSDictionary *)dic flowName:(NSString *)flowName
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, SCREEN_HEIGHT - 417 - 54)];
    _topView.backgroundColor = [UIColor colorWithHexString:@"#18191c"];
    _topView.alpha = 0.6;
    [self addSubview:_topView];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 417 - 54,  SCREEN_WIDTH, 417 + 54)];
    _mainView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:_mainView];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor colorWithHexString:@"#fafaf"];
    [_mainView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(45);
    }];
    
    _titlelab = [[UILabel alloc] init];
    _titlelab.textAlignment = NSTextAlignmentCenter;
    _titlelab.font = Font(14);
    _titlelab.text = TransferViewTitle;
    _titlelab.textColor = [UIColor colorWithHexString:@"#666666"];
    [titleView addSubview:_titlelab];
    [_titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(70);
        make.right.offset(-70);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.left.offset(16);
        make.height.offset(22);
        make.width.offset(22);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(1);
    }];
    
    //审批流
    UILabel *approvalLab = [[UILabel alloc] init];
    approvalLab.textAlignment = NSTextAlignmentLeft;
    approvalLab.font = Font(14);
    approvalLab.text = TransferViewApproval;
    approvalLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_mainView addSubview:approvalLab];
    [approvalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(60);
        make.height.offset(53);
    }];
    
    _approvalLab = [[UILabel alloc] init];
    _approvalLab.textAlignment = NSTextAlignmentRight;
    _approvalLab.font = Font(14);
    _approvalLab.text = flowName;
    _approvalLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_mainView addSubview:_approvalLab];
    [_approvalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.left.equalTo(approvalLab.mas_right).offset(13);
        make.right.offset(-15);
        make.height.offset(53);
    }];
    
    UIView *lineZero = [[UIView alloc] init];
    lineZero.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainView addSubview:lineZero];
    [lineZero mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_approvalLab.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 31);
        make.height.offset(1);
    }];
    
    //币种
    UILabel *currencyLab = [[UILabel alloc] init];
    currencyLab.textAlignment = NSTextAlignmentLeft;
    currencyLab.font = Font(14);
    currencyLab.text = TransferViewCurrency;
    currencyLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_mainView addSubview:currencyLab];
    [currencyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineZero.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(60);
        make.height.offset(53);
    }];
    
    _currencyInfoLab = [[UILabel alloc] init];
    _currencyInfoLab.textAlignment = NSTextAlignmentRight;
    _currencyInfoLab.font = Font(14);
    _currencyInfoLab.text = dic[@"currency"];
    _currencyInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_mainView addSubview:_currencyInfoLab];
    [_currencyInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineZero.mas_bottom).offset(0);
        make.left.equalTo(currencyLab.mas_right).offset(13);
        make.right.offset(-15);
        make.height.offset(53);
    }];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currencyInfoLab.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 31);
        make.height.offset(1);
    }];
    
    //收款地址
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textAlignment = NSTextAlignmentLeft;
    addressLab.font = Font(14);
    addressLab.text = TransferViewReceiptAddress;
    addressLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_mainView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(60);
        make.height.offset(53);
    }];
    
    _adressInfoLab = [[UILabel alloc] init];
    _adressInfoLab.textAlignment = NSTextAlignmentRight;
    _adressInfoLab.font = Font(12);
    _adressInfoLab.text = dic[@"to_address"];;
    _adressInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_mainView addSubview:_adressInfoLab];
    [_adressInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.left.equalTo(addressLab.mas_right).offset(13);
        make.right.offset(-15);
        make.height.offset(53);
    }];
    
    UIView *lineThree = [[UIView alloc] init];
    lineThree.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_adressInfoLab.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 31);
        make.height.offset(1);
    }];
    
    //金额
    UILabel *amountLab = [[UILabel alloc] init];
    amountLab.textAlignment = NSTextAlignmentLeft;
    amountLab.font = Font(14);
    amountLab.text = TransferViewAmount;
    amountLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_mainView addSubview:amountLab];
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(60);
        make.height.offset(53);
    }];
    
    _amountInfoLab = [[UILabel alloc] init];
    _amountInfoLab.textAlignment = NSTextAlignmentRight;
    _amountInfoLab.font = Font(14);
    _amountInfoLab.text = dic[@"amount"];
    _amountInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_mainView addSubview:_amountInfoLab];
    [_amountInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree.mas_bottom).offset(0);
        make.left.equalTo(amountLab.mas_right).offset(13);
        make.right.offset(-15);
        make.height.offset(53);
    }];
    
    UIView *lineFour = [[UIView alloc] init];
    lineFour.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainView addSubview:lineFour];
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_amountInfoLab.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 31);
        make.height.offset(1);
    }];
    
    //申请理由
    UILabel *applyReasonLab = [[UILabel alloc] init];
    applyReasonLab.textAlignment = NSTextAlignmentLeft;
    applyReasonLab.font = Font(14);
    applyReasonLab.text = TransferViewApplyReason;
    applyReasonLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_mainView addSubview:applyReasonLab];
    [applyReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineFour.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(60);
        make.height.offset(53);
    }];
    
    _applyReasonInfoLab = [[UILabel alloc] init];
    _applyReasonInfoLab.textAlignment = NSTextAlignmentRight;
    _applyReasonInfoLab.font = Font(14);
    _applyReasonInfoLab.text = dic[@"tx_info"];
    _applyReasonInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_mainView addSubview:_applyReasonInfoLab];
    [_applyReasonInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineFour.mas_bottom).offset(0);
        make.left.equalTo(applyReasonLab.mas_right).offset(13);
        make.right.offset(-15);
        make.height.offset(53);
    }];
    
    UIView *lineFive = [[UIView alloc] init];
    lineFive.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainView addSubview:lineFive];
    [lineFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_applyReasonInfoLab.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 31);
        make.height.offset(1);
    }];
    
    //矿工费
    UILabel *minersFeeLab = [[UILabel alloc] init];
    minersFeeLab.textAlignment = NSTextAlignmentLeft;
    minersFeeLab.font = Font(14);
    minersFeeLab.text = TransferViewMinersFee;
    minersFeeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [_mainView addSubview:minersFeeLab];
    [minersFeeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineFive.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(60);
        make.height.offset(53);
    }];
    
    _minersFeeInfoLab = [[UILabel alloc] init];
    _minersFeeInfoLab.textAlignment = NSTextAlignmentRight;
    _minersFeeInfoLab.font = Font(14);
    _minersFeeInfoLab.text = dic[@"miner"];
    _minersFeeInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_mainView addSubview:_minersFeeInfoLab];
    [_minersFeeInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineFive.mas_bottom).offset(0);
        make.left.equalTo(minersFeeLab.mas_right).offset(13);
        make.right.offset(-15);
        make.height.offset(53);
    }];
    
    UIView *lineSix = [[UIView alloc] init];
    lineSix.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainView addSubview:lineSix];
    [lineSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_minersFeeInfoLab.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 31);
        make.height.offset(1);
    }];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setTitle:TransferViewBtnTitle forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    //_commitBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    _commitBtn.titleLabel.font = Font(16);
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.layer.cornerRadius = 2.0f;
    [_commitBtn addTarget:self action:@selector(cormfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_commitBtn];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.top.equalTo(lineSix.mas_bottom).offset(30);
        make.height.offset(46);
    }];
    
}

-(void)createMainTwoView
{
    _mainTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 417 - 54,  SCREEN_WIDTH, 417 + 54)];
    _mainTwoView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:_mainTwoView];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor colorWithHexString:@"#fafaf"];
    [_mainTwoView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(45);
    }];
    
    _titleTwolab = [[UILabel alloc] init];
    _titleTwolab.textAlignment = NSTextAlignmentCenter;
    _titleTwolab.font = Font(14);
    _titleTwolab.text = TransferViewInputTitle;
    _titleTwolab.textColor = [UIColor colorWithHexString:@"#666666"];
    [titleView addSubview:_titleTwolab];
    [_titleTwolab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(70);
        make.right.offset(-70);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.left.offset(16);
        make.height.offset(22);
        make.width.offset(22);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainTwoView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(1);
    }];
    
    _passwordTf = [[UITextField alloc] init];
    _passwordTf.delegate = self;
    _passwordTf.font = Font(14);
    _passwordTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordTf.placeholder = TransferViewInputTitle;
    _passwordTf.keyboardType = UIKeyboardTypeAlphabet;
    _passwordTf.secureTextEntry = YES;
    [_mainTwoView addSubview:_passwordTf];
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(55);
    }];
    
    UIView *lineSix = [[UIView alloc] init];
    lineSix.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_mainTwoView addSubview:lineSix];
    [lineSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTf.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 31);
        make.height.offset(1);
    }];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setTitle:TransferViewBtnTitle forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _submitBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    //_commitBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    _submitBtn.titleLabel.font = Font(16);
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 2.0f;
    [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainTwoView addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.top.equalTo(lineSix.mas_bottom).offset(38);
        make.height.offset(46);
    }];
}

-(void)createAchieveView
{
    _mainTwoView.hidden = YES;
    _topView.hidden = YES;
    
    _fullView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _fullView.backgroundColor = kWhiteColor;
    [self addSubview:_fullView];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"icon_success"];
    [_fullView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(120);
        make.centerX.equalTo(_fullView);
        make.width.offset(110);
        make.height.offset(87);
    }];
    
    UILabel *laber = [[UILabel alloc] init];
    laber.text = TransferViewAchieveTitle;
    laber.textAlignment = NSTextAlignmentCenter;
    laber.font = Font(17);
    laber.textColor = [UIColor colorWithHexString:@"#444444"];
    [_fullView addSubview:laber];
    [laber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(20);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(24);
    }];
    
    UILabel *subLaber = [[UILabel alloc] init];
    subLaber.text = TransferViewAchieveSubTitle;
    subLaber.textAlignment = NSTextAlignmentCenter;
    subLaber.font = Font(14);
    subLaber.textColor = [UIColor colorWithHexString:@"#666666"];
    [_fullView addSubview:subLaber];
    [subLaber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(laber.mas_bottom).offset(8);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    UIButton *achieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [achieveBtn setTitle:TransferViewAchieveDid forState:UIControlStateNormal];
    achieveBtn.titleLabel.font = Font(14);
    achieveBtn.layer.cornerRadius = 38.0/2.0;
    achieveBtn.layer.masksToBounds = YES;
    achieveBtn.layer.borderWidth = 1.0f;
    achieveBtn.layer.borderColor = [UIColor colorWithHexString:@"#4c7afd"].CGColor;
    [achieveBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    [achieveBtn addTarget:self action:@selector(achieveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fullView addSubview:achieveBtn];
    [achieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(SCREEN_HEIGHT - 38 - 88);
        make.centerX.equalTo(_fullView);
        make.height.offset(38);
        make.width.offset(130);
    }];
}


-(void)backAction:(UIButton *)btn
{
   [self removeFromSuperview];
}

-(void)cormfirmAction:(UIButton *)btn
{
    _mainView.hidden = YES;
    [self createMainTwoView];
}

-(void)submitAction:(UIButton *)btn
{
    if ([_passwordTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:TransferViewPutPassWord];
        return;
    }
    /*
    if (![_passwordTf.text isEqualToString:[BoxDataManager sharedManager].passWord]) {
        [WSProgressHUD showErrorWithStatus:TransferViewPassWordError];
        return;
    }
     */
    if ([self.delegate respondsToSelector:@selector(transferViewDelegate:password:)]) {
        [self.delegate transferViewDelegate:_dict  password:_passwordTf.text];
    }
}

-(void)achieveBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(transferDidAchieve)]) {
        [self removeFromSuperview];
        [self.delegate transferDidAchieve];
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
