//
//  DirectoryManager.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "DirectoryManager.h"

@interface DirectoryManager()

@property (nonatomic,strong) NSMutableArray *directoryList;

@end

@implementation DirectoryManager

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static DirectoryManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[DirectoryManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        //[self loadDBDirectoryData];
    }
    return self;
}

- (NSMutableArray *)loadDBDirectoryData:(NSString *)currency
{
    _directoryList = [[NSMutableArray alloc]init];
    FMResultSet *rs = [[DBHelp dataBase]executeQuery:@"select * from directoryTable where currency = ? order by currency desc;" withArgumentsInArray:@[currency]];
    while ([rs next]) {
        HomeDirectoryModel *model = [[HomeDirectoryModel alloc]init];
        model.currency = [rs stringForColumn:@"currency"];
        model.nameTitle = [rs stringForColumn:@"nameTitle"];
        model.address = [rs stringForColumn:@"address"];
        model.remark = [rs stringForColumn:@"remark"];
        model.currencyId = [rs intForColumn:@"currencyId"];
        model.directoryId = [rs stringForColumn:@"directoryId"];
        [_directoryList addObject:model];
    }
    return _directoryList;
}

/*
 * createDirectoryTable
 */
- (BOOL)createDirectoryTable
{
    NSString *contactsSql = @"CREATE TABLE directoryTable (directoryIndex INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , currency TEXT ,nameTitle TEXT ,address TEXT ,remark TEXT ,currencyId TEXT ,directoryId TEXT);";
    BOOL isOK = [DBHelp createTableHelp:contactsSql];
    if (isOK) {
        NSLog(@"directory Table Crate complete !");
    }
    return isOK;
}

/*
 * 根据directoryId从数据库中删除一条数据
 */
-(BOOL)deleteDirectoryModel:(HomeDirectoryModel *)model
{
    BOOL isOk = [[DBHelp dataBase]executeUpdate:@"delete from directoryTable where directoryId = ?;" withArgumentsInArray:@[model.directoryId]];
    return isOk;
}

/*
 * 根据directoryId修改数据库中的字段
 */
-(BOOL)updateDirectoryModel:(HomeDirectoryModel *)model
{
    BOOL isOK = [[DBHelp dataBase]executeUpdate:@"update directoryTable set currency = ?, nameTitle = ?,address = ?,remark = ?,currencyId = ? where directoryId = ?"
                           withArgumentsInArray:@[model.currency,model.nameTitle,model.address,model.remark,@(model.currencyId),model.directoryId]];
    return isOK;
}

/*
 * 往数据库中插入一条数据
 */
-(BOOL)insertDirectoryModel:(HomeDirectoryModel *)model
{
    BOOL isOK = [[DBHelp dataBase]executeUpdate:@"insert into directoryTable (currency,nameTitle,address,remark,currencyId,directoryId) values(?,?,?,?,?,?);"
                           withArgumentsInArray:@[model.currency,model.nameTitle,model.address,model.remark,@(model.currencyId),model.directoryId]];
    return isOK;
}


@end
