//
//  ChatViewController.m
//  XMPP_登陆
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 Wen. All rights reserved.
//

#import "ChatViewController.h"
#import "XMPPTool.h"
#import "XMAcount.h"
@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextFieldDelegate>
{
    NSFetchedResultsController *_fetchResultsController;
}
@property (strong, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextField *chatInputTF;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomTableViewContraints;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置textField的代理
    self.chatInputTF.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //获取消息的上下文
    [self loadMessage];
    
    
    [self scrollTableToBottom];
}
-(void)loadMessage
{
    NSManagedObjectContext *context = [[XMPPTool sharedXMPPTool].messageStorage mainThreadManagedObjectContext];
    //请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //过滤聊天记录
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr=%@ AND bareJidStr=%@",[XMPPTool sharedXMPPTool].xmppStream.myJID.bare,self.friendJid.bare];
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    
    request.predicate = predicate;
    request.sortDescriptors = @[sort];
    
    
    
    //搜素结果控制器
    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchResultsController.delegate = self;
    
    //执行搜索
    [_fetchResultsController performFetch:nil];
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.chatTableView reloadData];
    [self scrollTableToBottom];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *text = self.chatInputTF.text;
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    //发送的内容(被包装为主体)
    [message addBody:text];
    [[XMPPTool sharedXMPPTool].xmppStream sendElement:message];
    
    self.chatInputTF.text = nil;
    
    return YES;
}
#pragma mark - 键盘
-(void)kbFrameDidChange:(NSNotification *)sender
{
    CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect rect = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kvHeight = rect.size.height;
    self.bottomTableViewContraints.constant = windowHeight-kvHeight-50-44;
}
#pragma mark - 设置section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark - 设置row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fetchResultsController.fetchedObjects.count;
}
#pragma mark - 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chat"];
    XMPPMessageArchiving_Message_CoreDataObject *object = _fetchResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = object.body;
    return cell;
}
#pragma mark - tableView滑动到最底部
-(void)scrollTableToBottom
{
    NSInteger count = _fetchResultsController.fetchedObjects.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
