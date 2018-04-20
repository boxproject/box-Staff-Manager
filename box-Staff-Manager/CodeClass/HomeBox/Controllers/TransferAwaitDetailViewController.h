//
//  TransferAwaitDetailViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferAwaitModel.h"
@protocol TransferAwaitDetailDelegate <NSObject>

@optional
- (void)backReflesh;
@end
@interface TransferAwaitDetailViewController : UIViewController

@property(nonatomic, strong)TransferAwaitModel *model;
@property (nonatomic,weak) id <TransferAwaitDetailDelegate> delegate;

@end
