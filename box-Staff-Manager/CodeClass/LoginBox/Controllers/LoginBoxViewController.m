//
//  LoginBoxViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "LoginBoxViewController.h"
#import "HomePageViewController.h"

@interface LoginBoxViewController ()<UITextFieldDelegate>
/** 密码 */
@property (nonatomic,strong)UITextField *passwordTf;
/** 确认 */
@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic, strong)UIButton *showPwdBtn;

@property (nonatomic, strong)UIImageView *loginImg;

@end

@implementation LoginBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    [self createView];
}

-(void)createView
{
    UIImageView *backGroundImg = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backGroundImg.image = [UIImage imageNamed:@"bg_login"];
    [self.view addSubview:backGroundImg];
    backGroundImg.userInteractionEnabled = YES;
    
    _loginImg = [[UIImageView alloc] init];
    _loginImg.image = [UIImage imageNamed:@"icon_head"];
    [backGroundImg addSubview:_loginImg];
    [_loginImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.offset(62);
        make.top.offset(115);
    }];
    
    _passwordTf = [[UITextField alloc] init];
    //_passwordTf.backgroundColor = [UIColor colorWithHexString:@"#f7f8f9"];
    _passwordTf.delegate = self;
    _passwordTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    NSString *backupText = PerfectInformationVCAlertTwo;
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
    [backGroundImg addSubview:_passwordTf];
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginImg.mas_bottom).offset(55);
        make.left.offset(16);
        make.right.offset(-16-36);
        make.height.offset(56);
    }];
    
    _showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showPwdBtn setImage:[UIImage imageNamed:@"icon_kejian"] forState:UIControlStateNormal];
    [_showPwdBtn setImage:[UIImage imageNamed:@"icon_bukejian"] forState:UIControlStateSelected];
    _showPwdBtn.selected = YES;
    [_showPwdBtn addTarget:self action:@selector(showPwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backGroundImg addSubview:_showPwdBtn];
    [_showPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_passwordTf);
        make.width.offset(22);
        make.right.offset(-18);
        make.height.offset(13);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [backGroundImg addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTf.mas_bottom).offset(0);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(1);
    }];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:LoginButton forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _confirmBtn.layer.cornerRadius = 2.0f;
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.titleLabel.font = Font(16);
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundImg addSubview:_confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(60);
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

-(void)confirmAction:(UIButton *)btn
{
    if ( [_passwordTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:PerfectInformationVCAlertTwo];
        return;
    }
    NSString *hmacSHA256 = [UIARSAHandler hmac: _passwordTf.text withKey:[BoxDataManager sharedManager].encryptKey];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:hmacSHA256 forKey:@"password"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/accounts/login" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        NSString *token = dict[@"data"][@"token"];
        if ([dict[@"code"] integerValue] == 0) {
            [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
            [[BoxDataManager sharedManager] saveDataWithCoding:@"token" codeValue:token];
            [[BoxDataManager sharedManager] saveDataWithCoding:@"launchState" codeValue:@"1"];
            if (_fromFunction == FromHomeBox) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
                [self presentViewController:homePageVC animated:YES completion:nil];
            }
        }else{
            //code == 1018时提示解冻时间戳
            if ([dict[@"code"] integerValue] == 1018) {
               [ProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%@", AccountLockup, [self getElapseTimeToString:[dict[@"data"][@"frozenTo"] integerValue]]] code:[dict[@"code"] integerValue]];
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
