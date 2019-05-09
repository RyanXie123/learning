//
//  EmotionSelector.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/8.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const EmotionSelectorHeight;

@protocol EmotionSelectorDelegate
@required
-(void)onDelete;
-(void)onSend;
-(void)onSelect:(NSString *)emotionKey;
@end

@interface EmotionSelector : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<EmotionSelectorDelegate> delegate;




- (void)addTextViewObserver:(UITextView *)textView;

@end

@interface EmotionCell:UICollectionViewCell
@property (nonatomic, strong) UIImageView *emotion;
@property (nonatomic, copy) NSString *emotionKey;
- (void)setDelete;
- (void)initData:(NSString *)key;
@end


