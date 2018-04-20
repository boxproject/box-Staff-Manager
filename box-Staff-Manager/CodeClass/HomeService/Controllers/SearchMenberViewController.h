//
//  SearchMenberViewController.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchMenberDelegate <NSObject>

@optional
- (void)replaceMenberReflesh;
@end

typedef void(^MenberBlock)(NSString *text);
@interface SearchMenberViewController : UIViewController
@property (nonatomic, copy) MenberBlock menberBlock;
@property (nonatomic, strong) NSString *employee_account_id;
@property (nonatomic,weak) id <SearchMenberDelegate> delegate;
@end
