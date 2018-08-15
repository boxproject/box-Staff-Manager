//
//  ProgressHUD.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ProgressHUD.h"

@implementation ProgressHUD

+(void)showProgressHUD
{
    [WSProgressHUD setProgressHUDIndicatorStyle:WSProgressHUDIndicatorBigGray];
    [WSProgressHUD show];
}
 
+(void)showErrorWithStatus:(NSString *)message code:(NSInteger)code;
{
    if (code == 1020) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"loginBox" object:nil];
    }else{
        [WSProgressHUD showErrorWithStatus:message];
    }
}
 


@end
