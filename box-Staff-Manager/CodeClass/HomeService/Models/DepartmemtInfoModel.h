//
//  DepartmemtInfoModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepartmemtInfoModel : NSObject

@property (strong , nonatomic) NSString * AppID;
@property (strong , nonatomic) NSString * Account;
@property (assign , nonatomic) NSInteger Depth;
@property (assign , nonatomic) NSInteger number;
@property (assign , nonatomic) NSInteger BranchID;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
