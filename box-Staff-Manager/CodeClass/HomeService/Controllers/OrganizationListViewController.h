//
//  OrganizationListViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationListViewController : UIViewController

@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSString *currentTitle;
@property(nonatomic, strong)NSString *superiorTitle;

@end
