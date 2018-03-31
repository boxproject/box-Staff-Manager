//
//  tansferCodeViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "tansferCodeViewController.h"

#define tansferCodeVCTitle  @"收款码"
#define tansferCodeVCScanLab  @"收款二维码"
#define tansferCodeVCSaveAddressBtnb  @"复制收款地址"
#define tansferCodeVCSaveAddressSucced  @"复制成功"

@interface tansferCodeViewController ()<UIScrollViewDelegate, MBProgressHUDDelegate>

@property (nonatomic,strong) UIView *viewLayer;

@property (nonatomic,strong)UILabel *topTitleLab;

@property(nonatomic, strong)MBProgressHUD *progressHUD;

@property(nonatomic, strong)UIScrollView *contentView;

@property(nonatomic, strong)UIImageView *accountQRCodeImg;

@property(nonatomic, strong)UILabel *detailLab;
/** 复制收款地址 */
@property(nonatomic, strong)UIButton  *saveAddressBtn;

@end

@implementation tansferCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
     [self createTitleView];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    [self createBarItem];
    [self createView];
    [self initProgressHUD];
    
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
        make.height.offset(405);
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
    scanLab.text = tansferCodeVCScanLab;
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
    _detailLab.text = @"0xb2ed7ceaebd98686cb9310a32d93e91044a580a6";
    _detailLab.textAlignment = NSTextAlignmentCenter;
    _detailLab.font = Font(11);
    _detailLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [oneView addSubview:_detailLab];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(18);
        make.height.offset(16);
    }];
    
    _saveAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveAddressBtn setTitle:tansferCodeVCSaveAddressBtnb forState:UIControlStateNormal];
    [_saveAddressBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _saveAddressBtn.backgroundColor = [UIColor colorWithHexString:@"#eff0f2"];
    _saveAddressBtn.layer.cornerRadius = 2.0f;
    _saveAddressBtn.layer.masksToBounds = YES;
    _saveAddressBtn.titleLabel.font = Font(14);
    [_saveAddressBtn addTarget:self action:@selector(saveAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:_saveAddressBtn];
    [_saveAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailLab.mas_bottom).offset(23);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(43);
    }];
    
}

#pragma mark ----- saveAddressAction -----
-(void)saveAddressAction:(UIButton *)btn
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _detailLab.text;
    [self showProgressHUD];
}

-(void)showProgressHUD
{
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.label.textColor = kWhiteColor;
    self.progressHUD.bezelView.backgroundColor=[UIColor blackColor];
    //self.progressHUD.dimBackground = YES; //设置有遮罩
    self.progressHUD.label.text = tansferCodeVCSaveAddressSucced; //设置进度框中的提示文字
    [self.progressHUD showAnimated:YES];
    
    [self.progressHUD hideAnimated:YES afterDelay:0.5];
}




-(void)initProgressHUD
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.delegate = self;
    //添加ProgressHUD到界面中
    [self.view addSubview:self.progressHUD];
}




#pragma mark ----- createBarItem -----
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
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


-(void)createTitleView
{
    _viewLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _viewLayer.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = self.viewLayer;
    
    _topTitleLab = [[UILabel alloc] init];
    _topTitleLab.textAlignment = NSTextAlignmentCenter;
    _topTitleLab.font = Font(16);
    _topTitleLab.attributedText = [self attributedStringWithImage:@"BTC"];
    _topTitleLab.textColor = kWhiteColor;
    _topTitleLab.numberOfLines = 1;
    [_viewLayer addSubview:_topTitleLab];
    [_topTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_viewLayer);
        make.centerX.equalTo(_viewLayer);
        make.height.offset(30);
        make.width.offset(100);
    }];
    UITapGestureRecognizer *topTitleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topTitleTapAction:)];
    _viewLayer.userInteractionEnabled = YES;
    [_viewLayer addGestureRecognizer:topTitleTap];
    
}

-(NSMutableAttributedString *)attributedStringWithImage:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"%@%@", string, tansferCodeVCTitle];
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", str]];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, str.length + 1)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"icon_pulldown_white"];
    attch.bounds = CGRectMake(7, 0.5, 12, 9);
    //创建带有图片的富文本
    NSAttributedString *stringAt = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    //[attri appendAttributedString:string];
    //将图片放在第一位
    [attri insertAttributedString:stringAt atIndex:str.length];
    return attri;
    
}


#pragma mark ----- topTitleTapAction -----
-(void)topTitleTapAction:(UITapGestureRecognizer *)tap
{
    
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
