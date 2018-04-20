//
//  InitAccountViewController.m
//  box-Staff-Manager
//
//  Created by Rony on 2018/2/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "InitAccountViewController.h"
#import "ScanCodeViewController.h"
//#import "UIARSAHandler.h"


//text
#import "HomePageViewController.h"

#define InitAccountVCTitle  @"扫一扫"
#define PerfectInformationVCLaber  @"扫一扫完成授权"
#define PerfectInformationVCSubLaber  @"扫一扫私钥App完成账号授权"
 


@interface InitAccountViewController ()
/** 开始扫描 */
@property(nonatomic, strong)UIButton *scanButton;

@end

@implementation InitAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = InitAccountVCTitle;
    self.view.backgroundColor = kWhiteColor;
    [self createView];
    // 删除导航栏左侧按钮
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]init];
    barBtn.title=@"";
    self.navigationItem.leftBarButtonItem = barBtn;
   
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
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed: @"scanBoxIcon"];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(55 + kTopHeight);
        make.centerX.equalTo(self.view);
        make.width.offset(SCREEN_WIDTH - 71*2);
        make.height.offset((SCREEN_WIDTH - 71*2)/233.0*204.0);
    }];
    
    UILabel *laber = [[UILabel alloc] init];
    laber.text = PerfectInformationVCLaber;
    laber.textAlignment = NSTextAlignmentCenter;
    laber.font = FontBold(19);
    laber.textColor = [UIColor colorWithHexString:@"#444444"];
    [self.view addSubview:laber];
    [laber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(35);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(54/2);
    }];
    
    UILabel *subLaber = [[UILabel alloc] init];
    subLaber.text = PerfectInformationVCSubLaber;
    subLaber.textAlignment = NSTextAlignmentCenter;
    subLaber.font = Font(12);
    subLaber.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.view addSubview:subLaber];
    [subLaber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(laber.mas_bottom).offset(21/2);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(34/2);
    }];
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_scanButton setTitle:@"开始扫描" forState:UIControlStateNormal];
    [_scanButton setImage:[UIImage imageNamed:@"startScanImg"] forState:UIControlStateNormal];
    _scanButton.titleLabel.font = Font(17);
    [_scanButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanButton];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subLaber.mas_bottom).offset(188/2);
        make.centerX.equalTo(self.view);
        make.height.offset(80/2);
        make.width.offset(318/2);
    }];
 
}

#pragma mark ----- 开始扫描 -----
-(void)scanAction
{
    ScanCodeViewController *scanVC = [[ScanCodeViewController alloc]init];
    scanVC.fromFunction = fromInitAccount;
    scanVC.nameStr = _nameStr;
    scanVC.passwordStr = _passwordStr;
    scanVC.applyer_id = _applyer_id;
    [self.navigationController pushViewController:scanVC animated:YES];
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
