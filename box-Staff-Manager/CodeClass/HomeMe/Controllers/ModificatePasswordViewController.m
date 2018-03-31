//
//  ModificatePasswordViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ModificatePasswordViewController.h"

#define ModificatePasswordVCTitle  @"修改密码"
#define ModificatePasswordVCoriginalPawd  @"原密码"
#define ModificatePasswordVCoriginalPawdInfo  @"请输入原密码"
#define ModificatePasswordVCpawdnew  @"新密码"
#define ModificatePasswordVCpawdnewInfo  @"请输入新密码"
#define ModificatePasswordVCRenewPawd  @"新密码"
#define ModificatePasswordVCRenewPawdInfo  @"请再次输入新密码"@"修改成功"
#define ModificatePasswordVCVerify  @"确认密码"
#define ModificatePasswordVCAleartSucceed  @"修改成功"

@interface ModificatePasswordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

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
    self.title = ModificatePasswordVCTitle;
    [self createView];
    [self createBarItem];
    
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
        make.width.offset(50);
    }];
    
    _originalPawdTf = [[UITextField alloc] init];
    _originalPawdTf.font = Font(14);
    _originalPawdTf.placeholder = ModificatePasswordVCoriginalPawdInfo;
    _originalPawdTf.delegate = self;
    _originalPawdTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _originalPawdTf.keyboardType = UIKeyboardTypeAlphabet;
    _originalPawdTf.secureTextEntry = YES;
    [originalView addSubview:_originalPawdTf];
    [_originalPawdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originalLab.mas_right).offset(35);
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
        make.width.offset(50);
    }];
    
    _pawdnewTf = [[UITextField alloc] init];
    _pawdnewTf.font = Font(14);
    _pawdnewTf.placeholder = ModificatePasswordVCpawdnewInfo;
    _pawdnewTf.delegate = self;
    _pawdnewTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _pawdnewTf.keyboardType = UIKeyboardTypeAlphabet;
    _pawdnewTf.secureTextEntry = YES;
    [pawdnewView addSubview:_pawdnewTf];
    [_pawdnewTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pawdnewLab.mas_right).offset(35);
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
    renewPawdLab.text = ModificatePasswordVCpawdnew;
    renewPawdLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [renewPawdView addSubview:renewPawdLab];
    [renewPawdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(16);
        make.width.offset(50);
    }];
    
    _renewPawdTf = [[UITextField alloc] init];
    _renewPawdTf.font = Font(14);
    _renewPawdTf.placeholder = ModificatePasswordVCpawdnewInfo;
    _renewPawdTf.delegate = self;
    _renewPawdTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _renewPawdTf.keyboardType = UIKeyboardTypeAlphabet;
    _renewPawdTf.secureTextEntry = YES;
    [renewPawdView addSubview:_renewPawdTf];
    [_renewPawdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(renewPawdLab.mas_right).offset(35);
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
    [self.navigationController popViewControllerAnimated:YES];
    [WSProgressHUD showSuccessWithStatus:ModificatePasswordVCAleartSucceed];
}



#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
}


-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
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
