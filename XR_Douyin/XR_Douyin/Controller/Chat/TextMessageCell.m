//
//  TextMessageCell.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/7.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "TextMessageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Extension.h"
#define COMMON_MSG_PADDING         8
#define USER_MSG_CORNER_RADIUS     10
#define MAX_USER_MSG_WIDTH         SCREEN_WIDTH - 160


@implementation TextMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorClear;
        _avatar = [[UIImageView alloc] init];
        _avatar.image = [UIImage imageNamed:@"img_find_default"];
        _avatar.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_avatar];
        
        _textView = [[UITextView alloc]init];
        _textView.textColor = [[TextMessageCell attributes]valueForKey:NSForegroundColorAttributeName];
        _textView.font = [[TextMessageCell attributes]valueForKey:NSFontAttributeName];
        _textView.scrollEnabled = NO;
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.backgroundColor = ColorClear;
        _textView.textContainerInset = UIEdgeInsetsMake(USER_MSG_CORNER_RADIUS, USER_MSG_CORNER_RADIUS, USER_MSG_CORNER_RADIUS, USER_MSG_CORNER_RADIUS);
        _textView.textContainer.lineFragmentPadding = 0;
        
        
        
        
        [self addSubview:_textView];
        
        _backgroundLayer = [[CAShapeLayer alloc]init];
        _backgroundLayer.zPosition = -1;
        [_textView.layer addSublayer:_backgroundLayer];
//
//
//
//        _indicatorView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon30WhiteSmall"]];
//        [_indicatorView setHidden:YES];
//        [self addSubview:_indicatorView];
//
//        _tipIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icWarning"]];
//        [_tipIcon setHidden:YES];
//        [self addSubview:_tipIcon];
        
//        _textView.font =
        
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:_textView.attributedText];
    [attributedString addAttributes:[TextMessageCell attributes] range:NSMakeRange(0, attributedString.length)];
    
    CGSize size = [attributedString multiLineSize:MAX_USER_MSG_WIDTH];
    
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.backgroundLayer.path = [self createBezierPath:USER_MSG_CORNER_RADIUS width:size.width height:size.height].CGPath;
    self.backgroundLayer.frame = CGRectMake(0, 0, size.width + USER_MSG_CORNER_RADIUS * 2, size.height + 2 * USER_MSG_CORNER_RADIUS);
    
    
    if ([MD5_UDID isEqualToString:_chat.visitor.udid]) {
        _avatar.frame = CGRectMake(SCREEN_WIDTH - COMMON_MSG_PADDING - 30, COMMON_MSG_PADDING, 30, 30);
        _textView.frame = CGRectMake(CGRectGetMinX(self.avatar.frame) - COMMON_MSG_PADDING - (size.width + USER_MSG_CORNER_RADIUS * 2), COMMON_MSG_PADDING, size.width + USER_MSG_CORNER_RADIUS * 2, size.height + USER_MSG_CORNER_RADIUS * 2);
        _backgroundLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        _backgroundLayer.fillColor = ColorThemeYellow.CGColor;
    }else {
        _avatar.frame = CGRectMake(COMMON_MSG_PADDING, COMMON_MSG_PADDING, 30, 30);
        _textView.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) + COMMON_MSG_PADDING, COMMON_MSG_PADDING, size.width + USER_MSG_CORNER_RADIUS * 2, size.height + USER_MSG_CORNER_RADIUS *2);
        self.backgroundLayer.fillColor = ColorWhite.CGColor;
    }
    [CATransaction commit];
}


+ (NSDictionary *)attributes {
    return @{NSForegroundColorAttributeName:ColorBlack,NSFontAttributeName:BigFont};
}

-(void)initData:(GroupChat *)chat {
    _chat = chat;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:_chat.msg_content];
    [attributeString addAttributes:[TextMessageCell attributes] range:NSMakeRange(0, attributeString.length)];
    _textView.attributedText = attributeString;
    
    __weak typeof(self) weakSelf = self;
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:chat.visitor.avatar_thumbnail.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        weakSelf.avatar.image = [image drawCircleImage];
        
    }];
}




- (UIBezierPath *)createBezierPath:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, cornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(cornerRadius + width, 0)];
    [bezierPath addArcWithCenter:CGPointMake(cornerRadius + width, cornerRadius) radius:cornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(cornerRadius+width+cornerRadius, cornerRadius+height)];
    [bezierPath addArcWithCenter:CGPointMake(cornerRadius + width, cornerRadius + height) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(cornerRadius, cornerRadius + height + cornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + height) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(0, cornerRadius)];
    
    return bezierPath;
}


+ (CGFloat)cellHeight:(GroupChat *)chat {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:chat.msg_content attributes:[self attributes]];
    
    CGSize size = [attrStr multiLineSize:MAX_USER_MSG_WIDTH];
    CGFloat height = size.height + USER_MSG_CORNER_RADIUS * 2 + COMMON_MSG_PADDING * 2;
    return height;
}





@end
