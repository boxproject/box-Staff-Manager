//
//  TransferRecordModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferRecordModel.h"

@implementation TransferRecordModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"topLeft"] isKindOfClass:[NSNull class]]){
            self.topLeft = [dict objectForKey:@"topLeft"];
        }
        if(![dict[@"timeIn"] isKindOfClass:[NSNull class]]){
            self.timeIn = [[dict objectForKey:@"timeIn"] integerValue];
        }
        if(![dict[@"topRight"] isKindOfClass:[NSNull class]]){
            self.topRight = [dict objectForKey:@"topRight"];
        }
        if(![dict[@"topLeft"] isKindOfClass:[NSNull class]]){
            self.topLeft = [dict objectForKey:@"topLeft"];
        }
        if(![dict[@"tansferStateState"] isKindOfClass:[NSNull class]]){
            self.tansferStateState = [[dict objectForKey:@"tansferStateState"] integerValue];
        }
    }
    return self;
}

@end
