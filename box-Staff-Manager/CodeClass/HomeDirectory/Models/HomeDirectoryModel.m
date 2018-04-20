//
//  HomeDirectoryModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeDirectoryModel.h"

@implementation HomeDirectoryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"currency"] isKindOfClass:[NSNull class]]){
            self.currency = [dict objectForKey:@"currency"];
        }
        if(![dict[@"nameTitle"] isKindOfClass:[NSNull class]]){
            self.nameTitle = [dict objectForKey:@"nameTitle"];
        }
        if(![dict[@"address"] isKindOfClass:[NSNull class]]){
            self.address = [dict objectForKey:@"address"];
        }
        if(![dict[@"remark"] isKindOfClass:[NSNull class]]){
            self.remark = [dict objectForKey:@"remark"];
        }
        if(![dict[@"currencyId"] isKindOfClass:[NSNull class]]){
            self.currencyId = [[dict objectForKey:@"currencyId"] integerValue];
        }
        if(![dict[@"directoryId"] isKindOfClass:[NSNull class]]){
            self.directoryId = [dict objectForKey:@"directoryId"];
        }
     }
    return self;
}

@end
