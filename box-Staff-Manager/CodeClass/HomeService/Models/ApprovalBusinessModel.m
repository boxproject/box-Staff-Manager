//
//  ApprovalBusinessModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessModel.h"

@implementation ApprovalBusinessModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"flow_id"] isKindOfClass:[NSNull class]]){
            self.flow_id = [dict objectForKey:@"flow_id"];
        }
        if(![dict[@"flow_name"] isKindOfClass:[NSNull class]]){
            self.flow_name = [dict objectForKey:@"flow_name"];
        }
        if(![dict[@"progress"] isKindOfClass:[NSNull class]]){
            self.progress = [[dict objectForKey:@"progress"] integerValue];
        }
        if(![dict[@"single_limit"] isKindOfClass:[NSNull class]]){
            self.single_limit = [dict objectForKey:@"single_limit"];
        }
        if(![dict[@"flow_limit"] isKindOfClass:[NSNull class]]){
            self.flow_limit = [dict objectForKey:@"flow_limit"];
        }
    }
    return self;
}

@end
