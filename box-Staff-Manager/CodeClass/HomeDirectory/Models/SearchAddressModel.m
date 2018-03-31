//
//  SearchAddressModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchAddressModel.h"

@implementation SearchAddressModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"nameTitle"] isKindOfClass:[NSNull class]]){
            self.nameTitle = [dict objectForKey:@"nameTitle"];
        }
        if(![dict[@"subTitle"] isKindOfClass:[NSNull class]]){
            self.subTitle = [dict objectForKey:@"subTitle"];
        }
    }
    return self;
}

@end
