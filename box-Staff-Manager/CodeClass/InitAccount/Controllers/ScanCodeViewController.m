//
//  ScanCodeViewController.m
//  box-Staff-Manager
//
//  Created by Rony on 2018/3/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PerfectInformationViewController.h"
#import "HomePageViewController.h"
#import "TransferViewController.h"
#import "PerfectInformationViewController.h"

#define ScanSize   [[UIScreen mainScreen] bounds].size.width - 70
 
@interface ScanCodeViewController () <AVCaptureMetadataOutputObjectsDelegate,CALayerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    NSTimer *timer;
    NSInteger requestCount;
}

/** 扫描二维码范围的view */
@property(nonatomic, strong) UIView *scanView;
/** 存放扫描结果的label */
@property(nonatomic, strong) UILabel *scanResult;
/** 扫描的线 */
@property (nonatomic,strong) UIImageView *scanImageView;

@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@property ( strong , nonatomic ) TBButton * torchBtn;

@property (nonatomic, copy) void (^brightBlock)(int bright);

/** 非扫描区域的蒙版 */
@property (nonatomic,strong) CALayer *maskLayer;
//服务端申请表ID
@property(nonatomic, strong)NSString *reg_id;

@property (nonatomic, strong) DDRSAWrapper *aWrapper;

@end

@implementation ScanCodeViewController
{
    BOOL _isOpen;
    AVCaptureVideoDataOutput * _videoOutput;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ScanCodeVCTitle;
    self.view.backgroundColor = kWhiteColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    self.navigationController.navigationBar.barTintColor = kBlackColor;
    self.navigationController.navigationBar.alpha = 0.5;
    
    [self leftBarItem];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createscanxView];
    //设置扫描二维码
    [self setupScanQRCode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimate) name:@"startAnimation" object:nil];
    [self initTotch];
}

#pragma mark ----- back按钮 -----
- (void)leftBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStyleDone target:self action:@selector(backButtonAction:)];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)backButtonAction:(UIBarButtonItem *)buttonItem{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加扫描线以及开启扫描线的动画
    [self startAnimate];
    //开启二维码扫描
    [_session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_session removeOutput:_videoOutput];
    [self stopScan];
}

- (void)stopScan {
    if (![_session isRunning]) {
        return;
    }
    [_session stopRunning];
}

-(void)createscanxView
{
    self.scanView = [[UIView alloc] init];
    [self.view addSubview:self.scanView];
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.width.height.offset(ScanSize);
    }];
    
    UIImageView *scanImgOne = [[UIImageView alloc] init];
    scanImgOne.image = [UIImage imageNamed:@"ScanQR1"];
    [self.scanView addSubview:scanImgOne];
    [scanImgOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.top.left.offset(0);
    }];
    
    UIImageView *scanImgTwo = [[UIImageView alloc] init];
    scanImgTwo.image = [UIImage imageNamed:@"ScanQR2"];
    [self.scanView addSubview:scanImgTwo];
    [scanImgTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.top.right.offset(0);
    }];
    
    UIImageView *scanImgThree = [[UIImageView alloc] init];
    scanImgThree.image = [UIImage imageNamed:@"ScanQR3"];
    [self.scanView addSubview:scanImgThree];
    [scanImgThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.bottom.left.offset(0);
    }];
    
    UIImageView *scanImgFourth = [[UIImageView alloc] init];
    scanImgFourth.image = [UIImage imageNamed:@"ScanQR4"];
    [self.scanView addSubview:scanImgFourth];
    [scanImgFourth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(16);
        make.bottom.right.offset(0);
    }];
    
    _torchBtn = [TBButton buttonWithType:UIButtonTypeCustom];//highlight
    [_torchBtn setImage:[UIImage imageNamed:@"QRCodeTorch"] forState:UIControlStateNormal];
    [_torchBtn setTitle:PerfectInformationVCTorchheight forState:UIControlStateNormal];
    [_torchBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _torchBtn.titleLabel.font = Font(12);
    [self.scanView addSubview:_torchBtn];
    //_torchBtn.adjustsImageWhenHighlighted = NO;
    [_torchBtn addTarget:self action:@selector(torchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_torchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scanView);
        make.bottom.equalTo(self.scanView.mas_bottom).offset(-15);
        make.height.offset(60);
        make.width.offset(100);
    }];
    _isOpen = NO;
    _torchBtn.hidden = YES;
    
    self.scanResult = [[UILabel alloc] init];
    self.scanResult.text = PerfectInformationVCScanResult;
    self.scanResult.textAlignment = NSTextAlignmentCenter;
    self.scanResult.textColor = kWhiteColor;
    self.scanResult.font = Font(13);
    [self.view addSubview:self.scanResult];
    [self.scanResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanView.mas_bottom).offset(5);
        make.width.offset(ScanSize);
        make.height.offset(22);
        make.centerX.equalTo(self.view);
    }];
}

