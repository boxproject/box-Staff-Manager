//
//  AddressVerifyManager.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/5/21.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AddressVerifyManager.h"

@implementation AddressVerifyManager

+(BOOL)checkAddressVerify:(NSString *)address type:(NSString *)type
{
    if ([type isEqualToString:@"ETH"]) {
        if ([address hasPrefix:@"0x"] && address.length == 42) {
            return YES ;
        }else{
           return NO ;
        }
    }
    return YES;
}

+(NSString *)handleAddress:(NSString *)address
{
    NSString *str1 = [address substringToIndex:12];
    NSString *str2 = [address substringFromIndex:address.length - 12];
    NSString *str3 = [NSString stringWithFormat:@"%@...%@", str1, str2];
    return str3;
}

@end
