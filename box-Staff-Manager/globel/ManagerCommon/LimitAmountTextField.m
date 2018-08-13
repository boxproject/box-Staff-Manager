//
//  LimitAmountTextField.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/8/5.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "LimitAmountTextField.h"

@implementation LimitAmountTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)){
        NSString *string = [UIPasteboard generalPasteboard].string;
        if (![self isPositiveInteger:string]) {
            return NO;
        }else{
            if ([string rangeOfString:@"."].location == NSNotFound) {
                if (string.length > 11) {
                    return NO;
                }
                return YES;
            }else{
                NSRange range = [string rangeOfString:@"."];
                NSString *tt = [string substringFromIndex:(range.location + range.length)];
                if (tt.length > 2) {
                    return NO;
                }
                return YES;
            }
        }
        //禁止粘贴
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)isPositiveInteger:(NSString*)string
{
    NSString *positiveInteger = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*|0?\\.0+|0$";
    NSPredicate *positiveTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", positiveInteger];
    
    NSString *positiveIn = @"^[1-9]\\d*|0$";
    NSPredicate *positiveText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", positiveIn];
    if ([positiveTest evaluateWithObject:string] || [positiveText evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
