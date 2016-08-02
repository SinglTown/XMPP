//
//  AddViewController.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "AddViewController.h"
#import "XMPPTool.h"
#import "XMAcount.h"
@interface AddViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userNameTF;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)saveRightItemAction:(id)sender {
    
    NSString *userString = self.userNameTF.text;
    //创建JID对象
    XMPPJID *jid = [XMPPJID jidWithUser:userString domain:@"lanou3gdemac-mini-113.local" resource:@"iphone"];
    //不能添加自己为好友
    if ([userString isEqualToString:[XMAcount sharedXMAcount].loginName]) {
        NSLog(@"不能添加自己为好友");
        return;
    }
    //已经添加的不需要再添加
    BOOL isfriendExist = [[XMPPTool sharedXMPPTool].rosterStorage userExistsWithJID:jid xmppStream:[XMPPTool sharedXMPPTool].xmppStream];
    if (isfriendExist) {
        NSLog(@"此好友已存在");
        return;
    }
    //添加好友  在XMPP里面添加好友 叫"订阅"
    //也叫站内信
    [[XMPPTool sharedXMPPTool].roster subscribePresenceToUser:jid];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
