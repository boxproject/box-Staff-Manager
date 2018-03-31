//
//  TransferAwaitModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ApprovalState) {
    ApprovalAwait,   //待审批
    Approvaling,     //审批中
    ApprovalSucceed, //审批成功
    ApprovalFail     //审批失败
};

@interface TransferAwaitModel : NSObject

@property (nonatomic,strong) NSString *approvalTitle;
@property(nonatomic, assign) ApprovalState approvalState;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
