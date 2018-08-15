//
//  PerfectInformationViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/8.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "PerfectInformationViewController.h"
#import "InitAccountViewController.h"
#import "LoginBoxViewController.h"

@interface PerfectInformationViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@property(nonatomic, strong)UIScrollView *contentView;
/** 姓名 */
@property (nonatomic,strong)UITextField *nameTf;
/** 私钥密码 */
@property (nonatomic,strong)UITextField *passwordTf;
/** 确认私钥密码 */
@property (nonatomic,strong)UITextField *verifyPwFf;
/** 提交完善的信息 */
@property (nonatomic, strong) UIButton *cormfirmButton;

@property (nonatomic, strong)UIButton *showPwdBtn;

@end

@implementation PerfectInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = PerfectInformationVCTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
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

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64))];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 60);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    _nameTf = [[UITextField alloc] init];
    _nameTf.backgroundColor = [UIColor whiteColor];
    _nameTf.tag = 100;
    _nameTf.delegate = self;
    _nameTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    NSString *nameText = PerfectInformationVCNameText;
    NSMutableAttributedString *nameholder = [[NSMutableAttributedString alloc] initWithString:nameText];
    [nameholder addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHexString:@"#cccccc"]
                        range:NSMakeRange(0, nameText.length)];
    [nameholder addAttribute:NSFontAttributeName
                        value:Font(14)
                        range:NSMakeRange(0, nameText.length)];
    _nameTf.attributedPlaceholder = nameholder;
    [_contentView addSubview:_nameTf];
    [_nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.offset(15);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(55);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(_nameTf.mas_bottom).offset(0);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(1);
    }];
    
    _passwordTf = [[UITextField alloc] init];
    _passwordTf.backgroundColor = [UIColor whiteColor];
    _passwordTf.delegate = self;
    _passwordTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    NSString *passwordText = PerfectInformationVCPasswordText;
    NSMutableAttributedString *passwordholder = [[NSMutableAttributedString alloc] initWithString:passwordText];
    [passwordholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithHexString:@"#cccccc"]
                        range:NSMakeRange(0, passwordText.length)];
    [passwordholder addAttribute:NSFontAttributeName
                        value:Font(14)
                        range:NSMakeRange(0, 5)];
    [passwordholder addAttribute:NSFontAttributeName
                           value:Font(13)
                           range:NSMakeRange(5, passwordText.length - 5)];
    _passwordTf.attributedPlaceholder = passwordholder;
    _passwordTf.keyboardType = UIKeyboardTypeAlphabet;
    _passwordTf.secureTextEntry = YES;
    [_contentView addSubview:_passwordTf];
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.width.offset(SCREEN_WIDTH - 32 - 36);
        make.height.offset(55);
    }];
    
    _showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showPwdBtn setImage:[UIImage imageNamed:@"icon_kejian"] forState:UIControlStateNormal];
    [_showPwdBtn setImage:[UIImage imageNamed:@"icon_bukejian"] forState:UIControlStateSelected];
    _showPwdBtn.selected = YES;
    [_showPwdBtn addTarget:self action:@selector(showPwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_showPwdBtn];
    [_showPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_passwordTf);
        make.width.offset(23);
        make.right.equalTo(lineOne.mas_right).offset(-5);
        make.height.offset(15);
    }];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(_passwordTf.mas_bottom).offset(0);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(1);
    }];

    _verifyPwFf = [[UITextField alloc] init];
    _verifyPwFf.backgroundColor = [UIColor whiteColor];
    _verifyPwFf.delegate = self;
    _verifyPwFf.clearButtonMode=UITextFieldViewModeWhileEditing;
    NSString *verifiyText = PerfectInformationVCVerifyText;
    NSMutableAttributedString *verifiyHolder = [[NSMutableAttributedString alloc] initWithString:verifiyText];
    [verifiyHolder addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHexString:@"#cccccc"]
                       range:NSMakeRange(0, verifiyText.length)];
    [verifiyHolder addAttribute:NSFontAttributeName
                       value:Font(14)
                       range:NSMakeRange(0, verifiyText.length)];
    _verifyPwFf.attributedPlaceholder = verifiyHolder;
    _verifyPwFf.keyboardType = UIKeyboardTypeAlphabet;
    _verifyPwFf.secureTextEntry = YES;
    [_contentView addSubview:_verifyPwFf];
    [_verifyPwFf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.width.offset(SCREEN_WIDTH - 32 - 36);
        make.height.offset(55);
    }];
    
    UIView *lineThree = [[UIView alloc] init];
    lineThree.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(_verifyPwFf.mas_bottom).offset(0);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(1);
    }];
    
    UIImageView *imgAlert = [[UIImageView alloc] init];
    imgAlert.image = [UIImage imageNamed: @"imgAlertRed_icon"];
    [_contentView addSubview:imgAlert];
    [imgAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree.mas_bottom).offset(17);
        make.left.offset(16);
        make.width.offset(10);
        make.height.offset(10);
    }];
    
    UILabel *aleartLab = [[UILabel alloc]init];
    aleartLab.text = PerfectInformationVCAlertLab;
    aleartLab.textAlignment = NSTextAlignmentLeft;
    aleartLab.font = Font(11);
    aleartLab.textColor = [UIColor colorWithHexString:@"#666666"];
    aleartLab.numberOfLines = 0;
    [_contentView addSubview:aleartLab];
    [aleartLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgAlert.mas_right).offset(5);
        make.centerY.equalTo(imgAlert);
        make.right.offset(SCREEN_WIDTH - 100);
        make.height.offset(16);
    }];
    
    _cormfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cormfirmButton setTitle:PerfectInformationVCConfirmBtn forState:UIControlStateNormal];
    [_cormfirmButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _cormfirmButton.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _cormfirmButton.titleLabel.font = Font(16);
    _cormfirmButton.layer.masksToBounds = YES;
    _cormfirmButton.layer.cornerRadius = 2.0f;
    [_cormfirmButton addTarget:self action:@selector(cormfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cormfirmButton];
    [_cormfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.top.equalTo(aleartLab.mas_bottom).offset(46);
        make.height.offset(91/2);
    }];
}

