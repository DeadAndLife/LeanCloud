//
//  ChatCell.m
//  LeanCloudDemo
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ChatCell.h"
#import <AVIMMessage.h>
@interface ChatCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ChatCell

-(void)setImMessage:(AVIMMessage *)imMessage{
    _imMessage = imMessage;
    
    _nameLabel.text = imMessage.clientId;
    _contentLabel.text = imMessage.content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
