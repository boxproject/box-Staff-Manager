//
//  ViewLogViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalBusinessModel.h"
#import "TransferAwaitModel.h"

@interface ViewLogViewController : UIViewController

@property(nonatomic, strong) ApprovalBusinessModel *approvalBusinessModel;
@property(nonatomic, strong)TransferAwaitModel *transferAwaitModel;
@property(nonatomic, assign)NSInteger type;

@end
