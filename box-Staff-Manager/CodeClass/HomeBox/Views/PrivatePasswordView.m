//
//  PrivatePasswordView.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/14.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "PrivatePasswordView.h"

#define PrivatePasswordbackupLab @"密码"
#define PrivatePasswordComfirm @"确认"

@interface PrivatePasswordView ()<UITextFieldDelegate>
/** 密码 */
@property (nonatomic,strong)UITextField *passwordTf;
/** 取消 */
@property (nonatomic,strong)UIButton *cancelBtn;
/** 确认 */
@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UIView *footView;

@property (nonatomic, strong)UIButton *showPwdBtn;

@end

@implementation PrivatePasswordView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)createView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, SCREEN_HEIGHT - 300)];
    _topView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self addSubview:_topView];
    
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTopViewAction:)];
    _topView.userInteractionEnabled = YES;
    [_topView addGestureRecognizer:tapOne];
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 300,  SCREEN_WIDTH, 300)];
    _footView.backgroundColor = [UIColor colorWithHexString:@"#f7f8f9"];
    [self addSubview:_footView];
    
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchFootViewAction:)];
    _footView.userInteractionEnabled = YES;
    [_footView addGestureRecognizer:tapTwo];
    
    UILabel *backupLab = [[UILabel alloc] init];
    backupLab.text = PrivatePasswordbackupLab;
    backupLab.textAlignment = NSTextAlignmentCenter;
    backupLab.font = Font(16);
    backupLab.textColor = [UIColor colorWithHexString:@"#666666"];
    backupLab.numberOfLines = 1;
    [_footView addSubview:backupLab];
    [backupLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.centerX.equalTo(self);
        make.height.offset(30);
    }];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage: [UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = Font(17);
    
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backupLab);
        make.left.offset(2);
        make.width.offset(50);
        make.height.offset(40);
    }];
    
    UIView *topViewLine = [[UIView alloc] init];
    topViewLine.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_footView addSubview:topViewLine];
    [topViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backupLab.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(-0);
        make.height.offset(1);
    }];

    _passwordTf = [[UITextField alloc] init];
    _passwordTf.backgroundColor = [UIColor colorWithHexString:@"#f7f8f9"];
    _passwordTf.delegate = self;
    _passwordTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    NSString *backupText = @"请输入密码";
    NSMutableAttributedString *backupHolder = [[NSMutableAttributedString alloc] initWithString:backupText];
    [backupHolder addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#cccccc"]
                         range:NSMakeRange(0, backupText.length)];
    [backupHolder addAttribute:NSFontAttributeName
                         value:Font(15)
                         range:NSMakeRange(0, backupText.length)];
    _passwordTf.attributedPlaceholder = backupHolder;
    _passwordTf.keyboardType = UIKeyboardTypeAlphabet;
    _passwordTf.secureTextEntry = YES;
    [_footView addSubview:_passwordTf];
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topViewLine.mas_bottom).offset(0);
        make.left.offset(16);
        make.right.offset(-16-38);
        make.height.offset(56);
    }];
    
    _showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showPwdBtn setImage:[UIImage imageNamed:@"icon_kejian"] forState:UIControlStateNormal];
    [_showPwdBtn setImage:[UIImage imageNamed:@"icon_bukejian"] forState:UIControlStateSelected];
    _showPwdBtn.selected = YES;
    [_showPwdBtn addTarget:self action:@selector(showPwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_showPwdBtn];
    [_showPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_passwordTf);
        make.width.offset(36);
        make.right.offset(-16);
        make.height.offset(27);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_footView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTf.mas_bottom).offset(0);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(1);
    }];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:PrivatePasswordComfirm forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _confirmBtn.layer.cornerRadius = 2.0f;
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.titleLabel.font = Font(16);
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(25);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(46);
    }];
}

#pragma mark ----- 隐藏或者显示密码 -----
- (void)showPwdBtnAction{
    NSString *content = _passwordTf.text;
    _showPwdBtn.selected = !_showPwdBtn.isSelected;
    _passwordTf.secureTextEntry = _showPwdBtn.isSelected;
    _passwordTf.text = @"";
    _passwordTf.text = content;
}

-(void)touchTopViewAction:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

-(void)touchFootViewAction:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

#pragma mark ----- 取消 -----
-(void)cancelAction:(UIButton *)btn
{
    [self removeFromSuperview];
}

#pragma mark ----- 备份密码确认 -----
-(void)confirmAction:(UIButton *)btn
{
    if ([_passwordTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(PrivatePasswordViewDelegate:)]) {
        _confirmBtn.userInteractionEnabled = YES;
        [self.delegate PrivatePasswordViewDelegate:_passwordTf.text];
    }
}

#pragma mark ----- KeyboardWillShow -----
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSTimeInterval duration = [(notification.userInfo)[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [(notification.userInfo)[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //获取用户信息
    //NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    //获取键盘高度
    //CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //CGFloat keyBoardHeight = keyBoardBounds.size.height;
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationCurveToAnimationOptions(curve) animations:^{
        self.footView.frame = CGRectMake(0, SCREEN_HEIGHT - 300 - 145,  SCREEN_WIDTH, 300);
        
    } completion:nil];
}

#pragma mark ----- KeyboardWillShow -----
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval duration = [(notification.userInfo)[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [(notification.userInfo)[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationCurveToAnimationOptions(curve) animations:^{
        
        self.footView.frame = CGRectMake(0, SCREEN_HEIGHT - 300,  SCREEN_WIDTH, 300);
        
    } completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
