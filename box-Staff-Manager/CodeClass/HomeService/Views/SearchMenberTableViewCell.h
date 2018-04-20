//
//  SearchMenberTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchMenberModel.h"
#import "ApprovalBusApproversModel.h"

@interface SearchMenberTableViewCell : UITableViewCell

@property (nonatomic,strong) SearchMenberModel *model;

@property (nonatomic,strong) NSArray *array;

- (void)setDataWithModel:(SearchMenberModel *)model indexPath:(NSIndexPath *)indexPath;

@end
