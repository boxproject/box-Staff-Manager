//
//  DepartmentModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepartmentModel : NSObject

/** 部门名称 */
@property (nonatomic,strong) NSString *Name;
/** 部门人数 */
@property (nonatomic,assign) NSInteger Employees;
/** ID */
@property (nonatomic,assign) NSInteger ID;
/** 部门列表索引 */
@property (nonatomic,assign) NSInteger Index;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
