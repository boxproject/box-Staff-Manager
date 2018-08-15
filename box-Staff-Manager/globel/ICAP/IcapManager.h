//
//  IcapManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/6.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AddressVerifyError  @"地址格式无效"

@interface IcapManager : NSObject

+ (NSArray *)ConvertICAPToAddress:(NSString *)iban;
+ (NSString *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;

@end
