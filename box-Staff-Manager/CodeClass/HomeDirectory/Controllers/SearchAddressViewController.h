//
//  SearchAddressViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(NSString *text);

@interface SearchAddressViewController : UIViewController

@property (nonatomic, copy) Block currencyBlock;

@end
