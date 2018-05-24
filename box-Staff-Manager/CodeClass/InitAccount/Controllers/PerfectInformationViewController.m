//
//  PerfectInformationViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/8.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "PerfectInformationViewController.h"
#import "InitAccountViewController.h"

#define PerfectInformationVCTitle  @"完善信息"
#define PerfectInformationVCNameText  @"请输入姓名"
#define PerfectInformationVCPasswordText  @"请输入密码 (只支持6-12位数字、字母区分大小写)"
#define PerfectInformationVCVerifiyText  @"请再次输入密码"
#define PerfectInformationVCAleartLab  @"此密码不可找回，请您牢记"
#define PerfectInformationVCCormfirmBtn  @"确认提交"
#define PerfectInformationVCAleartOne  @"请完善信息"
#define PerfectInformationVCAleartTwo  @"请输入密码"
#define PerfectInformationVCAleartThree  @"密码不一致"
#define PerfectInformationVCCheckPwd  @"密码必须为6-12位数字和字母组成"

@interface PerfectInformationViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
/** 姓名 */
@property (nonatomic,strong)UITextField *nameTf;
/** 私钥密码 */
@property (nonatomic,strong)UITextField *passwordTf;
/** 确认私钥密码 */
@property (nonatomic,strong)UITextField *verifyPwFf;
/** 提交完善的信息 */
@property (nonatomic, strong) UIButton *cormfirmButton;

@end

@implementation PerfectInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = PerfectInformationVCTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
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
    _nameTf.delegate = self;
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
    NSString *passwordText = PerfectInformationVCPasswordText;
    NSMutableAttributedString *passwordholder = [[NSMutableAttributedString alloc] initWithString:passwordText];
    [passwordholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithHexString:@"#cccccc"]
                        range:NSMakeRange(0, passwordText.length)];
    [passwordholder addAttribute:NSFontAttributeName
                        value:Font(14)
                        range:NSMakeRange(0, passwordText.length)];
    _passwordTf.attributedPlaceholder = passwordholder;
    _passwordTf.keyboardType = UIKeyboardTypeAlphabet;
    _passwordTf.secureTextEntry = YES;
    [_contentView addSubview:_passwordTf];
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(55);
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
    NSString *verifiyText = PerfectInformationVCVerifiyText;
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
        make.width.offset(SCREEN_WIDTH - 32);
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
    //imgAlert.backgroundColor = kRedColor;
    [_contentView addSubview:imgAlert];
    [imgAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree.mas_bottom).offset(17);
        make.left.offset(16);
        make.width.offset(10);
        make.height.offset(10);
    }];
    
    UILabel *aleartLab = [[UILabel alloc]init];
    aleartLab.text = PerfectInformationVCAleartLab;
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
    [_cormfirmButton setTitle:PerfectInformationVCCormfirmBtn forState:UIControlStateNormal];
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
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCAleartOne];
        return;
    }
    if ([_passwordTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCAleartTwo];
        return;
    }
    BOOL checkBool = [PassWordManager checkPassWord:_passwordTf.text];
    if (!checkBool) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCCheckPwd];
        return;
    }

    if (![_passwordTf.text isEqualToString:_verifyPwFf.text]) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCAleartThree];
        return;
    }
    InitAccountViewController *initAccountVC = [[InitAccountViewController alloc] init];
    NSInteger applyer_idIn = [[NSDate date]timeIntervalSince1970] * 1000;
    NSString *applyer_id = [NSString stringWithFormat:@"%ld", applyer_idIn];
    initAccountVC.nameStr = _nameTf.text;
    initAccountVC.passwordStr = _passwordTf.text;
    initAccountVC.applyer_id = applyer_id;
    [self.navigationController pushViewController:initAccountVC animated:YES];
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
