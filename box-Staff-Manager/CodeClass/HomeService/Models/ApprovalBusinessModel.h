//
//  ApprovalBusinessModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalBusinessModel : NSObject

/** 审批流模板编号 */
@property (nonatomic,strong) NSString *flow_id;
/** 审批流模板审批进度 0待审批 2审批拒绝 3审批通过 */
@property(nonatomic, assign) ApprovalState progress;
/** 审批流模板名称 */
@property (nonatomic,strong) NSString *flow_name;
/** 金额上限 */
@property (nonatomic,strong) NSString *single_limit;

- (instancetype)initWithDict:(NSDictionary *)dict;



@end
