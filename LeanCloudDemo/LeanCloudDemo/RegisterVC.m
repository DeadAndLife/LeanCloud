//
//  ViewController.m
//  LeanCloudDemo
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "RegisterVC.h"
#import <AVUser.h>
#import "AppDelegate.h"
@interface RegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *paaswordTF;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)register:(UIButton *)sender {
    if (_usernameTF.text.length == 0 || _paaswordTF.text.length == 0){
        NSLog(@"用户名或密码不能为空");
        return;
    }
    //创建用户对象
    AVUser *user = [AVUser user];
    user.username = _usernameTF.text;
    user.password = _paaswordTF.text;
    
    //注册
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            NSLog(@"注册成功");
            //注册成功之后,自动登录
            [AVUser logInWithUsernameInBackground:_usernameTF.text password:_paaswordTF.text block:^(AVUser *user, NSError *error) {
                if (user != nil){
                    NSLog(@"登录成功");
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    [delegate showHomeVC];
                }else{
                    NSLog(@"登录失败:%@",error);
                }
            }];
        }else{
            NSLog(@"注册失败:%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
