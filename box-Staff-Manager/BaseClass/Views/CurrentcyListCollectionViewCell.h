//
//  CurrentcyListCollectionViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

@interface CurrentcyListCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) CurrencyModel *model;

- (void)setDataWithModel:(CurrencyModel *)model;

@end
