//
//  XMPPTool.h
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/28.
//  Copyright © 2015年 Wen. All rights reserved.
//


//登陆
/*
 xmppStream
 1.连接服务器(连接的时候,需要发送用户名)
 2.服务器通过代理方法返回是否成功
 3.给服务器发送密码(授权)
 4.授权结果
 5.如果授权成功,设置"在线"状态
 */

//注册
/*
 1.连接服务器(需要发送注册的用户名,发送的方式跟登陆一样)
 2.服务器通过代理方法返回连接的情况
 3.连接成功之后 发送注册密码(这个跟登陆的方法不太一样)
 4.服务器通过代理方法返回注册是否成功
 */

//导入XMPP的框架
#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

//声明登陆成功的block
typedef void(^LoginSuccessBlock)(BOOL success);
//声明注册成功的block
typedef void(^RegisterSuccessBlock)(BOOL success);

@interface XMPPTool : NSObject<XMPPStreamDelegate>

+(instancetype)sharedXMPPTool;
//用来区分到底是登陆操作还是注册操作
//规定YES---login  NO---register
@property (nonatomic,assign)BOOL isLoginOrRegister;

//定义XMPPStream对象(任何和服务的交互最终都要通过这个对象去完成)
@property (nonatomic,strong,readonly)XMPPStream *xmppStream;

//电子名片模块
@property (nonatomic,strong,readonly)XMPPvCardTempModule *vcard;
@property (nonatomic,strong,readonly)XMPPvCardCoreDataStorage *vcardStorage;
//头像模块
@property (nonatomic,strong,readonly)XMPPvCardAvatarModule *vcardAvatar;
//花名册模块
@property (nonatomic,strong,readonly)XMPPRoster *roster;
@property (nonatomic,strong,readonly)XMPPRosterCoreDataStorage *rosterStorage;
//消息模块
@property (nonatomic,strong,readonly)XMPPMessageArchiving *message;
@property (nonatomic,strong,readonly)XMPPMessageArchivingCoreDataStorage *messageStorage;

#pragma mark - 登陆的方法
-(void)login:(LoginSuccessBlock)loginBlock;
#pragma mark - 注册的方法
-(void)registerUser:(RegisterSuccessBlock)registerBlock;
#pragma mark - 注销
-(void)loginOut;

@end
