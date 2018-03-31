//
//  TransferRecordModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransferState) {
    Transfering,     //审批中
    TransferStateSucceed, //同意审批
    TransferFail     //拒绝审批
};

@interface TransferRecordModel : NSObject

@property (nonatomic,strong) NSString *topLeft;
@property (nonatomic,assign) NSInteger timeIn;
@property (nonatomic,strong) NSString *topRight;
@property(nonatomic, assign) TransferState tansferStateState;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
