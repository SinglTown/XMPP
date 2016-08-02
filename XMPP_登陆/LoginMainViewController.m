//
//  LoginMainViewController.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/28.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "LoginMainViewController.h"
#import "XMPPTool.h"
#import "XMAcount.h"
@interface LoginMainViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userNameTF;

@property (strong, nonatomic) IBOutlet UITextField *userPwdTF;

@end

@implementation LoginMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *nameText = [XMAcount sharedXMAcount].loginName;
    if (nameText.length <= 0) {
        nameText = @"110";
    }
    self.userNameTF.text = nameText;
}
#pragma mark - 回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 登陆
- (IBAction)loginButtonDidClick:(id)sender {
    //保存用户名和密码
    NSString *name = self.userNameTF.text;
    NSString *pwd = self.userPwdTF.text;
    if (name.length > 0 && pwd.length > 0) {
        [[XMAcount sharedXMAcount] saveLoginInfoWith:name withPassword:pwd];
        [XMPPTool sharedXMPPTool].isLoginOrRegister = YES;
        [[XMPPTool sharedXMPPTool] login:^(BOOL success) {
            
            [[XMAcount sharedXMAcount] saveLoginStatus:YES];
            //切换到mainStoryboard
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            window.rootViewController = [storyboard instantiateInitialViewController];
        }];
    }
}
#pragma mark - 注册
- (IBAction)registerButtonDidClick:(id)sender {
}
#pragma mark - 其他方式登陆
- (IBAction)otherLoginButtonDicClick:(id)sender {
    
    
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