-(void)initTotch
{
    ///添加获取图像亮度值
    __weak typeof(self) Weakself = self;
    [Weakself addCaptureImage:^(int bright) {
        if (bright > 50) {
            if (_device.isTorchActive) {
                return;
            }
            Weakself.torchBtn.hidden = YES;
        } else {
            Weakself.torchBtn.hidden = NO;
        }
    }];
}

/************************ 添加图像捕捉输出 *********************/
- (void)addCaptureImage:(void(^)(int bright))brightBlock {
    if ([_device hasTorch]) {
        __weak typeof(self) Weakself = self;
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        dispatch_queue_t queue = dispatch_queue_create("brightCapture.scanner.queue.com", NULL);
        [_videoOutput setSampleBufferDelegate:Weakself queue:queue];
        _videoOutput.videoSettings =
        [NSDictionary dictionaryWithObject:
         [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                    forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        if (![_session canAddOutput:_videoOutput]) {
            return;
        }
        [_session addOutput:_videoOutput];
        self.brightBlock = brightBlock;
    }
}


- (int)getBrightWith:(CMSampleBufferRef)sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    unsigned char * baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    //    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    int num = 1;
    double bright = 0;
    int r;
    int g;
    int b;
    for (int i = 0; i < 4 * width * height; i++) {
        if (i%4 == 0) {
            num++;
            r = baseAddress[i+1];
            g = baseAddress[i+2];
            b = baseAddress[i+3];
            bright = bright + 0.299 * r + 0.587 * g + 0.114 * b;
        }
    }
    
    bright = (int) (bright / num);
    return bright;
    
}


#pragma mark --- AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    int bright = [self getBrightWith:sampleBuffer];
    //    NSLog(@"%d",bright);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.brightBlock(bright);
    });
}


//手电筒按钮
- (void)torchBtnClick {
    _isOpen = !_isOpen;
    if (_isOpen) {
        [_torchBtn setImage:[UIImage imageNamed:@"icon_light_blue"] forState:UIControlStateNormal];
        [_torchBtn setTitle:PerfectInformationVCTorchlight forState:UIControlStateNormal];
        [_torchBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _torchBtn.titleLabel.font = Font(12);
        [self setTorch:YES];
    }
    else {
        [_torchBtn setImage:[UIImage imageNamed:@"QRCodeTorch"] forState:UIControlStateNormal];
        [_torchBtn setTitle:PerfectInformationVCTorchheight forState:UIControlStateNormal];
        [_torchBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _torchBtn.titleLabel.font = Font(12);
        [self setTorch:NO];
    }
}

- (void)setTorch:(BOOL)isOpen {
    [_device lockForConfiguration:nil];
    if (isOpen) {
        [_device setTorchMode:AVCaptureTorchModeOn];
    }
    else {
        [_device setTorchMode:AVCaptureTorchModeOff];
    }
    [_device unlockForConfiguration];
}

- (BOOL)isTorchOpen {
    return _device.isTorchActive;
}


- (void)dealloc{
    // 删除预览图层
    if (_preview) {
        [_preview removeFromSuperlayer];
    }
    if (self.maskLayer) {
        self.maskLayer.delegate = nil;
    }
}
#pragma mark - <lazy - 懒加载>
/**
 *  懒加载设备
 */
- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

/**
 *  懒加输入源
 */
- (AVCaptureDeviceInput *)input {
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

/**
 *  懒加载输出源
 */
- (AVCaptureMetadataOutput *)output {
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
    }
    return _output;
}

/**
 *  添加扫描线以及开启扫描线的动画
 */
- (void)startAnimate {
    [_scanImageView removeFromSuperview];
    CGFloat scanImageViewX = 0;
    CGFloat scanImageViewY = 0;
    CGFloat scanImageViewW = ScanSize;
    CGFloat scanImageViewH = 7;
    
    _scanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLine"]];
    _scanImageView.frame = CGRectMake(scanImageViewX, scanImageViewY, scanImageViewW, scanImageViewH);
    [self.scanView addSubview:_scanImageView];
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        _scanImageView.frame = CGRectMake(scanImageViewX, scanImageViewY + ScanSize - 7, scanImageViewW, scanImageViewH);
    } completion:nil];
}

