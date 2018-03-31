//
//  HomeDirectoryModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDirectoryModel : NSObject

@property (nonatomic,strong) NSString *currency;
@property (nonatomic,strong) NSString *nameTitle;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *remark;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