-(void)cormfirmAction:(UIButton *)btn
{
    if ( [_nameTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCAlertOne];
        return;
    }
    if ([_passwordTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCAlertTwo];
        return;
    }
    BOOL checkBool = [PassWordManager checkPassWord:_passwordTf.text];
    if (!checkBool) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCCheckPwd];
        return;
    }

    if (![_passwordTf.text isEqualToString:_verifyPwFf.text]) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCAlertThree];
        return;
    }
    InitAccountViewController *initAccountVC = [[InitAccountViewController alloc] init];
    NSInteger applyer_idIn = [[NSDate date]timeIntervalSince1970] * 1000;
    NSString *applyer_id = [NSString stringWithFormat:@"%ld", (long)applyer_idIn];
    initAccountVC.nameStr = _nameTf.text;
    initAccountVC.passwordStr = _passwordTf.text;
    initAccountVC.applyer_id = applyer_id;
    [self.navigationController pushViewController:initAccountVC animated:YES];
}

-(void)textViewEditChanged:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    if (textField.tag == 100) {
        // 需要限制的长度
        NSUInteger maxLength = 0;
        maxLength = 12;
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

#pragma mark ----- 隐藏或者显示密码 -----
- (void)showPwdBtnAction{
    NSString *content = _passwordTf.text;
    _showPwdBtn.selected = !_showPwdBtn.isSelected;
    _passwordTf.secureTextEntry = _showPwdBtn.isSelected;
    _passwordTf.text = @"";
    _passwordTf.text = content;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    NSString *allStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField.isSecureTextEntry==YES) {
        textField.text= allStr;
        return NO;
    }
    return YES;
}

-(void)dealloc
{
    returnKeyHandler = nil;
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
