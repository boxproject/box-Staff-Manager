//
//  ApprovalBusinessFooterView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ApprovalFooterState) {
    ApprovalFooterFlow,
    ApprovalFooterFlowCancel,
    ApprovalFooterTransfer,
    ApprovalFooterTransferCancel  
};

@protocol ApprovalBusinessFooterDelegate <NSObject>

@optional
- (void)enterViewLog;
- (void)cancelApprovalBusiness;
@end

@interface ApprovalBusinessFooterView : UIView

-(id)initWithFrame:(CGRect)frame;
-(void)setValueWithStatus:(ApprovalFooterState)Status;
-(void)setValueWithProgress:(NSInteger)progress type:(ApprovalFooterState)Status;

@property (nonatomic,weak) id <ApprovalBusinessFooterDelegate> delegate;

@end
