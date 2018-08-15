//
//  ViewLogModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ViewLogModel.h"

@implementation ViewLogModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
 
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"Operator"] isKindOfClass:[NSNull class]]){
            self.Operator = [dict objectForKey:@"Operator"];
        }
        if(![dict[@"Progress"] isKindOfClass:[NSNull class]]){
            self.Progress = [[dict objectForKey:@"Progress"] integerValue];
        }
        if(![dict[@"Reason"] isKindOfClass:[NSNull class]]){
            self.ReasonStr = [dict objectForKey:@"Reason"];
        }
        if(![dict[@"OpTime"] isKindOfClass:[NSNull class]]){
            self.OpTime = [[dict objectForKey:@"OpTime"] integerValue];
        }
        if(![dict[@"FinalProgress"] isKindOfClass:[NSNull class]]){
            self.FinalProgress = [[dict objectForKey:@"FinalProgress"] integerValue];
        }
    }
    return self;
}

@end
