//
//  AddFriendVC.m
//  LeanCloudDemo
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "AddFriendVC.h"
#import <AVStatus.h>
@interface AddFriendVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)addFriend:(UIButton *)sender {
    //请注意，新创建的应用的用户表 _User 默认关闭了查询权限。你可以通过 Class 权限设置打开查询权限，请参考 数据与安全 · Class 级别的权限。我们推荐开发者在 云引擎 中封装用户查询，只查询特定条件的用户，避免开放用户表的全部查询权限。
    
    //创建用于查询的对象
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
    //设置查询条件
    [userQuery whereKey:@"username" containedIn:@[_usernameTF.text]];
    //查询
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            NSLog(@"查询失败:%@",error);
        }else{
            if (objects.count > 0) {
                //添加好友
                AVUser *user = objects.firstObject;
                //如果在 控制台 > 设置 > 应用选项 > 其他 勾选了 应用内社交模块，关注用户时自动反向关注，那么在当前用户关注某个人，那个人也会自动关注当前用户。
                //如果不设置 "关注用户时自动反向关注" 需要follow之后发送好友请求
                [[AVUser currentUser] follow:user.objectId andCallback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"添加好友成功");
                    }else{
                        NSLog(@"添加好友失败:%@",error);
                    }
                }];
            }else{
                NSLog(@"没有找到对应的好友");
            }
        }
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
