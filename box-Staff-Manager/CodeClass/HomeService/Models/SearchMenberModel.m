//
//  SearchMenberModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchMenberModel.h"

@implementation SearchMenberModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"account"] isKindOfClass:[NSNull class]]){
            self.account = [dict objectForKey:@"account"];
        }
        if(![dict[@"app_account_id"] isKindOfClass:[NSNull class]]){
            self.app_account_id = [dict objectForKey:@"app_account_id"];
        }
        if(![dict[@"manager_account_id"] isKindOfClass:[NSNull class]]){
            self.manager_account_id = [dict objectForKey:@"manager_account_id"];
        }
        if(![dict[@"cipher_text"] isKindOfClass:[NSNull class]]){
            self.cipher_text = [dict objectForKey:@"cipher_text"];
        }
        if(![dict[@"employee_num"] isKindOfClass:[NSNull class]]){
            self.employee_num = [[dict objectForKey:@"employee_num"] integerValue];
        }
        if(![dict[@"is_uploaded"] isKindOfClass:[NSNull class]]){
            self.is_uploaded = [[dict objectForKey:@"is_uploaded"] integerValue];
        }
    }
    return self;
}

@end
