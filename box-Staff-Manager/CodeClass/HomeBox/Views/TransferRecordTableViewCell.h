//
//  TransferRecordTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferRecordModel.h"

@interface TransferRecordTableViewCell : UITableViewCell

@property (nonatomic,strong) TransferRecordModel *model;

- (void)setDataWithModel:(TransferRecordModel *)model;

@end
