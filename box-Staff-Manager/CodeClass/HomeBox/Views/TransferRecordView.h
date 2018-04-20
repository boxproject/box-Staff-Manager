//
//  TransferRecordView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferAwaitModel.h"

@protocol TransferRecordViewDelegate <NSObject>

@optional
- (void)transferRecordViewDidTableView:(TransferAwaitModel *)model;
- (void)refleshViewHight:(NSInteger)integer;
@end

@interface TransferRecordView : UIView

@property (nonatomic,weak) id <TransferRecordViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;

-(void)requestData;

@end
