//
//  AppDelegate.h
//  LeanCloudDemo
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) AVIMClient *delegateClient;
@property (strong, nonatomic) UIWindow *window;
//显示首页
-(void)showHomeVC;
@end

