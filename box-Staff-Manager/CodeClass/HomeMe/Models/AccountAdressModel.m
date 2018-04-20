//
//  AccountAdressModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AccountAdressModel.h"

@implementation AccountAdressModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"currency"] isKindOfClass:[NSNull class]]){
            self.currency = [dict objectForKey:@"currency"];
        }
        if(![dict[@"address"] isKindOfClass:[NSNull class]]){
            self.address = [dict objectForKey:@"address"];
        }
     }
    return self;
}

@end
