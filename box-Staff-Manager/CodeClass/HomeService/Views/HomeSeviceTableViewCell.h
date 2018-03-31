//
//  HomeSeviceTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeServiceModel.h"

@interface HomeSeviceTableViewCell : UITableViewCell

@property (nonatomic,strong) HomeServiceModel *model;

- (void)setDataWithModel:(HomeServiceModel *)model;

@end
