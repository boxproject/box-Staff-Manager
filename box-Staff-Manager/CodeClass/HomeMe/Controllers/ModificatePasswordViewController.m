//
//  ModificatePasswordViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ModificatePasswordViewController.h"
#import "LoginBoxViewController.h"

@interface ModificatePasswordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    NSString *oldpwdSHA256;
    NSString *newpwdSHA256;
    NSString *encryptKey;
}
@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong)UITextField *originalPawdTf;
@property (nonatomic,strong)UITextField *pawdnewTf;
@property (nonatomic,strong)UITextField *renewPawdTf;
@property (nonatomic,strong)UIButton *verifyBtn;

@end

@implementation ModificatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = ModifyPassword;
    [self createView];
    [self createBarItem];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
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
    
    //原密码
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:originalView];
    [originalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(50);
    }];
    
    UILabel *originalLab = [[UILabel alloc] init];
    originalLab.textAlignment = NSTextAlignmentLeft;
    originalLab.font = Font(14);
    originalLab.text = ModificatePasswordVCoriginalPawd;
    originalLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [originalView addSubview:originalLab];
    [originalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(16);
        make.width.offset(70);
    }];
    
    _originalPawdTf = [[UITextField alloc] init];
    _originalPawdTf.font = Font(14);
    _originalPawdTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    _originalPawdTf.placeholder = ModificatePasswordVCoriginalPawdInfo;
    _originalPawdTf.delegate = self;
    _originalPawdTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _originalPawdTf.keyboardType = UIKeyboardTypeAlphabet;
    _originalPawdTf.secureTextEntry = YES;
    [originalView addSubview:_originalPawdTf];
    [_originalPawdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originalLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];

    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originalView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    //新密码
    UIView *pawdnewView = [[UIView alloc] init];
    pawdnewView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:pawdnewView];
    [pawdnewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(50);
    }];
    
    UILabel *pawdnewLab = [[UILabel alloc] init];
    pawdnewLab.textAlignment = NSTextAlignmentLeft;
    pawdnewLab.font = Font(14);
    pawdnewLab.text = ModificatePasswordVCpawdnew;
    pawdnewLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [pawdnewView addSubview:pawdnewLab];
    [pawdnewLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(16);
        make.width.offset(70);
    }];
    
    _pawdnewTf = [[UITextField alloc] init];
    _pawdnewTf.font = Font(14);
    NSString *passwordText = ModificatePasswordVCInfopawdnew;
    NSMutableAttributedString *passwordholder = [[NSMutableAttributedString alloc] initWithString:passwordText];
    [passwordholder addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexString:@"#cccccc"]
                           range:NSMakeRange(0, passwordText.length)];
    [passwordholder addAttribute:NSFontAttributeName
                           value:Font(14)
                           range:NSMakeRange(0, 5)];
    [passwordholder addAttribute:NSFontAttributeName
                           value:Font(14)
                           range:NSMakeRange(5, passwordText.length - 5)];
    _pawdnewTf.attributedPlaceholder = passwordholder;
    _pawdnewTf.delegate = self;
    _pawdnewTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    _pawdnewTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _pawdnewTf.keyboardType = UIKeyboardTypeAlphabet;
    _pawdnewTf.secureTextEntry = YES;
    [pawdnewView addSubview:_pawdnewTf];
    [_pawdnewTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pawdnewLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pawdnewView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    //再次输入新密码
    UIView *renewPawdView = [[UIView alloc] init];
    renewPawdView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:renewPawdView];
    [renewPawdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(50);
    }];
    
    UILabel *renewPawdLab = [[UILabel alloc] init];
    renewPawdLab.textAlignment = NSTextAlignmentLeft;
    renewPawdLab.font = Font(14);
    renewPawdLab.text = ModificatePasswordVCConfirm;
    renewPawdLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [renewPawdView addSubview:renewPawdLab];
    [renewPawdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(16);
        make.width.offset(70);
    }];
    
    _renewPawdTf = [[UITextField alloc] init];
    _renewPawdTf.font = Font(14);
    _renewPawdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _renewPawdTf.placeholder = ModificatePasswordVCRenewPawdInfo;
    _renewPawdTf.delegate = self;
    _renewPawdTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _renewPawdTf.keyboardType = UIKeyboardTypeAlphabet;
    _renewPawdTf.secureTextEntry = YES;
    [renewPawdView addSubview:_renewPawdTf];
    [_renewPawdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(renewPawdLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineThree = [[UIView alloc] init];
    lineThree.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(renewPawdView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyBtn setTitle:ModificatePasswordVCVerify forState:UIControlStateNormal];
    [_verifyBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _verifyBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _verifyBtn.titleLabel.font = Font(16);
    _verifyBtn.layer.masksToBounds = YES;
    _verifyBtn.layer.cornerRadius = 2.0f;
    [_verifyBtn addTarget:self action:@selector(verifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_verifyBtn];
    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree.mas_bottom).offset(41);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(46);
    }];
    
}

-(void)verifyAction:(UIButton *)Btn
{
    if ([_originalPawdTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:ModificatePasswordVCoriginalPawdInfo];
        return;
    }
    if ([_pawdnewTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:ModificatePasswordVCpawdnewInfo];
        return;
    }
    BOOL checkBool = [PassWordManager checkPassWord:_pawdnewTf.text];
    if (!checkBool) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCCheckPwd];
        return;
    }
    if (![_pawdnewTf.text isEqualToString:_renewPawdTf.text]) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCAlertThree];
        return;
    }
    
    if ([[BoxDataManager sharedManager].encryptKey isEqualToString:@"AAAA1111"]) {
        encryptKey = [JsonObject getRandomStringWithNum:8];
        oldpwdSHA256 = [UIARSAHandler hmac: _originalPawdTf.text withKey:[BoxDataManager sharedManager].encryptKey];
        newpwdSHA256 = [UIARSAHandler hmac: _pawdnewTf.text withKey:encryptKey];
    }else{
        oldpwdSHA256 = [UIARSAHandler hmac: _originalPawdTf.text withKey:[BoxDataManager sharedManager].encryptKey];
        newpwdSHA256 = [UIARSAHandler hmac: _pawdnewTf.text withKey:[BoxDataManager sharedManager].encryptKey];
    }
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:oldpwdSHA256 forKey:@"oldpwd"];
    [paramsDic setObject:newpwdSHA256 forKey:@"newpwd"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/accounts/passwords/modify" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
            [[BoxDataManager sharedManager] saveDataWithCoding:@"passWord" codeValue:_pawdnewTf.text];
            [self.navigationController popViewControllerAnimated:YES];
            if ([[BoxDataManager sharedManager].encryptKey isEqualToString:@"AAAA1111"]) {
                [[BoxDataManager sharedManager] saveDataWithCoding:@"encryptKey" codeValue:encryptKey];
            }
        }else{
            //code == 1018时提示解冻时间戳
            if ([dict[@"code"] integerValue] == 1018) {
                if ([BoxDataManager sharedManager].launchState == LoginState) {
                    return ;
                }
                [ProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%@", AccountLockup, [self getElapseTimeToString:[dict[@"data"][@"frozenTo"] integerValue]]] code:[dict[@"code"] integerValue]];
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
            }
        }
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

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
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

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
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
