//
//  DetailInfoViewController.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "XMPPvCardTemp.h"
#import "XMPPTool.h"
#import "XMAcount.h"
@interface DetailInfoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nikeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;

@end

@implementation DetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //个人名片的模型
    XMPPvCardTemp *temp = [XMPPTool sharedXMPPTool].vcard.myvCardTemp;
    self.headerImageView.image = [UIImage imageWithData:temp.photo];
    //账号
    self.userNameLabel.text = [XMAcount sharedXMAcount].loginName;
    //昵称
    self.nikeNameLabel.text = temp.nickname;
    //公司
    self.companyLabel.text = temp.orgName;
    //职位
    self.positionLabel.text = temp.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
