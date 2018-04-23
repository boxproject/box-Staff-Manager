//
//  ScanAdressViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ScanAdressViewController.h"

#define ScanAdressVCTitle  @"绑定码"
#define ScanAdressVCScanLab  @"绑定二维码"
#define ScanAdressVCDetailLab  @"用员工App扫描以上二维码，进行绑定"
#define ScanAdressVCAuthorizeBtn  @"本机授权"
#define ScanAdressVCAleartLab  @"为避免资金风险，请勿分享授权码给他人，截屏自动失效"
#define ScanAdressVCIknown  @"我知道了"

@interface ScanAdressViewController ()<UIScrollViewDelegate, UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSTimer *registTimer;
    NSTimer *codeTimer;
}

@property(nonatomic, strong)UIScrollView *contentView;
/** 授权码 */
@property(nonatomic, strong)UIImageView *accountQRCodeImg;
@property(nonatomic, strong)UILabel *detailLab;
@property(nonatomic, strong)UIButton *authorizeBtn;
@property(nonatomic, strong)MBProgressHUD *progressHUD;
@property(nonatomic, strong)UIView *aleartView;
@property(nonatomic, strong)NSString *randomStr;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation ScanAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = ScanAdressVCTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createBarItem];
    [self createView];
    [self initProgressHUD];
}

#pragma mark ----- 绑定二维码30秒变化一次 -----
-(void)codeChange:(NSTimer *)timer
{
   _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:[self generateAuthorizationCode]];
}

-(NSString *)generateAuthorizationCode
{
    NSString *box_IP = [BoxDataManager sharedManager].box_IP;
    NSArray *box_IPArr = [box_IP componentsSeparatedByString:@"//"];
    _randomStr = [JsonObject getRandomStringWithNum:8];
    NSArray *codeArray = [NSArray arrayWithObjects:box_IPArr[1], _randomStr, [BoxDataManager sharedManager].app_account_id, nil];
    NSString *codeSting = [JsonObject dictionaryToarrJson:codeArray];
    return codeSting;
}


#pragma mark ----- 上级APP轮询注册申请 -----
-(void)registrationsPending:(NSTimer *)timer
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"captain_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/registrations/pending" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0 && ![dict[@"data"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in dict[@"data"]) {
                [self handleRegistrationsPending:dic];
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)handleRegistrationsPending:(NSDictionary *)dic
{
    NSString *manager_id = dic[@"manager_id"]; //直属上级唯一标识符
    if (![[BoxDataManager sharedManager].app_account_id isEqualToString:manager_id]) {
        return;
    }
    NSString *consent = dic[@"consent"];//0暂无结果 1拒绝 2同意
    if ([consent isEqualToString:@"2"] || [consent isEqualToString:@"1"]) {
        return;
    }
    NSString *msg = dic[@"msg"]; //加密后的注册信息, string
    NSString *applyer_id = dic[@"applyer_id"]; //申请者唯一标识符
    NSString *reg_id = dic[@"reg_id"]; //服务端申请表ID
    NSString *applyer_Account = dic[@"applyer_account"]; //申请者账户
    NSString *randomString = [FSAES128 AES128DecryptString:msg keyStr:_randomStr];
    if (randomString == nil) {
        NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
        [paramsDic setObject:reg_id forKey:@"reg_id"];
        [paramsDic setObject:@"1" forKey:@"consent"];
        [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/registrations/approval" params:paramsDic success:^(id responseObject) {
            NSDictionary *dict = responseObject;
            if ([dict[@"code"] integerValue] == 0) {
                NSLog(@"------------------%@", dict[@"message"]);
            }
        } fail:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
    }else{
        NSArray *randomArray = [JsonObject dictionaryWithJsonStringArr:randomString];
        
        NSString *applyer_pub_key = randomArray[1];
        NSString *menber_random = randomArray[0];
        
        NSDictionary *menberDic = @{@"menber_id":applyer_id,
                                    @"menber_account":applyer_Account,
                                    @"publicKey":applyer_pub_key,
                                    @"menber_random":menber_random,
                                    @"directIdentify":@(1)
                                    };
        MenberInfoModel *model = [[MenberInfoModel alloc] initWithDict:menberDic];
        if (applyer_pub_key !=  nil) {
            //该账号对申请者公钥的签名信息
            NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:applyer_pub_key privateStr:[BoxDataManager sharedManager].privateKeyBase64];
            //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:applyer_pub_key signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
            //该账号对申请者公钥生成的信息摘要
            NSString *hmacSHA256 = [UIARSAHandler hmac:applyer_pub_key withKey:[BoxDataManager sharedManager].app_account_random];
            NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
            [paramsDic setObject:reg_id forKey:@"reg_id"];
            [paramsDic setObject:@"2" forKey:@"consent"];
            [paramsDic setObject:applyer_pub_key forKey:@"applyer_pub_key"];
            [paramsDic setObject:signSHA256 forKey:@"en_pub_key"];
            [paramsDic setObject:hmacSHA256 forKey:@"cipher_text"];
            
            [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/registrations/approval" params:paramsDic success:^(id responseObject) {
                NSDictionary *dict = responseObject;
                if ([dict[@"code"] integerValue] == 0) {
                    NSLog(@"------------------%@", dict[@"message"]);
                    [[MenberInfoManager sharedManager] insertMenberInfoModel:model];
                }
            } fail:^(NSError *error) {
                NSLog(@"%@", error.description);
            }];
        }
    }
}

- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = [UIColor colorWithHexString:@"#292e40"];;
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [redColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)initProgressHUD
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.delegate = self;
    //添加ProgressHUD到界面中
    [self.view addSubview:self.progressHUD];
}

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64) )];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT + 1);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = kWhiteColor;
    oneView.layer.cornerRadius = 3.f;
    oneView.layer.masksToBounds = YES;
    [_contentView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.width.offset(SCREEN_WIDTH - 34);
        make.top.offset(35);
        make.height.offset(699/2);
    }];
    
    UIView *oneBackView = [[UIView alloc] init];
    oneBackView.backgroundColor = [UIColor colorWithHexString:@"#f5f7fa"];
    [oneView addSubview:oneBackView];
    [oneBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(45);
    }];
    
    UIImageView *scanIconImg = [[UIImageView alloc] init];
    scanIconImg.image = [UIImage imageNamed:@"scanIconImg"];
    [oneBackView addSubview:scanIconImg];
    [scanIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(14);
        make.centerY.equalTo(oneBackView);
        make.height.offset(14);
    }];
    
    UILabel *scanLab = [[UILabel alloc] init];
    scanLab.text = ScanAdressVCScanLab;
    scanLab.textAlignment = NSTextAlignmentLeft;
    scanLab.font = Font(13);
    scanLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [oneBackView addSubview:scanLab];
    [scanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(scanIconImg.mas_right).offset(8);
        make.height.offset(45);
        make.right.offset(0);
    }];
    
    _accountQRCodeImg = [[UIImageView alloc] init];
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:@"hahahah"];
    [oneView addSubview:_accountQRCodeImg];
    [_accountQRCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBackView.mas_bottom).offset(79/2);
        make.centerX.equalTo(oneView);
        make.height.offset(370/2);
        make.width.offset(370/2);
    }];
    
    _detailLab = [[UILabel alloc] init];
    _detailLab.text = ScanAdressVCDetailLab;
    _detailLab.textAlignment = NSTextAlignmentCenter;
    _detailLab.font = Font(11);
    _detailLab.textColor = [UIColor colorWithHexString:@"#8e9299"];
    [oneView addSubview:_detailLab];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-12);
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(41.0/2.0);
        make.height.offset(31.0/2.0);
    }];
    
    [self createAleartView];
}

-(void)createAleartView
{
    _aleartView = [[UIView alloc] init];
    _aleartView.backgroundColor = kWhiteColor;
    _aleartView.layer.cornerRadius = 3.f;
    _aleartView.layer.masksToBounds = YES;
    [_contentView addSubview:_aleartView];
    [_aleartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.width.offset(SCREEN_WIDTH - 34);
        make.top.offset(35);
        make.height.offset(699/2);
    }];
    
    UIImageView *thiefImg = [[UIImageView alloc] init];
    thiefImg.image = [UIImage imageNamed:@"icon_thief"];
    [_aleartView addSubview:thiefImg];
    [thiefImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(60);
        make.centerX.equalTo(_aleartView);
        make.width.offset(120);
        make.height.offset(187.0/2.0);
    }];
    
    UILabel *aleartLab = [[UILabel alloc] init];
    aleartLab.text = ScanAdressVCAleartLab;
    aleartLab.textAlignment = NSTextAlignmentCenter;
    aleartLab.font = Font(15);
    aleartLab.numberOfLines = 0;
    aleartLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_aleartView addSubview:aleartLab];
    [aleartLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-40);
        make.top.equalTo(thiefImg.mas_bottom).offset(30);
        make.height.offset(42);
    }];
    
    UIButton *achieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [achieveBtn setTitle:ScanAdressVCIknown forState:UIControlStateNormal];
    achieveBtn.titleLabel.font = Font(14);
    achieveBtn.layer.cornerRadius = 38.0/2.0;
    achieveBtn.layer.masksToBounds = YES;
    achieveBtn.layer.borderWidth = 1.0f;
    achieveBtn.layer.borderColor = [UIColor colorWithHexString:@"#4c7afd"].CGColor;
    [achieveBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    [achieveBtn addTarget:self action:@selector(achieveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_aleartView addSubview:achieveBtn];
    [achieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aleartLab.mas_bottom).offset(45);
        make.centerX.equalTo(_aleartView);
        make.height.offset(38);
        make.width.offset(130);
    }];
}

-(void)achieveBtnAction:(UIButton *)btn
{
    _aleartView.hidden = YES;
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:[self generateAuthorizationCode]];
    registTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(registrationsPending:) userInfo:nil repeats:YES];
    //绑定二维码30秒变化一次
    codeTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(codeChange:) userInfo:nil repeats:YES];
}

#pragma mark ----- createBarItem -----
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    if (_aleartView.hidden) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"返回将不再绑定正在扫描二维码的员工App" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [registTimer invalidate];
            registTimer = nil;
            [codeTimer invalidate];
            codeTimer = nil;
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
