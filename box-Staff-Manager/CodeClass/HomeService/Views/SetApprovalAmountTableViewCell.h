//
//  SetApprovalAmountTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

@protocol SetApprovalAmountDelegate <NSObject>

@optional
- (void)textViewEdit:(NSString *)text indexPath:(NSIndexPath *)indexPath;
@end

@interface SetApprovalAmountTableViewCell : UITableViewCell

@property (nonatomic,strong) CurrencyModel *model;

- (void)setDataWithModel:(CurrencyModel *)model indexPath:(NSIndexPath *)indexPath;
@property (nonatomic,weak) id <SetApprovalAmountDelegate> delegate;

@end
