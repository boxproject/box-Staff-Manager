//
//  SearchApprovalTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchApprovalModel.h"

@interface SearchApprovalTableViewCell : UITableViewCell

@property (nonatomic,strong) SearchApprovalModel *model;

- (void)setDataWithModel:(SearchApprovalModel *)model;

@end
