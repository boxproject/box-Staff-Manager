//
//  AddApprovalMemberTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"

@interface AddApprovalMemberTableViewCell : UITableViewCell

@property (nonatomic,strong) DepartmentModel *model;

@property (nonatomic,assign) NSInteger OneCell;

- (void)setDataWithModel:(DepartmentModel *)model;

@property (nonatomic,strong) UILabel *title;

@end
