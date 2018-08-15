//
//  AddApprovalMemberCollectionViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmemtInfoModel.h"

@interface AddApprovalMemberCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) DepartmemtInfoModel *model;

-(void)setDataWithModel:(DepartmemtInfoModel *)model;

@end
