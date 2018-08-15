//
//  SearchCurrencyTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CurrencyModel.h"

@interface SearchCurrencyTableViewCell : UITableViewCell

@property (nonatomic,strong) CurrencyModel *model;

@property (nonatomic,strong) NSArray *array;

- (void)setDataWithModel:(CurrencyModel *)model;

@end
