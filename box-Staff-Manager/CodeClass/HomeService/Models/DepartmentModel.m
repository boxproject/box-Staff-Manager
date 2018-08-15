//
//  DepartmentModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "DepartmentModel.h"

@implementation DepartmentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"Name"] isKindOfClass:[NSNull class]]){
            self.Name = [dict objectForKey:@"Name"];
        }
        if(![dict[@"Employees"] isKindOfClass:[NSNull class]]){
            self.Employees = [[dict objectForKey:@"Employees"] integerValue];
        }
        if(![dict[@"ID"] isKindOfClass:[NSNull class]]){
            self.ID = [[dict objectForKey:@"ID"] integerValue];
        }
        if(![dict[@"Index"] isKindOfClass:[NSNull class]]){
            self.Index = [[dict objectForKey:@"Index"] integerValue];
        }
    }
    return self;
}

@end
