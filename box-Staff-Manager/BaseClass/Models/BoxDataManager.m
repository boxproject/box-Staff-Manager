//
//  BoxDataManager.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/31.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "BoxDataManager.h"

@interface BoxDataManager()


@end

@implementation BoxDataManager

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static BoxDataManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[BoxDataManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}


@end
