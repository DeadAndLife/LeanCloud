//
//  ChatCell.h
//  LeanCloudDemo
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVIMMessage;
@interface ChatCell : UITableViewCell
@property (nonatomic, strong) AVIMMessage *imMessage;
@end
