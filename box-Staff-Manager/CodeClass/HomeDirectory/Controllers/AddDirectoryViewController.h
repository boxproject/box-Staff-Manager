//
//  AddDirectoryViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddBlock)(NSString *currency);
@interface AddDirectoryViewController : UIViewController

@property(nonatomic,strong)NSString *currency;
@property (nonatomic, copy) AddBlock currencyBlock;

@end
