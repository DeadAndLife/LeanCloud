//
//  ChatVC.m
//  LeanCloudDemo
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChatVC.h"
#import "ChatCell.h"
#import "AppDelegate.h"
#import <AVUser.h>
#import <AVOSCloudIM.h>
@interface ChatVC ()<AVIMClientDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *messages;     //消息列表

@property (nonatomic, strong) AVUser *toChatUser;           //陪聊者
@property (nonatomic, strong) AVIMClient *client;
@property (nonatomic, strong) AVIMConversation *conversation;
@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messages = [NSMutableArray array];
    
    _client = ((AppDelegate *)[UIApplication sharedApplication].delegate).delegateClient;
    //设置client的代理
    _client.delegate = self;
    
    [self createdConversation];
}

-(void)createdConversation{
    //打开client
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //查询会话
            
            //创建查询会话的对象
            AVIMConversationQuery *query = [self.client conversationQuery];
            //设置查询的条件(m:对话中成员的列表)
            [query whereKey:@"m" containedIn:@[[AVUser currentUser].username,_toChatUser.username]];
            [query whereKey:@"m" sizeEqualTo:2];
            
            //查询符合条件的会话
            [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"查询会话失败:%@",error);
                }else{
                    if (objects.count == 0) {
                        //创建会话
                        NSString *conversationName = [NSString stringWithFormat:@"%@和%@",[AVUser currentUser].username,_toChatUser.username];
                        [_client createConversationWithName:conversationName clientIds:@[_toChatUser.username] callback:^(AVIMConversation *conversation, NSError *error) {
                            if (error) {
                                NSLog(@"创建会话失败:%@",error);
                            }else{
                               NSLog(@"创建会话成功");
                                _conversation = conversation;
                            }
                        }];
                    }else{
                        //保存会话
                        _conversation = objects.firstObject;
                    }
                }
            }];
            
        }else{
            NSLog(@"打开Client失败:%@",error);
        }
    }];
}


//点击键盘return发送消息
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //创建文本消息
    AVIMMessage *textMessage = [AVIMMessage messageWithContent:textField.text];
    //发送消息
    
    __weak ChatVC *weakSelf = self;
    [self.conversation sendMessage:textMessage callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [_messages addObject:textMessage];
            textField.text = nil;
            
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else{
            NSLog(@"发送消息失败:%@",error);
        }
    }];
    
    
    return YES;
}
#pragma mark - AVIMClientDelegate
// 接收消息的回调函数
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    [_messages addObject:message];
    
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = nil;
    AVIMMessage *message = _messages[indexPath.row];
    //判断当前单元格消息是谁发送的
    if ([message.clientId isEqualToString:[AVUser currentUser].username]) {
        //我发送的
        cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell" forIndexPath:indexPath];
        
    }else{
        //好友发送的消息
        cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
    }
    
    
    //配置cell内容
    cell.imMessage = message;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
