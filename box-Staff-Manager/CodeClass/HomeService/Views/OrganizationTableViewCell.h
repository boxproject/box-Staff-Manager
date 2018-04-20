//
//  OrganizationTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchMenberModel.h"
@interface OrganizationTableViewCell : UITableViewCell

@property (nonatomic,strong) SearchMenberModel *model;

- (void)setDataWithModel:(SearchMenberModel *)model;

@end
