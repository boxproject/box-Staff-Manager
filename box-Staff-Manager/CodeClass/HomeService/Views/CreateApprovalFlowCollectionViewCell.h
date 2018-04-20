//
//  CreateApprovalFlowCollectionViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/4.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalBusApproversModel.h"

@protocol CreateApprovalFlowCellDelegate <NSObject>

@optional
- (void)addMenberAction:(NSIndexPath *)indexPath;
- (void)deleteMenberAction:(NSIndexPath *)indexPath;
@end

@interface CreateApprovalFlowCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) id <CreateApprovalFlowCellDelegate> delegate;
@property (nonatomic,strong) ApprovalBusApproversModel *model;
@property (nonatomic, strong) UIButton *deleteButton;

- (void)setDataWithModel:(ApprovalBusApproversModel *)model indexPath:(NSIndexPath *)indexPath;

@end
