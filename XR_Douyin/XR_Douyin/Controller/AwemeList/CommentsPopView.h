//
//  CommentsPopView.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/25.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentsPopView : UIView
- (instancetype)initWithAwemeId:(NSString *)awemeId;
- (void)show;
@end




@interface CommentListCell : UITableViewCell
@property (nonatomic, strong) UIImageView        *avatar;
@property (nonatomic, strong) UIImageView        *likeIcon;
@property (nonatomic, strong) UILabel            *nickName;
@property (nonatomic, strong) UILabel            *extraTag;
@property (nonatomic, strong) UILabel            *content;
@property (nonatomic, strong) UILabel            *likeNum;
@property (nonatomic, strong) UILabel            *date;
@property (nonatomic, strong) UIView             *splitLine;
-(void)initData:(Comment *)comment;
+(CGFloat)cellHeight:(Comment *)comment;
@end


NS_ASSUME_NONNULL_END
