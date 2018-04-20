//
//  CreateApprovalFlowViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/4.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateApprovalFlowDelegate <NSObject>

@optional
- (void)createApprovalSucceed;
@end

@interface CreateApprovalFlowViewController : UIViewController

@property (nonatomic,weak) id <CreateApprovalFlowDelegate> delegate;

@end
