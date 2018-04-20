//
//  SearchMenberModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchMenberModel : NSObject
//账号
@property (nonatomic,strong) NSString *account;
//账号唯一标识符
@property (nonatomic,strong) NSString *app_account_id;
//该账号下属个数
@property (nonatomic,assign) NSInteger employee_num;
//对应上级账号唯一标识符
@property (nonatomic,strong) NSString *manager_account_id;
//上级对该账号公钥生成的信息摘要
@property (nonatomic,strong) NSString *cipher_text;
//公钥是否上传到根节点账户, 1是 0否
@property (nonatomic,assign) NSInteger is_uploaded;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
