//
//  TransferAwaitViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransferAwaitDelegate <NSObject>

@optional
- (void)backReflesh;
@end

@interface TransferAwaitViewController : UIViewController

@property (nonatomic,weak) id <TransferAwaitDelegate> delegate;

@end
