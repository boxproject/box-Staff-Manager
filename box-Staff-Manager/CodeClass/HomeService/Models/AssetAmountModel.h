//
//  AssetAmountModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetAmountModel : NSObject

@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) NSString *amountTitle;
@property (nonatomic,strong) NSString *freezeAmount;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
