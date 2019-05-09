//
//  ChatTextView.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/8.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "ChatTextView.h"
#import "Constants.h"
#import "EmotionSelector.h"
#import "EmotionHelper.h"

#define EMOTION_TAG 1000
#define PHOTO_TAG 2000

#define LEFT_INSET 15
#define TOP_BOTTOM_INSET 15
#define RIGHT_INSET 85
@interface ChatTextView () <UITextViewDelegate,EmotionSelectorDelegate,UIGestureRecognizerDelegate>


@property (nonatomic, assign) CGFloat containerBoardHeight; //键盘高度

@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) UIButton *emotionBtn;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UILabel *placeholderLabel;


@property (nonatomic, strong) EmotionSelector *emotionSelector;


@end
@implementation ChatTextView

//在未编辑状态 不接受手势事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        if (_editMessageType == EditNoneMessage) {
            return nil;
        }
    }
    return hitView;
}


- (instancetype)init {
    return [self initWithFrame:SCREEN_FRAME];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorClear;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
        tapGestureRecognizer.delegate =self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        
        _container = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        _container.backgroundColor = ColorThemeGrayDark;
        [self addSubview:_container];
        
        _editMessageType = EditNoneMessage;
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
        _textView.backgroundColor = ColorClear;
        _textView.clipsToBounds = NO;
        _textView.textColor = ColorWhite;
        _textView.font = BigFont;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.scrollEnabled = NO;
        _textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _textView.textContainerInset = UIEdgeInsetsMake(TOP_BOTTOM_INSET, LEFT_INSET, TOP_BOTTOM_INSET, RIGHT_INSET);
        _textView.textContainer.lineFragmentPadding = 0;
        _textHeight = ceilf(_textView.font.lineHeight);
        
        
        
        
        _placeholderLabel = [UILabel new];
        _placeholderLabel.text = @"发送消息";
        _placeholderLabel.textColor = ColorGray;
        _placeholderLabel.font = BigFont;
        _placeholderLabel.frame = CGRectMake(LEFT_INSET, 0, SCREEN_WIDTH - LEFT_INSET - RIGHT_INSET, 50);
        [_textView addSubview:_placeholderLabel];
        
        _textView.delegate = self;
        [_container addSubview:_textView];
        
        
        _emotionBtn = [[UIButton alloc]init];
        _emotionBtn.tag = EMOTION_TAG;
        [_emotionBtn setImage:[UIImage imageNamed:@"baseline_emotion_white"] forState:UIControlStateNormal];
        [_emotionBtn setImage:[UIImage imageNamed:@"outline_keyboard_grey"] forState:UIControlStateSelected];
        [_emotionBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [_textView addSubview:_emotionBtn];
        
        
        _photoBtn = [[UIButton alloc]init];
        _photoBtn.tag = PHOTO_TAG;
        [_photoBtn setImage:[UIImage imageNamed:@"outline_photo_white"] forState:UIControlStateNormal];
        [_photoBtn setImage:[UIImage imageNamed:@"outline_photo_red"] forState:UIControlStateSelected];
        [_photoBtn addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)]];
        [_textView addSubview:_photoBtn];
        
        
        
        
        [self addObserver:self forKeyPath:@"containerBoardHeight" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
    }
    return self;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateContainerFrame];

    
    _photoBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50);
    _emotionBtn.frame = CGRectMake(SCREEN_WIDTH - 85, 0, 50, 50);
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.f, 10.f)];
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    [shape setPath:rounded.CGPath];
    _container.layer.mask = shape;
    
}



#pragma mark - KVO  containerBoardHeight 改变输入框的颜色
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"containerBoardHeight"]) {
        if (_containerBoardHeight == 0) {
            _container.backgroundColor = ColorThemeGrayDark;
            _textView.textColor = ColorWhite;
            [_emotionBtn setImage:[UIImage imageNamed:@"baseline_emotion_white"] forState:UIControlStateNormal];
            [_photoBtn setImage:[UIImage imageNamed:@"outline_photo_white"] forState:UIControlStateNormal];
            
        }else {
            _container.backgroundColor = ColorWhite;
            _textView.textColor = ColorBlack;
            
            [_emotionBtn setImage:[UIImage imageNamed:@"baseline_emotion_grey"] forState:UIControlStateNormal];
            [_photoBtn setImage:[UIImage imageNamed:@"outline_photo_grey"] forState:UIControlStateNormal];
        }
    }else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}






//隐藏编辑板
- (void)hideContainerBoard {
    _editMessageType = EditNoneMessage;
    self.containerBoardHeight = 0;
    [self updateContainerFrame];
    [_textView resignFirstResponder];
    [_emotionBtn setSelected:NO];
    [_photoBtn setSelected:NO];
    
}

