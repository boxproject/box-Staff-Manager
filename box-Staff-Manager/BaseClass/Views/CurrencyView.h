//
//  CurrencyView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

@protocol CurrencyViewDelegate <NSObject>

@optional
- (void)didSelectItem:(CurrencyModel *)model;
@end

@interface CurrencyView : UIView

@property (nonatomic,weak) id <CurrencyViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;

@end
