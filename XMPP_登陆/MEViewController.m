//
//  MEViewController.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "MEViewController.h"
#import "XMPPTool.h"
#import "XMPPvCardTemp.h"
#import "XMAcount.h"
@interface MEViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation MEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //如何取出头像
    XMPPvCardTemp *temp = [XMPPTool sharedXMPPTool].vcard.myvCardTemp;
    self.pictureImageView.image = [UIImage imageWithData:temp.photo];
    
    //显示用户名
    self.userNameLabel.text = [NSString stringWithFormat:@"探探号:%@",[XMAcount sharedXMAcount].loginName];
}
- (IBAction)loginOutItemClick:(id)sender {
    
    [[XMPPTool sharedXMPPTool] loginOut];
    [[XMAcount sharedXMAcount] saveLoginStatus:NO];
    //返回登陆界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController =  storyboard.instantiateInitialViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
