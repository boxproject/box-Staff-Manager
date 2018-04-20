//
//  SearchAddressModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchAddressModel : NSObject

@property (nonatomic,strong) NSString *currency;
@property (nonatomic,strong) NSString *address;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
