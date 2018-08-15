//
//  HomeMeModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeMeModel : NSObject

@property (nonatomic,strong) NSString *titleName;

@property (nonatomic,strong) NSString *subTitle;

@property (nonatomic,strong) NSString *type;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
