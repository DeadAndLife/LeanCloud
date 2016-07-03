
//
//  LoginVC.m
//  LeanCloudDemo
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "LoginVC.h"
#import <AVUser.h>
#import "AppDelegate.h"
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)login:(UIButton *)sender {
    if (_usernameTF.text.length == 0 || _passwordTF.text.length == 0){
        NSLog(@"用户名或密码不能为空");
        return;
    }
    
    //登录
    [AVUser logInWithUsernameInBackground:_usernameTF.text password:_passwordTF.text block:^(AVUser *user, NSError *error) {
        if (user != nil){
            NSLog(@"登录成功");
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate showHomeVC];
        }else{
            NSLog(@"登录失败:%@",error);
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
