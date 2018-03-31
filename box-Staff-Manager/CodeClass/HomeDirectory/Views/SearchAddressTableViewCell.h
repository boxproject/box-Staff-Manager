//
//  SearchAddressTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchAddressModel.h"
@interface SearchAddressTableViewCell : UITableViewCell

@property (nonatomic,strong) SearchAddressModel *model;

- (void)setDataWithModel:(SearchAddressModel *)model;

@end
