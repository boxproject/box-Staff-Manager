//
//  IcapManager.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/6.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "IcapManager.h"
#import "JKBigInteger.h"
#import "keccak.h"

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
    NSString *checksum = [self checksumWithKeccak256:[bigAddr stringValueWithRadix:16]];
    NSLog(@"checksum: %@", checksum);
    return checksum;
}

+ (NSString *)checksumWithKeccak256:(NSString *)value
{
    int bytes = (int)(256 / 8);
    const char *string = [value UTF8String];
    int size = (int) strlen(string);
    uint8_t md[bytes];
    keccak((uint8_t*)string, size, md, bytes);
    NSMutableString *address = [[NSMutableString alloc] initWithCapacity:size + 4];
    [address appendFormat:@"%@", @"0x"];
    uint32_t len = (uint32_t)size;
    for(uint32_t i=0; i<len; i++) {
        uint8_t hashByte = md[i/2];
        if (i%2 == 0) {
            hashByte = hashByte >> 4;
        } else {
            hashByte &= 0xf;
        }
        if (string[i] > '9' && hashByte > 7) {
            [address appendFormat:@"%c", string[i] - 32];
        } else {
            [address appendFormat:@"%c", string[i]];
        }
    }
    return address;
}

//截取iban-转账的地址、account-转账的数额、type-转账的类型
+ (NSArray *)arrayWithMatchString:(NSString *)string
{
    NSString *contentRegex = @"(?<=\\:).*?(?=\\?)";
    NSString *content = [self matchString:string toRegexString:contentRegex];
    NSRange accountRange = [string rangeOfString:@"amount"];
    NSString *account = @"0";
    if (accountRange.location != NSNotFound) {
        NSString *accountRegex = @"(?<=\\=).*?(?=\\&)";
        account = [self matchString:string toRegexString:accountRegex];
    }
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
