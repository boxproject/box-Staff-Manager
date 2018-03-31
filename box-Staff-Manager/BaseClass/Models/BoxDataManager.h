//
//  BoxDataManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/31.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxDataManager : NSObject

@property(nonatomic, strong)NSString *box_IP;



+(instancetype)sharedManager;

@end
