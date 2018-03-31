//
//  organizationListTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationListModel.h"

@interface organizationListTableViewCell : UITableViewCell

@property (nonatomic,strong) OrganizationListModel *model;

- (void)setDataWithModel:(OrganizationListModel *)model;

@end
