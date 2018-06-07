//
//  TransferViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

@interface TransferViewController : UIViewController

@property(nonatomic, strong)NSString *titlename;
@property(nonatomic, strong)CurrencyModel *mode;
@property(nonatomic, strong)NSString *fromType;
@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSString *amount;

@end
