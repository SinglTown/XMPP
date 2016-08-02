//
//  RegisterViewController.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/28.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "RegisterViewController.h"
#import "XMPPTool.h"
#import "XMAcount.h"
@interface RegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *registerUserNameTF;
@property (strong, nonatomic) IBOutlet UITextField *registerPwdTF;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)registerButtonAction:(id)sender {
    //保存注册的数据
    [[XMAcount sharedXMAcount] saveRegisterInforWith:self.registerUserNameTF.text withPassword:self.registerPwdTF.text];
    //设置注册
    [XMPPTool sharedXMPPTool].isLoginOrRegister = NO;
    //开始注册
    [[XMPPTool sharedXMPPTool] registerUser:^(BOOL success) {
        
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
