//
//  ViewLogModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewLogModel : NSObject

@property (strong , nonatomic) NSString * Operator;
@property (assign , nonatomic) NSInteger Progress;
@property (strong , nonatomic) NSString *ReasonStr;
@property (assign , nonatomic) NSInteger OpTime;
@property (assign , nonatomic) NSInteger FinalProgress;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