#pragma mark - respond

//如果
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view.superview isKindOfClass:EmotionCell.class]) {
        return NO;
    }else {
        return YES;
    }

}


- (void)handleGesture: (UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    
    if (![_container.layer containsPoint:point]) {
        [self hideContainerBoard];
    }else {
        switch (sender.view.tag) {
            case EMOTION_TAG:
                [_emotionBtn setSelected:!_emotionBtn.selected];
                [_photoBtn setSelected:NO];
                if (_emotionBtn.isSelected) {
                    _editMessageType = EditEmotionMessage;
                    [self setContainerBoardHeight:EmotionSelectorHeight];
                    [self updateContainerFrame];
                    [self updateSelectorFrame:YES];
                    [_textView resignFirstResponder];
                }else {
                    _editMessageType = EditTextMessage;
                    [_textView becomeFirstResponder];
                }
                break;
            case PHOTO_TAG:
                
                break;
            default:
                break;
        }
    }
    
}


#pragma mark - keybord noti

- (void)keyboardWillShow:(NSNotification *)notification {
    _editMessageType = EditTextMessage;
    [_emotionBtn setSelected:NO];
    [_photoBtn setSelected:NO];
    
    [self setContainerBoardHeight:[notification keyboardHeight]];
    
    
    [self updateContainerFrame];
}


#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    if (!textView.hasText) {
        [_placeholderLabel setHidden:NO];
        _textHeight = ceilf(_textView.font.lineHeight);
    }else {
        [_placeholderLabel setHidden:YES];
        _textHeight = [attriStr multiLineSize:SCREEN_WIDTH - LEFT_INSET - RIGHT_INSET].height;
        
    }
    [self updateContainerFrame];
    
    
    
}



- (void)updateContainerFrame {
    CGFloat textViewHeight = _containerBoardHeight > 0 ? _textHeight + 2*TOP_BOTTOM_INSET:BigFont.lineHeight + 2*TOP_BOTTOM_INSET;
    
    _textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, textViewHeight);
    
    
    [UIView animateWithDuration:0.25
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.container.frame = CGRectMake(0, SCREEN_HEIGHT - self.containerBoardHeight - textViewHeight, SCREEN_WIDTH, self.containerBoardHeight + textViewHeight);
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)updateSelectorFrame:(BOOL)animated {
    CGFloat textViewHeight = _containerBoardHeight > 0 ? _textHeight + 2*TOP_BOTTOM_INSET:BigFont.lineHeight + 2*TOP_BOTTOM_INSET;
    if (animated) {
        switch (self.editMessageType) {
            case EditEmotionMessage:
                [self.emotionSelector setHidden:NO];
                self.emotionSelector.frame = CGRectMake(0, textViewHeight + self.containerBoardHeight, SCREEN_WIDTH, self.containerBoardHeight);
                break;
                
            default:
                break;
        }
    }
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        switch (self.editMessageType) {
            case EditEmotionMessage:
                self.emotionSelector.frame = CGRectMake(0, textViewHeight, SCREEN_WIDTH, self.containerBoardHeight);
                
                break;
                
            default:
                
                self.emotionSelector.frame = CGRectMake(0, textViewHeight + self.containerBoardHeight, SCREEN_WIDTH, self.containerBoardHeight);
                
                break;
        }
    } completion:^(BOOL finished) {
        switch (self.editMessageType) {
            case EditEmotionMessage:
                
                break;
            
            default:
                [self.emotionSelector setHidden:YES];
                
                break;
        }
    }];
    
    
}


#pragma mark - getter


- (EmotionSelector *)emotionSelector {
    if (!_emotionSelector) {
        _emotionSelector = [EmotionSelector new];
        _emotionSelector.delegate = self;
        [_emotionSelector addTextViewObserver:_textView];
        [_emotionSelector setHidden:YES];
        [_container addSubview:_emotionSelector];
    }
    return _emotionSelector;
}


-(void)onDelete {
    [_textView deleteBackward];
}
-(void)onSend {
    
}
-(void)onSelect:(NSString *)emotionKey {
    [_placeholderLabel setHidden:YES];
    
    NSInteger location = _textView.selectedRange.location;
    [_textView setAttributedText:[EmotionHelper insertEmotion:_textView.attributedText index:location emotionKey:emotionKey]];
    
    [_textView setSelectedRange:NSMakeRange(location+1, 0)];
    _textHeight = [_textView.attributedText multiLineSize:SCREEN_WIDTH - LEFT_INSET - RIGHT_INSET].height;
    
    [self updateContainerFrame];
    [self updateSelectorFrame:NO];
    
    
    
    
}

#pragma mark - show dismiss
                                          
- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"containerBoardHeight"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
