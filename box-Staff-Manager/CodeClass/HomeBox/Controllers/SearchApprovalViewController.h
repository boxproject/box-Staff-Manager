//
//  SearchApprovalViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalBusinessModel.h"
typedef void(^ApprovalBlock)(ApprovalBusinessModel *model);
@interface SearchApprovalViewController : UIViewController

@property (nonatomic, copy) ApprovalBlock approvalBlock;
@property (nonatomic, strong) NSString *currency;

@end
