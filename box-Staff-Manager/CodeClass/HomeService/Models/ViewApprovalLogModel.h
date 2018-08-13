//
//  ViewApprovalLogModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewApprovalLogModel : NSObject

@property (strong , nonatomic) NSString *ApplyerAccount;
@property (strong , nonatomic) NSString *CaptainId;
//同意拒绝
@property (strong , nonatomic) NSString *Option;
//操作意见
@property (strong , nonatomic) NSString *Opinion;
@property (strong , nonatomic) NSString *CreateTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
