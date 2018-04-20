//
//  HomeDirectoryModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDirectoryModel : NSObject
/** 币种 */
@property (nonatomic,strong) NSString *currency;
/** 币种Id */
@property (nonatomic,assign) NSInteger currencyId;
/** 名称 */
@property (nonatomic,strong) NSString *nameTitle;
/** 地址 */
@property (nonatomic,strong) NSString *address;
/** 标记 */
@property (nonatomic,strong) NSString *remark;
/** 地址Id */
@property (nonatomic,strong) NSString *directoryId;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
