//
//  DepartmentTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"

@interface DepartmentTableViewCell : UITableViewCell

@property (nonatomic,strong) DepartmentModel *model;
@property (nonatomic,strong) UIImageView *dragImage;
- (void)setDataWithModel:(DepartmentModel *)model;

@end