/**
 *  设置扫描二维码
 */
- (void)setupScanQRCode {
    // 1、创建设备会话对象，用来设置设备数据输入
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset: AVCaptureSessionPresetHigh];    //高质量采集
    
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    // 设置条码类型为二维码
    [self.output setMetadataObjectTypes:self.output.availableMetadataObjectTypes];
    
    // 设置扫描范围
    [self setOutputInterest];
    
    // 3、实时获取摄像头原始数据显示在屏幕上
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    self.view.layer.backgroundColor = [[UIColor blackColor] CGColor];
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    self.maskLayer = [[CALayer alloc]init];
    self.maskLayer.frame = self.view.layer.bounds;
    self.maskLayer.delegate = self;
    [self.view.layer insertSublayer:self.maskLayer above:_preview];
    [self.maskLayer setNeedsDisplay];
}

/**
 *  设置二维码的扫描范围
 */
- (void)setOutputInterest {
    CGSize size = self.view.bounds.size;
    CGFloat scanViewWidth = ScanSize;
    CGFloat scanViewHeight = ScanSize;
    CGFloat scanViewX = (size.width - scanViewWidth) / 2;
    CGFloat scanViewY = (size.height - scanViewHeight) / 2;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((scanViewY + fixPadding) / fixHeight,
                                            scanViewX / size.width,
                                            scanViewHeight / fixHeight,
                                            scanViewWidth / size.width);
    } else {
        CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(scanViewY / size.height,
                                            (scanViewX + fixPadding) / fixWidth,
                                            scanViewHeight / size.height,
                                            scanViewWidth / fixWidth);
    }
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate - 扫描二维码的回调方法>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //判断扫描是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *result;
        //判断的扫描的结果是否是二维码
        if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // 显示遮盖
            [SVProgressHUD showWithStatus:Handing];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            // 当扫描到数据时，停止扫描
            [ _session stopRunning];
            // 将扫描的线从父控件中移除
            [_scanImageView removeFromSuperview];
            result = metadataObject.stringValue;
            // 当前延迟1.0秒
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 将扫描后的结果显示在label上
                //self.scanResult.text = result;
                if (_fromFunction == fromInitAccount) {
                    NSArray *codeArray = [JsonObject dictionaryWithJsonStringArr:result];
                    if (codeArray == nil) {
                        [WSProgressHUD showErrorWithStatus:PerfectInformationVCErrorCode];
                        [self.navigationController popViewControllerAnimated:YES];
                        [SVProgressHUD dismiss];
                        return ;
                    }
                    [self handleFromInitAccount:result];
                }else if (_fromFunction == fromTransfer){
                    [SVProgressHUD dismiss];
                    [self handleAddressfromResult:result];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if (_fromFunction == fromHomeBox){
                    [self handleResultFromHomeBox:result];
                }
            });
            
        }else{
            NSLog(@"不是二维码");
        }
    }
}

#pragma mark ------ 适配钱包地址 -----
-(void)handleAddressfromResult:(NSString *)result
{
    if ([result hasPrefix:@"iban:"]) {
        NSArray *icapArr = [IcapManager ConvertICAPToAddress:result];
        self.codeArrBlock(icapArr);
    }else if([result hasPrefix:@"ethereum:"]){
        NSRange range = [result rangeOfString:@"ethereum:"];
        NSString *content = [result substringFromIndex:(range.location + range.length)];
        self.codeBlock(content);
    }else if([result hasPrefix:@"bitcoin:"]){
        NSRange range = [result rangeOfString:@"?label="];
        NSString *content = @"";
        if (range.location != NSNotFound) {
            NSString *contentRegex = @"(?<=\\:).*?(?=\\?)";
            content = [IcapManager matchString:result toRegexString:contentRegex];
            self.codeBlock(content);
        }else{
            NSRange range = [result rangeOfString:@"bitcoin:"];
            NSString *content = [result substringFromIndex:(range.location + range.length)];
            self.codeBlock(content);
        }
    }
    else{
        self.codeBlock(result);
    }
}

