//
//  HomeListVC.m
//  LeanCloudDemo
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "HomeListVC.h"
#import <AVStatus.h>
@interface HomeListVC ()
@property (nonatomic, strong) NSArray *friends;
@end

@implementation HomeListVC

- (IBAction)logout:(UIBarButtonItem *)sender {
    //用户登出系统，SDK 会自动的清理缓存信息。
    [AVUser logOut];
    
    exit(0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //粉丝列表查询
    AVQuery *query= [AVUser followerQuery:[AVUser currentUser].objectId];
    //默认的查询得到的 AVUser 对象仅仅有 ObjectId 数据，如果需要整个 AVUser 对象所有属性，则需要调用 include 方法
    [query includeKey:@"follower"];
    //查询
    _friends = [query findObjects];
    
    [self.tableView reloadData];
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
    return _friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    //获取行对应的AVUser
    AVUser *user = _friends[indexPath.row];
    //显示用户名
    cell.textLabel.text = user.username;
    
    return cell;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tochat"]) {
        UIViewController *destinationVC = segue.destinationViewController;
        
        AVUser *seletedUser = _friends[self.tableView.indexPathForSelectedRow.row];
        
        [destinationVC setValue:seletedUser forKey:@"toChatUser"];
    }
}


@end
