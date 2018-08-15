//
//  ViewApprovalLogTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewApprovalLogModel.h"

@interface ViewApprovalLogTableViewCell : UITableViewCell

@property (nonatomic,strong) ViewApprovalLogModel *model;

- (void)setDataWithModel:(ViewApprovalLogModel *)model;

+ (CGFloat)defaultHeight:(ViewApprovalLogModel *)model;

@end
