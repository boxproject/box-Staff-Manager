//
//  CreateApprovalFlowCollectionReusableView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/4.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalBusinessDetailModel.h"

@interface CreateApprovalFlowCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *rightLable;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic,strong) ApprovalBusinessDetailModel *model;

- (void)setDataWithModel:(ApprovalBusinessDetailModel *)model index:(NSInteger)index;

@end
