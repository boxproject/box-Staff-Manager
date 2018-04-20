//
//  HomeDirectoryViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

typedef void(^Block)(NSString *address);
@interface HomeDirectoryViewController : UIViewController

@property(nonatomic, strong)NSString *type;
@property (nonatomic, copy) Block addressBlock;
@property(nonatomic, strong)CurrencyModel *model;

@end
