//
//  HomeMeModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeMeModel.h"

@implementation HomeMeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"titleName"] isKindOfClass:[NSNull class]]){
            self.titleName = [dict objectForKey:@"titleName"];
        }
        if(![dict[@"subTitle"] isKindOfClass:[NSNull class]]){
            self.subTitle = [dict objectForKey:@"subTitle"];
        }
        if(![dict[@"type"] isKindOfClass:[NSNull class]]){
            self.type = [dict objectForKey:@"type"];
        }
    }
    return self;
}


@end
