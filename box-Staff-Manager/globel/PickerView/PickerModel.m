//
//  PickerModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "PickerModel.h"

@implementation PickerModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"title"] isKindOfClass:[NSNull class]]){
            self.title = [dict objectForKey:@"title"];
        }
        if(![dict[@"ID"] isKindOfClass:[NSNull class]]){
            self.ID = [[dict objectForKey:@"ID"] integerValue];
        }
        if(![dict[@"content"] isKindOfClass:[NSNull class]]){
            self.content = [dict objectForKey:@"content"];
        }
    }
    return self;
}

@end
