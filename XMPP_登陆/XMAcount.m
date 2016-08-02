//
//  XMAcount.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/28.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "XMAcount.h"
static XMAcount *acount = nil;
@implementation XMAcount
+(instancetype)sharedXMAcount
{
    return [[self alloc] init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (acount == nil) {
            acount = [super allocWithZone:zone];
        }
    });
    return acount;
}
#pragma mark - 保存登陆信息
-(void)saveLoginInfoWith:(NSString *)name
            withPassword:(NSString *)pwd
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kLoginName];
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:kLoginPwd];
    //马上同步
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 保存注册信息
-(void)saveRegisterInforWith:(NSString *)name
                withPassword:(NSString *)pwd
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kRegisterName];
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:kRegisterPwd];
    //马上同步
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 保存登陆状态的方法
-(void)saveLoginStatus:(BOOL)status
{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:kLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 重写所有的getter方法
-(BOOL)isLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLogin];
}
-(NSString *)loginName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoginName];
}
-(NSString *)loginPwd
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoginPwd];
}
-(NSString *)registerName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterName];
}
-(NSString *)registerPwd
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterPwd];
}
@end
