//
//  OrganizationViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchMenberModel.h"

@interface OrganizationViewController : UIViewController

@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSString *currentTitle;
@property(nonatomic, strong)SearchMenberModel *searchMenberModel;
@property (nonatomic, strong)NSString *app_account_id;

@end
