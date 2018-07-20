//
//  DepartmemtInfoModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "DepartmemtInfoModel.h"

@implementation DepartmemtInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"AppID"] isKindOfClass:[NSNull class]]){
            self.AppID = [dict objectForKey:@"AppID"];
        }
        if(![dict[@"Account"] isKindOfClass:[NSNull class]]){
            self.Account = [dict objectForKey:@"Account"];
        }
        if(![dict[@"Depth"] isKindOfClass:[NSNull class]]){
            self.Depth = [[dict objectForKey:@"Depth"] integerValue];
        }
        if(![dict[@"Depth"] isKindOfClass:[NSNull class]]){
            self.Depth = [[dict objectForKey:@"Depth"] integerValue];
        }
        if(![dict[@"BranchID"] isKindOfClass:[NSNull class]]){
            self.BranchID = [[dict objectForKey:@"BranchID"] integerValue];
        }
    }
    return self;
}

@end