-(void)handleResultFromHomeBox:(NSString *)result
{
    [SVProgressHUD dismiss];
    TransferViewController *transferVC = [[TransferViewController alloc] init];
    transferVC.mode = _model;
    if ([result hasPrefix:@"iban:"]) {
        NSArray *icapArr = [IcapManager ConvertICAPToAddress:result];
        transferVC.address = icapArr[0];
        transferVC.amount = icapArr[1];
    }else if([result hasPrefix:@"ethereum:"]){
        NSRange range = [result rangeOfString:@"ethereum:"];
        NSString *content = [result substringFromIndex:(range.location + range.length)];
        transferVC.address = content;
    }else if([result hasPrefix:@"bitcoin:"]){
        NSRange range = [result rangeOfString:@"?label="];
        NSString *content = @"";
        if (range.location != NSNotFound) {
            NSString *contentRegex = @"(?<=\\:).*?(?=\\?)";
            content = [IcapManager matchString:result toRegexString:contentRegex];
            transferVC.address = result;
        }else{
            NSRange range = [result rangeOfString:@"bitcoin:"];
            NSString *content = [result substringFromIndex:(range.location + range.length)];
            transferVC.address = content;
        }
    }
    else{
        transferVC.address = result;
    }
    transferVC.fromType = @"scanCode";
    BoxNavigationController *transferNC = [[BoxNavigationController alloc] initWithRootViewController:transferVC];
    [self presentViewController:transferNC animated:YES completion:nil];
}

#pragma mark ------ 员工APP递交加密后的注册申请 -----
-(void)handleFromInitAccount:(NSString *)codeStr
{
    //生成固定随机值
    NSString *applyer_random = [JsonObject getRandomStringWithNum:8];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"app_account_random" codeValue:applyer_random];
    NSArray *codeArray = [JsonObject dictionaryWithJsonStringArr:codeStr];
    NSString *box_IP = codeArray[0];
    NSString *boxIpStr = [NSString stringWithFormat:@"http://%@", box_IP];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"box_IP" codeValue:boxIpStr];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"box_IpPort" codeValue:box_IP];
    NSString *randomStr = codeArray[1];
    NSString *timeCode = codeArray[2];
    [_aWrapper generateSecKeyPairWithKey];
    NSString *publicKeyBase64 = [BoxDataManager sharedManager].publicKeyBase64;
    NSArray *aesArray = [NSArray arrayWithObjects:applyer_random, publicKeyBase64, nil];
    NSString *aesSting = [JsonObject dictionaryToarrJson:aesArray];
    NSString *aesStr = [FSAES128 AES128EncryptStrig:aesSting keyStr:randomStr];
    //applyer_id 申请者唯一识别码
    //captain_id 直属上级唯一识别码
    //存储账户名、直属上级唯一识别码、申请者唯一识别码
    [[BoxDataManager sharedManager] saveDataWithCoding:@"applyer_account" codeValue:_nameStr];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"captain_id" codeValue:timeCode];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"applyer_id" codeValue:_applyer_id];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"passWord" codeValue:_passwordStr];
    NSString *encryptKey = [JsonObject getRandomStringWithNum:8];
    NSString *hmacSHA256 = [UIARSAHandler hmac: _passwordStr withKey:encryptKey];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"encryptKey" codeValue:encryptKey];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:aesStr forKey:@"msg"];
    [paramsDic setObject:_applyer_id forKey:@"applyer_id"];
    [paramsDic setObject:timeCode forKey:@"captain_id"];
    [paramsDic setObject:_nameStr forKey:@"applyer_account"];
    [paramsDic setObject:hmacSHA256 forKey:@"password"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/registrations" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            _reg_id = dict[@"data"][@"reg_id"];
            [[BoxDataManager sharedManager] saveDataWithCoding:@"reg_id" codeValue:_reg_id];
            [self getApprovalResult];
        }else {
            // 隐藏遮盖
            [SVProgressHUD dismiss];
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
            [self handleshowProgressHUD];
        }
    } fail:^(NSError *error) {
        // 隐藏遮盖
        [SVProgressHUD dismiss];
        NSLog(@"%@", error.description);
        [self handleError];
    }];
}

