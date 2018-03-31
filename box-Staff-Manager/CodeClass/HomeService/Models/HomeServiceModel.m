//
//  HomeServiceModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeServiceModel.h"

@implementation HomeServiceModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"titleName"] isKindOfClass:[NSNull class]]){
            self.titleName = [dict objectForKey:@"titleName"];
        }
        
        if(![dict[@"imgTitle"] isKindOfClass:[NSNull class]]){
            self.imgTitle = [dict objectForKey:@"imgTitle"];
        }
    }
    return self;
}

@end
