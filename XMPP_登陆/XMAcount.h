//
//  XMAcount.h
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/28.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLoginName @"loginName"
#define kLoginPwd @"loginPwd"
#define kRegisterName @"registerName"
#define kRegisterPwd @"registerPwd"
#define kLogin @"isLogin"
@interface XMAcount : NSObject

+(instancetype)sharedXMAcount;

//登陆
@property (nonatomic,copy)NSString *loginName;
@property (nonatomic,copy)NSString *loginPwd;

//注册
@property (nonatomic,copy)NSString *registerName;
@property (nonatomic,copy)NSString *registerPwd;

@property (nonatomic,assign,getter=isLogin)BOOL login;


#pragma mark - 保存登陆信息
-(void)saveLoginInfoWith:(NSString *)name
            withPassword:(NSString *)pwd;
#pragma mark - 保存注册信息
-(void)saveRegisterInforWith:(NSString *)name
                withPassword:(NSString *)pwd;
#pragma mark - 保存登陆状态的方法
-(void)saveLoginStatus:(BOOL)status;
@end
