//
//  ContactViewController.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "ContactViewController.h"
#import "XMPPTool.h"
#import "ChatViewController.h"
@interface ContactViewController ()<NSFetchedResultsControllerDelegate>
{
    //搜索结果控制器
    NSFetchedResultsController *_fetchResultController;
}
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        
    [self loadUser];
}
-(void)loadUser
{
    //获取花名册的上下文context
    NSManagedObjectContext *context = [[XMPPTool sharedXMPPTool].rosterStorage mainThreadManagedObjectContext];
    //创建NSFetchRequest,需要指定要搜索的模型
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    //设置排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    //创建搜素结果控制器
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    //NSFetchedResultsController有实时监控 coreData数据库变化的功能,数据库数据发生改变,会调用它的代理方法
    //设置代理
    _fetchResultController.delegate = self;
    //开始检索
    [_fetchResultController performFetch:nil];
}
#pragma mark - 代理方法
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _fetchResultController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flag"];
    XMPPUserCoreDataStorageObject *user =  _fetchResultController.fetchedObjects[indexPath.row];
    //默认情况下,用户的好友头像是不进行加载的(意思就是所默认情况下user.photo为nil,只有在加载一次之后,CoreData才会保存好友头像)
    if (user.photo) {
        cell.imageView.image = user.photo;
    }else{
        //user.jid 用户名
        NSData *data = [[XMPPTool sharedXMPPTool].vcardAvatar photoDataForJID:user.jid];
        cell.imageView.image = [UIImage imageWithData:data];
    }
    //用户名
    cell.textLabel.text = user.jidStr;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取mainstoryboard上面的viewcontroller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChatViewController *chatVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    XMPPUserCoreDataStorageObject *user =  _fetchResultController.fetchedObjects[indexPath.row];
    chatVC.friendJid = user.jid;
    [self.navigationController pushViewController:chatVC animated:YES];
}


@end
