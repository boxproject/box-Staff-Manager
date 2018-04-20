//
//  DirectoryManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeDirectoryModel.h"

@interface DirectoryManager : NSObject

+(instancetype)sharedManager;
- (NSMutableArray *)loadDBDirectoryData:(NSString *)currency;
- (BOOL)createDirectoryTable;
- (BOOL)deleteDirectoryModel:(HomeDirectoryModel *)model;
- (BOOL)updateDirectoryModel:(HomeDirectoryModel *)model;
- (BOOL)insertDirectoryModel:(HomeDirectoryModel *)model;

@end
