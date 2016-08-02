//
//  XMPPTool.m
//  XMPP_登陆
//
//  Created by chuanbao on 15/12/28.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "XMPPTool.h"
#import "XMAcount.h"

@interface XMPPTool ()
{
    LoginSuccessBlock _loginSuccessBlock;
    RegisterSuccessBlock _registerSuccessBlock;
}
@end

static XMPPTool *tool = nil;
@implementation XMPPTool
+(instancetype)sharedXMPPTool
{
    return [[self alloc] init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [super allocWithZone:zone];
        }
    });
    return tool;
}
#pragma mark - 登陆的方法
-(void)login:(LoginSuccessBlock)loginBlock
{
    _loginSuccessBlock = loginBlock;
    [self connectToHost];
}
#pragma mark - 注册的方法
-(void)registerUser:(RegisterSuccessBlock)registerBlock
{
    _registerSuccessBlock = registerBlock;
    [self connectToHost];
}
#pragma mark - 私有方法
-(void)setUpXmppStream
{
    //初始化xmppStream
    _xmppStream = [[XMPPStream alloc] init];
    
    //电子名片模块
    _vcardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vcard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vcardStorage];
    //任何模块添加之后都需要激活
    [_vcard activate:_xmppStream];
    
    //头像模块
    _vcardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vcard];
    //激活
    [_vcardAvatar activate:_xmppStream];
    
    //花名册模块
    _rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    //激活
    [_roster activate:_xmppStream];
    
    //消息模块
    _messageStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    _message = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_messageStorage];
    //激活
    [_message activate:_xmppStream];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark - 连接服务器
-(void)connectToHost
{
    if (_xmppStream == nil) {
        [self setUpXmppStream];
    }
    //断开与服务器的链接(进行新的链接之前断开旧的连接)
    [_xmppStream disconnect];
    //设置主机地址
    _xmppStream.hostName = @"172.21.56.38";
    //设置服务器的端口号
    _xmppStream.hostPort = 5222;
    //设置用户名
    NSString *name = nil;
    if (self.isLoginOrRegister == YES) {
        name = [XMAcount sharedXMAcount].loginName;
    }else{
        name = [XMAcount sharedXMAcount].registerName;
    }
    XMPPJID *myjid = [XMPPJID jidWithUser:name domain:@"lanou3gdemac-mini-113.local" resource:@"iphone"];
    _xmppStream.myJID = myjid;
    
    //连接服务器
    [_xmppStream connectWithTimeout:-1 error:nil];
}
#pragma mark - 发送密码
-(void)sendPassWordToHost
{
    NSString *pwd = nil;
    if (self.isLoginOrRegister == YES) {
        pwd = [XMAcount sharedXMAcount].loginPwd;
        [_xmppStream authenticateWithPassword:pwd error:nil];
    }else{
        pwd = [XMAcount sharedXMAcount].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }
}
#pragma mark - 设置在线状态
-(void)setOnlineToHost
{
    //XMPPPresence 是设置状态的类
    XMPPPresence *presence = [XMPPPresence presence];
    //通过_xmppStream向服务器发送在线消息
    [_xmppStream sendElement:presence];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调登陆成功的block
        _loginSuccessBlock(YES);
    });
}
#pragma mark - xmppStream 代理方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接服务器成功");
    [self sendPassWordToHost];
}
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"与服务器断开连接");
}
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功");
    [self setOnlineToHost];
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"授权失败");
}
#pragma mark - 注册的代理方法
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        _registerSuccessBlock(YES);
    });
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败");
}
#pragma mark - 注销
-(void)loginOut
{
    //1.设置离线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
    //2.断开连接
    [_xmppStream disconnect];
}
@end
