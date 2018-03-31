//
//  AssetAmountModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AssetAmountModel.h"

@implementation AssetAmountModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"titleName"] isKindOfClass:[NSNull class]]){
            self.titleName = [dict objectForKey:@"titleName"];
        }
        if(![dict[@"amountTitle"] isKindOfClass:[NSNull class]]){
            self.amountTitle = [dict objectForKey:@"amountTitle"];
        }
        if(![dict[@"freezeAmount"] isKindOfClass:[NSNull class]]){
            self.freezeAmount = [dict objectForKey:@"freezeAmount"];
        }
    }
    return self;
}

@end
