//
//  HomeServiceModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeServiceModel : NSObject

@property (nonatomic,strong) NSString *titleName;

@property (nonatomic,strong) NSString *imgTitle;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
