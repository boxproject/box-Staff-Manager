//
//  HomeDirectoryTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDirectoryModel.h"
@interface HomeDirectoryTableViewCell : UITableViewCell

@property (nonatomic,strong) HomeDirectoryModel *model;

- (void)setDataWithModel:(HomeDirectoryModel *)model integer:(NSInteger)integer;

@end
