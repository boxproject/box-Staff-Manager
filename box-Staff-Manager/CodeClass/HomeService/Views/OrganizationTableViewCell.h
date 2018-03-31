//
//  OrganizationTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationModel.h"
@interface OrganizationTableViewCell : UITableViewCell

@property (nonatomic,strong) OrganizationModel *model;

- (void)setDataWithModel:(OrganizationModel *)model;

@end
