//
//  LoginBoxViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FromVC) {
    FromAppDelegate,
    FromHomeBox
};

@interface LoginBoxViewController : UIViewController

@property(nonatomic, assign)FromVC fromFunction;

@end
