//
//  ConfirmLoginViewController.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/28.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "ConfirmLoginViewController.h"
#import "XMAcount.h"
#import "XMPPTool.h"
@interface ConfirmLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *confirmUserNameTF;
@property (strong, nonatomic) IBOutlet UITextField *confirmPwdTF;

@end

@implementation ConfirmLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - 确认登陆
- (IBAction)confirmLoginButtonAction:(id)sender {
    
    [[XMAcount sharedXMAcount] saveLoginInfoWith:self.confirmUserNameTF.text withPassword:self.confirmPwdTF.text];
    
    
    [XMPPTool sharedXMPPTool].isLoginOrRegister = YES;
    
    [[XMPPTool sharedXMPPTool] login:^(BOOL success) {
        [[XMAcount sharedXMAcount] saveLoginStatus:YES];
        //切换到mainStoryboard
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        window.rootViewController = [storyboard instantiateInitialViewController];
    }];
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
