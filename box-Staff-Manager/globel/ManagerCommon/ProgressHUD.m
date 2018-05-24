//
//  ProgressHUD.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ProgressHUD.h"

#define NetWorkCode1001  @"参数不完整"
#define NetWorkCode1002  @"您已提交注册申请，请耐心等待"
#define NetWorkCode2001  @"转账信息有误，请查验后重新提交"
#define NetWorkCode2002  @"未找到对应币种"
#define NetWorkCode2003  @"未找到对应的业务流程"
#define NetWorkCode2004  @"转账申请提交失败，请稍候重试"
#define NetWorkCode2005  @"签名信息错误"
#define NetWorkCode1004  @"指定账号不存在"
#define NetWorkCode1007  @"权限不足"
#define NetWorkCode3001  @"您的账号暂无权限创建审批流模板"
#define NetWorkCode3003  @"业务流模板名称重复"
#define NetWorkCode3004  @"创建审批流模板失败"
#define NetWorkCode1009  @"注册失败，请稍候重试"
#define NetWorkCode1010  @"您的账号已经存在，请勿重复提交注册申请"
#define NetWorkCode1011  @"您的账号已被停用"
#define NetWorkCode1014  @"直属上级账号已被停用"
#define NetWorkCode1006  @"未找到对应的业务流程"
#define NetWorkCode1005  @"签名信息错误"
#define NetWorkCode2006  @"您已提交审批意见，请勿重复提交"
#define NetWorkCode2007  @"转账信息哈希上链失败，请稍候重试"
#define NetWorkCode1012  @"请求代理服务器失败"
#define NetWorkCode3004  @"创建审批流模板失败"
#define NetWorkCode2008  @"未找到对应币种信息"
#define NetWorkCode1008  @"指定下级账号不存在"
#define NetWorkCode1013  @"指定下属账号已被停用"
#define NetWorkCode2009  @"余额不足"
#define NetWorkCode1003  @"未找到该注册申请"

@implementation ProgressHUD

+(void)showProgressHUD
{
    [WSProgressHUD setProgressHUDIndicatorStyle:WSProgressHUDIndicatorBigGray];
    [WSProgressHUD show];
}

+(void)showStatus:(NSInteger)code
{
    if(code == 2001){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2001];
    }else if(code == 2001){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2001];
    }else if(code == 2002){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2002];
    }else if(code == 2003){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2003];
    }else if(code == 2004){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2004];
    }else if(code == 2005){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2005];
    }else if(code == 1004){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1004];
    }else if(code == 1001){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1001];
    }else if(code == 1007){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1007];
    }else if(code == 3001){
        [WSProgressHUD showErrorWithStatus:NetWorkCode3001];
    }else if(code == 3003){
        [WSProgressHUD showErrorWithStatus:NetWorkCode3003];
    }else if(code == 3004){
        [WSProgressHUD showErrorWithStatus:NetWorkCode3004];
    }else if(code == 1002){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1002];
    }else if(code == 1009){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1009];
    }else if(code == 1010){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1010];
    }else if(code == 1011){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1011];
    }else if(code == 1014){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1014];
    }else if(code == 1006){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1006];
    }else if(code == 1005){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1005];
    }else if(code == 2006){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2006];
    }else if(code == 2007){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2007];
    }else if(code == 1012){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1012];
    }else if(code == 3004){
        [WSProgressHUD showErrorWithStatus:NetWorkCode3004];
    }else if(code == 2008){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2008];
    }else if(code == 1008){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1008];
    }else if(code == 1013){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1013];
    }else if(code == 2009){
        [WSProgressHUD showErrorWithStatus:NetWorkCode2009];
    }else if(code == 1003){
        [WSProgressHUD showErrorWithStatus:NetWorkCode1003];
    }
}


@end
