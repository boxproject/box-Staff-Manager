//
//  EditorDirectoryViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "EditorDirectoryViewController.h"
#import "ScanCodeViewController.h"
#import "SearchAddressViewController.h"
#import "HomeDirectoryModel.h"

#define EditorDirectoryVCTitle  @"编辑地址"
#define EditorDirectoryVCRightTitle  @"完成"
#define EditorDirectoryCurrency  @"币种"
#define EditorDirectoryName  @"名称"
#define EditorDirectoryNameInfo  @"请输入姓名或者公司名称"
#define EditorDirectoryVCAddress  @"收款地址"
#define EditorDirectoryVCAddressInfo  @"请输入或者选择收款人"
#define EditorDirectoryVCRemark  @"备注"
#define EditorDirectoryVCRemarkInfo  @"请输入备注"
#define EditorDirectoryVCcurrencyInfo  @"请选择币种"
#define EditorDirectoryVCError  @"编辑地址失败"

@interface EditorDirectoryViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong)UITextField *currencyTf;
@property (nonatomic,strong)UITextField *nameTf;
@property (nonatomic,strong)UITextField *addressTf;
@property (nonatomic,strong)UITextField *remarkTf;
@property (nonatomic,strong)UIButton *scanBtn;

@end

@implementation EditorDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = EditorDirectoryVCTitle;
    self.view.backgroundColor = kWhiteColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}];
    [self createBarItem];
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
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 60);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    //币种
    UIView *currencyView = [[UIView alloc] init];
    currencyView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:currencyView];
    [currencyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *currencyLab = [[UILabel alloc] init];
    currencyLab.textAlignment = NSTextAlignmentLeft;
    currencyLab.font = Font(14);
    currencyLab.text = EditorDirectoryCurrency;
    currencyLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [currencyView addSubview:currencyLab];
    [currencyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _currencyTf = [[UITextField alloc] init];
    _currencyTf.font = Font(14);
    _currencyTf.text = _model.currency;
    _currencyTf.delegate = self;
    _currencyTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _currencyTf.keyboardType = UIKeyboardTypeAlphabet;
    [currencyView addSubview:_currencyTf];
    [_currencyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currencyLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [UIImage imageNamed:@"right_icon"];
    [currencyView addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(currencyView);
        make.width.offset(20);
        make.height.offset(22);
        
    }];
    
    UIButton *currencyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [currencyBtn addTarget:self action:@selector(currencyAction:) forControlEvents:UIControlEventTouchUpInside];
    [currencyView addSubview:currencyBtn];
    [currencyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currencyView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    //名称
    UIView *nameView = [[UIView alloc] init];
    nameView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = Font(14);
    nameLab.text = EditorDirectoryName;
    nameLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [nameView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _nameTf = [[UITextField alloc] init];
    _nameTf.placeholder = EditorDirectoryNameInfo;
    _nameTf.font = Font(14);
    _nameTf.delegate = self;
    _nameTf.keyboardType = UIKeyboardTypeDefault;
    _nameTf.text = _model.nameTitle;
    _nameTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [nameView addSubview:_nameTf];
    [_nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineTwo= [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    //收款地址
    UIView *addressView = [[UIView alloc] init];
    addressView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textAlignment = NSTextAlignmentLeft;
    addressLab.font = Font(14);
    addressLab.text = EditorDirectoryVCAddress;
    addressLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [addressView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _addressTf = [[UITextField alloc] init];
    _addressTf.font = Font(14);
    _addressTf.delegate = self;
    _addressTf.placeholder = EditorDirectoryVCAddressInfo;
    _addressTf.text = _model.address;
    _addressTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [addressView addSubview:_addressTf];
    [_addressTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLab.mas_right).offset(15);
        make.right.offset(-45);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineThree = [[UIView alloc] init];
    lineThree.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    UIImageView *scanImg = [[UIImageView alloc] init];
    scanImg.image = [UIImage imageNamed:@"icon_scan_gray"];
    [addressView addSubview:scanImg];
    [scanImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView);
        make.right.offset(-15);
        make.width.offset(21);
        make.height.offset(21);
    }];
    
    _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressView);
        make.right.offset(-10);
        make.width.offset(31);
        make.height.offset(50);
    }];
    
    //备注
    UIView *remarkView = [[UIView alloc] init];
    remarkView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:remarkView];
    [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineThree.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(52);
    }];
    
    UILabel *remarkLab = [[UILabel alloc] init];
    remarkLab.textAlignment = NSTextAlignmentLeft;
    remarkLab.font = Font(14);
    remarkLab.text = EditorDirectoryVCRemark;
    remarkLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [remarkView addSubview:remarkLab];
    [remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.width.offset(60);
    }];
    
    _remarkTf = [[UITextField alloc] init];
    _remarkTf.placeholder = EditorDirectoryVCRemarkInfo;
    _remarkTf.font = Font(14);
    _remarkTf.delegate = self;
    _remarkTf.text = _model.remark;
    _remarkTf.keyboardType = UIKeyboardTypeDefault;
    _remarkTf.textColor = [UIColor colorWithHexString:@"#333333"];
    [remarkView addSubview:_remarkTf];
    [_remarkTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remarkLab.mas_right).offset(15);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineFour= [[UIView alloc] init];
    lineFour.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineFour];
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
}



#pragma mark -----  扫描二维码获取地址 -----
-(void)scanAction:(UIButton *)btn
{
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    scanCodeVC.fromFunction = fromTransfer;
    scanCodeVC.codeBlock = ^(NSString *codeText){
        _addressTf.text = codeText;
    };
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _currencyTf) {
        return NO;
    }
    return YES;
}

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:EditorDirectoryVCRightTitle style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

#pragma mark ----- rightBarButtonItemAction -----
- (void)rightButtonAction:(UIBarButtonItem *)buttonItem{
    if (_currencyTf.text.length == 0) {
        [WSProgressHUD showErrorWithStatus:EditorDirectoryVCcurrencyInfo];
        return;
    }
    if (_nameTf.text.length == 0) {
        [WSProgressHUD showErrorWithStatus:EditorDirectoryNameInfo];
        return;
    }
    if (_addressTf.text.length == 0) {
        [WSProgressHUD showErrorWithStatus:EditorDirectoryVCAddressInfo];
        return;
    }
    if (_remarkTf.text.length == 0) {
        [WSProgressHUD showErrorWithStatus:EditorDirectoryVCRemarkInfo];
        return;
    }
    
    NSDictionary *dic = @{@"currency":_currencyTf.text,
                          @"nameTitle": _nameTf.text,
                          @"remark": _remarkTf.text,
                          @"address":_addressTf.text,
                          @"currencyId":@(10),
                          @"directoryId":_model.directoryId};
    HomeDirectoryModel *model = [[HomeDirectoryModel alloc] initWithDict:dic];
    BOOL isOk = [[DirectoryManager sharedManager] updateDirectoryModel:model];
    if (isOk) {
        self.currencyBlock(model.currency);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [WSProgressHUD showErrorWithStatus:EditorDirectoryVCError];
    }
}

#pragma mark ----- currencyAction -----
-(void)currencyAction:(UIButton *)btn
{
    SearchAddressViewController *searchAddressVc = [[SearchAddressViewController alloc] init];
    searchAddressVc.currencyBlock = ^(NSString *text){
        _currencyTf.text = text;
    };
    [self.navigationController pushViewController:searchAddressVc animated:YES];
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