-(void)handleError
{
    [SVProgressHUD dismiss];
    [WSProgressHUD showErrorWithStatus:RequestError];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[PerfectInformationViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)handleshowProgressHUD
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[PerfectInformationViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark ------ 员工APP轮询注册审批结果 -----
-(void)getApprovalResult
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_reg_id forKey:@"reg_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/registrations/approval/result" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSString *consent = dict[@"data"][@"consent"];//0暂无结果 1拒绝 2同意
            NSString *token = dict[@"token"];
            if ([consent integerValue] == 0) {
                timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(getApprovalResult:) userInfo:nil repeats:YES];
            }else if([consent integerValue] == 1){
                [SVProgressHUD dismiss];
                [WSProgressHUD showErrorWithStatus:EmpowermentFailed];
                [self handleshowProgressHUD];
            }else if([consent integerValue] == 2){
                [SVProgressHUD dismiss];
                NSInteger depth = [dict[@"data"][@"depth"] integerValue];
                if (depth == 0) {
                    if(![dict[@"data"][@"cipher_text"] isKindOfClass:[NSNull class]]){
                        NSString *cipher_text = dict[@"data"][@"cipher_text"];
                        NSString *hmacCipher = [UIARSAHandler hmac:[BoxDataManager sharedManager].publicKeyBase64 withKey:[BoxDataManager sharedManager].app_account_random];
                        if (![cipher_text isEqualToString:hmacCipher]) {
                            [self getApprovalResultcancel];
                            return ;
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WSProgressHUD showSuccessWithStatus:EmpowermentSuccess];
                    [[BoxDataManager sharedManager] saveDataWithCoding:@"token" codeValue:token];
                    [[BoxDataManager sharedManager] saveDataWithCoding:@"launchState" codeValue:@"1"];
                    [[BoxDataManager sharedManager] saveDataWithCoding:@"depth" codeValue:[NSString stringWithFormat:@"%ld", depth]];
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate launchJumpVC];
                });
            }
        }else {
            // 隐藏遮盖
            [SVProgressHUD dismiss];
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
            [self handleshowProgressHUD];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self handleError];
    }];
}

#pragma mark ------ 员工反馈上级审核注册结果有误 -----
-(void)getApprovalResultcancel
{
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:_reg_id privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:_reg_id signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_reg_id forKey:@"reg_id"];
    [paramsDic setObject:_applyer_id forKey:@"applyer_id"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/registrations/approval/cancel" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            [WSProgressHUD showErrorWithStatus:ScanCodeWSprogress];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            // 隐藏遮盖
            [SVProgressHUD dismiss];
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
            [self handleshowProgressHUD];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self handleError];
    }];
}

-(void)getApprovalError
{
    [SVProgressHUD dismiss];
    [timer invalidate];
    timer = nil;
    [WSProgressHUD showErrorWithStatus:EmpowermentFailed];
    [self handleshowProgressHUD];
}

-(void)getApprovalResult:(NSTimer *)Ttimer
{
    requestCount += 2;
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_reg_id forKey:@"reg_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/registrations/approval/result" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSString *consent = dict[@"data"][@"consent"];//0暂无结果 1拒绝 2同意
            NSString *token = dict[@"token"];
            if ([consent integerValue] == 0) {
                if (requestCount >= 12) {
                    [self getApprovalError];
                }
            }else if([consent integerValue] == 1){
                [self getApprovalError];
            }else if([consent integerValue] == 2){
                [SVProgressHUD dismiss];
                [timer invalidate];
                timer = nil;
                NSInteger depth = [dict[@"data"][@"depth"] integerValue];
                if (depth == 0) {
                    if(![dict[@"data"][@"cipher_text"] isKindOfClass:[NSNull class]]){
                        NSString *cipher_text = dict[@"data"][@"cipher_text"];
                        NSString *hmacCipher = [UIARSAHandler hmac:[BoxDataManager sharedManager].publicKeyBase64 withKey:[BoxDataManager sharedManager].app_account_random];
                        if (![cipher_text isEqualToString:hmacCipher]) {
                            [self getApprovalResultcancel];
                            return ;
                        }
                    }
                }
                [WSProgressHUD showSuccessWithStatus:EmpowermentSuccess];
                [[BoxDataManager sharedManager] saveDataWithCoding:@"depth" codeValue:[NSString stringWithFormat:@"%ld", depth]];
                [[BoxDataManager sharedManager] saveDataWithCoding:@"token" codeValue:token];
                [[BoxDataManager sharedManager] saveDataWithCoding:@"launchState" codeValue:@"1"];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate launchJumpVC];
            }
        }else {
            // 隐藏遮盖
            [SVProgressHUD dismiss];
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
            [self handleshowProgressHUD];
        }
    } fail:^(NSError *error) {
        [timer invalidate];
        timer = nil;
        NSLog(@"%@", error.description);
        [self handleError];
    }];
}

#pragma mark - <CALayerDelegate - 图层的代理方法>
/**
 *   蒙板生成,需设置代理，并在退出页面时取消代理
 */
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    if (layer == self.maskLayer) {
        UIGraphicsBeginImageContextWithOptions(self.maskLayer.frame.size, NO, 1.0);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor);
        CGContextFillRect(ctx, self.maskLayer.frame);
        CGRect scanFrame = [self.view convertRect:self.scanView.frame fromView:self.scanView.superview];
        CGContextClearRect(ctx, scanFrame);
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
