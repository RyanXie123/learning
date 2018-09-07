//
//  TextMessageCell.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "GroupChat.h"
#import <Masonry.h>

@interface TextMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) UIImageView  *indicatorView;
@property (nonatomic, strong) UIImageView *tipIcon;
@property (nonatomic, strong) GroupChat *chat;
-(void)initData:(GroupChat *)chat;



+(CGFloat)cellHeight:(GroupChat *)chat;
@end
