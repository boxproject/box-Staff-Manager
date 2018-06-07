//
//  IcapManager.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/6.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "IcapManager.h"
#import "JKBigInteger.h"

static const NSString *Base36Chars = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

@implementation IcapManager

+ (NSArray *)ConvertICAPToAddress:(NSString *)iban
{
    NSArray *ibanArray = [self arrayWithMatchString:iban];
    NSString *address = [self addressConvertFrom:ibanArray[0]];
    NSArray *array = [NSArray arrayWithObjects:address, ibanArray[1], ibanArray[2], nil];
    return array;
}

+ (NSString *)addressConvertFrom:(NSString *)icapString
{
    return [self parse:icapString];
}

+ (NSString *)parse:(NSString *)icapString
{
    // checksum is ISO13616, Ethereum address is base-36
    JKBigInteger *bigAddr = [[JKBigInteger alloc] initWithString:[icapString substringFromIndex:4] andRadix:36];
    NSLog(@"%@", bigAddr);
    unsigned int size = [bigAddr countBytes];
    unsigned char bytes[size];
    [bigAddr toByteArrayUnsigned:bytes];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(size * 2) + 4];
    [hexString appendFormat:@"%@", @"0x"];
    for (int i = 0; i < size; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)bytes[i]];
    }
    NSString *hex = [NSString stringWithString:hexString];
    NSLog(@"hex: %@", hex);
    
    return [NSString stringWithString:hexString];
}

//截取iban-转账的地址、account-转账的数额、type-转账的类型
+ (NSArray *)arrayWithMatchString:(NSString *)string
{
    NSString *contentRegex = @"(?<=\\:).*?(?=\\?)";
    NSString *content = [self matchString:string toRegexString:contentRegex];
    NSString *accountRegex = @"(?<=\\=).*?(?=\\&)";
    NSString *account = [self matchString:string toRegexString:accountRegex];
    NSRange range = [string rangeOfString:@"token="];
    NSString *type = [string substringFromIndex:(range.location + range.length)];
    NSArray *array = [NSArray arrayWithObjects:content, account, type, nil];
    return array;
}

//根据正则截取所需字符
+ (NSString *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSString *component = [string substringWithRange:[matches[0] rangeAtIndex:0]];
    return component;
}


@end
