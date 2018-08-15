//
//  BoxDataManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/31.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, LaunchState){
    PerfectInformation,     //首次进入，完善信息
    EnterHomeBox,           //直接进入主页
    LoginState              //token失效或账号锁定进入登录状态
};
 
@interface BoxDataManager : NSObject
/** IP地址 */
@property(nonatomic, strong)NSString *box_IP;
/** IP-Port */
@property(nonatomic, strong)NSString *box_IpPort;
/** 申请者唯一识别码 */
@property(nonatomic, strong)NSString *applyer_id;
/** 账号唯一标识符 */
@property(nonatomic, strong)NSString *app_account_id;
/** 账号扫码注册生成的固定随机值 */
@property(nonatomic, strong)NSString *app_account_random;
/** 用来加密登录密码生成的固定的key */
@property(nonatomic, strong)NSString *encryptKey;
/** 直属上级唯一识别码 */
@property(nonatomic, strong)NSString *captain_id;
/** 新注册员工账号 */
@property(nonatomic, strong)NSString *applyer_account;
/** 服务端申请表ID */
@property(nonatomic, strong)NSString *reg_id;
/** 公钥  */
@property(nonatomic, strong)NSString *publicKeyBase64;
/** 私钥 */
@property(nonatomic, strong)NSString *privateKeyBase64;
/** 直属上级是否为私钥APP，0是 */
@property(nonatomic, strong)NSString *depth;
/** 启动状态 */
@property(nonatomic, assign)LaunchState launchState;
/** 账户密码 */
@property(nonatomic, strong)NSString *passWord;
/** 部门名称 */
@property(nonatomic, strong)NSString *departMemtName;
/** 部门ID */
@property(nonatomic, assign)NSString *ID;
/** 登录生成的token,token有效期暂定为8小时 */
@property(nonatomic, strong)NSString *token;

+(instancetype)sharedManager;
/** 获取本地数据 */
-(void)getAllData;
/** 获取数据到本地 */
-(void)saveDataWithCoding:(NSString *)coding codeValue:(NSString *)codeValue;
/** 获取启动状态 */
-(NSInteger)getLaunchState;
-(void)removeDataWithCoding:(NSString *)coding;

@end
