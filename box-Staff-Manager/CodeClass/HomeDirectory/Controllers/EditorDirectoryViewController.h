//
//  EditorDirectoryViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDirectoryModel.h"

typedef void(^EditorBlock)(NSString *currency);
@interface EditorDirectoryViewController : UIViewController

@property(nonatomic, strong)HomeDirectoryModel *model;
@property (nonatomic, copy) EditorBlock currencyBlock;

@end
