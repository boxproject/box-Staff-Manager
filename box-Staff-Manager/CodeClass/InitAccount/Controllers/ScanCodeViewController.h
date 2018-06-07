//
//  ScanCodeViewController.h
//  box-Staff-Manager
//
//  Created by Rony on 2018/3/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

typedef NS_ENUM(NSInteger, FromFunction) {
    fromInitAccount,
    fromHomeBox,
    fromTransfer
};

typedef void(^Block)(NSString *codeText);
typedef void(^BlockArr)(NSArray *codeArray);

@interface ScanCodeViewController : UIViewController

@property(nonatomic, assign)FromFunction fromFunction;

@property (nonatomic, copy) Block codeBlock;

@property (nonatomic, copy) BlockArr codeArrBlock;

@property(nonatomic, strong)NSString *nameStr;

@property(nonatomic, strong)NSString *passwordStr;
//申请者唯一识别码
@property(nonatomic, strong)NSString *applyer_id;

@property(nonatomic, strong)CurrencyModel *model;

@property(nonatomic, strong)NSString *currency;

@end
