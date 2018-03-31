//
//  ScanCodeViewController.h
//  box-Staff-Manager
//
//  Created by Rony on 2018/3/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FromFunction) {
    fromInitAccount,
    fromHomeBox,
    fromTransfer
};

typedef void(^Block)(NSString *codeText);

@interface ScanCodeViewController : UIViewController

@property(nonatomic, assign)FromFunction fromFunction;

@property (nonatomic, copy) Block codeBlock;

@property(nonatomic, strong)NSString *nameStr;
@property(nonatomic, strong)NSString *passwordStr;
//申请者唯一识别码
@property(nonatomic, strong)NSString *applyer_id;

@end
