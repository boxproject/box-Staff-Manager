//
//  CurrencyModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyModel : NSObject

/** 币种名称 */
@property (nonatomic,strong) NSString *currency;
/** 币种地址 */
@property (nonatomic,strong) NSString *address;

- (instancetype)initWithDict:(NSDictionary *)dict;


@end
