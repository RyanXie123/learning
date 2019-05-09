//
//  ChatTextView.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/8.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ChatEditMessageType) {
    EditTextMessage,
    EditPhotoMessage,
    EditEmotionMessage,
    EditNoneMessage
};



@protocol ChatTextViewDelegate
@required
- (void)onSendText:(NSString *)text;
- (void)onSendImages:(NSMutableArray <UIImage *> *)images;
- (void)onEditBoardHeightChange:(CGFloat)height;

@end

@interface ChatTextView : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) ChatEditMessageType editMessageType;

- (void)show;
- (void)dismiss;
@end
