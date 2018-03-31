//
//  SearchApprovalModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchApprovalModel : NSObject

@property (nonatomic,strong) NSString *titleName;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
