//
//  SearchCurrencyViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
typedef void(^SearchCurrencyBlock)(NSArray *array);

@interface SearchCurrencyViewController : UIViewController

@property (nonatomic, copy) SearchCurrencyBlock searchCurrencyBlock;

@property (nonatomic, strong) NSArray *currencyArray;

@end
