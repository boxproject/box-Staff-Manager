//
//  TransferAwaitDetailViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferAwaitDetailViewController.h"
#import "TransferTopView.h"

#define TransferAwaitVCAgreeApprovalBtn  @"同意审批"
#define TransferAwaitVCRefuseApprovalBtn  @"拒绝审批"

@interface TransferAwaitDetailViewController ()

@property(nonatomic, strong)TransferTopView *transferTopView;
@property(nonatomic, strong)UIButton *agreeApprovalBtn;
@property(nonatomic, strong)UIButton *refuseApprovalBtn;

@end

@implementation TransferAwaitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = @"用于二秒科技投资";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    [self createBarItem];
    
    _transferTopView = [[TransferTopView alloc] initWithFrame: CGRectMake(11, 8, SCREEN_WIDTH - 22, 338) dic:nil];
    [self.view addSubview:_transferTopView];
    
    [self createTransferBtn];
    
}

-(void)createTransferBtn
{
    _agreeApprovalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeApprovalBtn setTitle:TransferAwaitVCAgreeApprovalBtn forState:UIControlStateNormal];
    [_agreeApprovalBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _agreeApprovalBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _agreeApprovalBtn.titleLabel.font = Font(15);
    [_agreeApprovalBtn addTarget:self action:@selector(agreeApprovalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreeApprovalBtn];
    [_agreeApprovalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH/2);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];
    
    _refuseApprovalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refuseApprovalBtn setTitle:TransferAwaitVCRefuseApprovalBtn forState:UIControlStateNormal];
    [_refuseApprovalBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _refuseApprovalBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _refuseApprovalBtn.titleLabel.font = Font(15);
    [_refuseApprovalBtn addTarget:self action:@selector(refuseApprovalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refuseApprovalBtn];
    [_refuseApprovalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreeApprovalBtn.mas_right).offset(0);
        make.width.offset(SCREEN_WIDTH/2);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];
    
    
    
    
}

#pragma mark -----  同意审批 -----
-(void)agreeApprovalAction:(UIButton *)btn
{
    
}

#pragma mark -----  拒绝审批 -----
-(void)refuseApprovalAction:(UIButton *)btn
{
    
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

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
