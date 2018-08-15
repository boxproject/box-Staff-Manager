//
//  NoCopyTextField.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/8/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "NoCopyTextField.h"

@implementation NoCopyTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)){
        NSString *string = [UIPasteboard generalPasteboard].string;
        if (![self isPositiveInteger:string]) {
            return NO;
        }
        //禁止粘贴
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)isPositiveInteger:(NSString*)string
{
    NSString *positiveInteger = @"^[1-9]\\d*|0$";
    NSPredicate *positiveTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", positiveInteger];
    return [positiveTest evaluateWithObject:string];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
