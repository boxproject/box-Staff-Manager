//
//  AddDepartmentViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"

typedef NS_ENUM(NSInteger, DepartmentType) {
    DepartmentAddType,        //添加部门
    DepartmentEditType,       //修改部门名称
};
@protocol AddDepartmentDelegate <NSObject>

@optional
- (void)addDepartmentReflesh;
- (void)editDepartmentWithModel:(DepartmentModel *)model;
@end

@interface AddDepartmentViewController : UIViewController

@property (nonatomic,weak) id <AddDepartmentDelegate> delegate;

@property (nonatomic,assign) DepartmentType type;

@property (nonatomic, strong) DepartmentModel *model;

-(void)setValueWithModel:(DepartmentModel *)model;

@end
