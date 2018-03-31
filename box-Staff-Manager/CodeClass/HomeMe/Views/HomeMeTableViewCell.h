//
//  HomeMeTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeMeModel.h"

@interface HomeMeTableViewCell : UITableViewCell

@property (nonatomic,strong) HomeMeModel *model;

- (void)setDataWithModel:(HomeMeModel *)model row:(NSInteger)row;

@end
