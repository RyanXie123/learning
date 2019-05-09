//
//  CommentsPopView.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/25.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "CommentsPopView.h"
#import "Constants.h"
#import "CommentListRequest.h"
#import "CommentListResponse.h"
#import "NetworkHelper.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+Extension.h"
#import "NSString+Extension.h"
#import "LoadMoreControl.h"

//#import ""

@interface CommentsPopView ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *awemeId;
@property (nonatomic, strong) UIView *container;


@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray<Comment *> *data;

@property (nonatomic, strong) LoadMoreControl *loadMore;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommentTextView *textView;
@end


@implementation CommentsPopView

- (instancetype)initWithAwemeId:(NSString *)awemeId {
    self = [super init];
    if (self) {
        self.frame = SCREEN_FRAME;
        _awemeId = awemeId;
        _pageSize = 20;
        _pageIndex = 0;
        _data = [NSMutableArray array];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesuture:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        _container = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 3/4)];
        _container.backgroundColor = ColorBlackAlpha60;
        [self addSubview:_container];
        
        
        //添加圆角
        UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 3/4) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight  cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.path = rounded.CGPath;
        _container.layer.mask = shapeLayer;
        
        
        //添加黑底效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.alpha = 1.0f;
        visualEffectView.frame = _container.bounds;
        [_container addSubview:visualEffectView];
        
        
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, SCREEN_HEIGHT*3/4 - 35 - 50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ColorClear;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:CommentListCell.class forCellReuseIdentifier:NSStringFromClass(CommentListCell.class)];
        [_container addSubview:_tableView];
        
        [self loadData:_pageIndex pageSize:_pageSize];
        
        _loadMore = [[LoadMoreControl alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50) surplusCount:10];
        [_loadMore startLoading];
        __weak __typeof(self) wself = self;
        [_loadMore setOnLoad:^{
            [wself loadData:wself.pageIndex pageSize:wself.pageSize];
        }];
        [_tableView addSubview:_loadMore];
        
        _textView = [[CommentTextView alloc]init];
        
        
    }
    return self;
}

- (void)handleGesuture:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:_container];
    if (![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    
    
}



- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    CommentListRequest *request = [CommentListRequest new];
    request.page = pageIndex;
    request.size = pageSize;
    request.aweme_id = _awemeId;
    __weak __typeof(self) wself = self;
    [NetworkHelper getWithUrlPath:FIND_COMMENT_BY_PAGE_URL request:request success:^(id data) {
        CommentListResponse *response = [[CommentListResponse alloc]initWithDictionary:data error:nil];
        NSArray <Comment *>*array = response.data;
        wself.pageIndex++;
        [UIView setAnimationsEnabled:NO];
        [wself.tableView beginUpdates];
        [wself.data addObjectsFromArray:array];
        
        NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray array];
        
        for (NSInteger row = wself.data.count - array.count; row < wself.data.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPaths addObject:indexPath];
        }
        [wself.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [wself.tableView endUpdates];
        [UIView setAnimationsEnabled:YES];
        
        [wself.loadMore endLoading];
        if (!response.has_more) {
            [wself.loadMore loadingAll];
        }
        
    } failure:^(NSError *error) {
        [wself.loadMore loadingFailed];
    }];
//    request.page =
}



#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CommentListCell cellHeight:_data[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CommentListCell.class) forIndexPath:indexPath];
    [cell initData:_data[indexPath.row]];
    return cell;
}


#pragma mark - show/dismiss
- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate]window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y - frame.size.height;
        self.container.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    [_textView show];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        self.container.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.textView dismiss];
    }];
}



@end


#define MAX_CONTENT_WIDTH SCREEN_WIDTH - 55 - 35

@implementation CommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorClear;
        self.clipsToBounds = YES;
        
        _avatar = [[UIImageView alloc] init];
        _avatar.image = [UIImage imageNamed:@"img_find_default"];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 14;
        [self addSubview:_avatar];
        
        _likeIcon = [[UIImageView alloc] init];
        _likeIcon.contentMode = UIViewContentModeCenter;
        _likeIcon.image = [UIImage imageNamed:@"icCommentLikeBefore_black"];
        [self addSubview:_likeIcon];
        
        _nickName = [[UILabel alloc] init];
        _nickName.numberOfLines = 1;
        _nickName.textColor = ColorWhiteAlpha60;
        _nickName.font = SmallFont;
        [self addSubview:_nickName];
        
        _content = [[UILabel alloc] init];
        _content.numberOfLines = 0;
        _content.textColor = ColorWhiteAlpha80;
        _content.font = MediumFont;
        [self addSubview:_content];
        
        _date = [[UILabel alloc] init];
        _date.numberOfLines = 1;
        _date.textColor = ColorGray;
        _date.font = SmallFont;
        [self addSubview:_date];
        
        _likeNum = [[UILabel alloc] init];
        _likeNum.numberOfLines = 1;
        _likeNum.textColor = ColorGray;
        _likeNum.font = SmallFont;
        [self addSubview:_likeNum];
        
        _splitLine = [[UIView alloc] init];
        _splitLine.backgroundColor = ColorWhiteAlpha10;
        [self addSubview:_splitLine];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).inset(15);
        make.width.height.mas_equalTo(28);
    }];
    [_likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self).inset(15);
        make.width.height.mas_equalTo(20);
    }];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.avatar.mas_right).offset(10);
        make.right.equalTo(self.likeIcon.mas_left).inset(25);
    }];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickName.mas_bottom).offset(5);
        make.left.equalTo(self.nickName);
        make.width.mas_lessThanOrEqualTo(MAX_CONTENT_WIDTH);
    }];
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(5);
        make.left.right.equalTo(self.nickName);
    }];
    [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.likeIcon);
        make.top.equalTo(self.likeIcon.mas_bottom).offset(5);
    }];
    [_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date);
        make.right.equalTo(self.likeIcon);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)initData:(Comment *)comment {
    NSURL *avatarUrl;
    if([@"user" isEqualToString:comment.user_type]) {
        avatarUrl = [NSURL URLWithString:comment.user.avatar_thumb.url_list.firstObject];
        _nickName.text = comment.user.nickname;
    }else {
        avatarUrl = [NSURL URLWithString:comment.visitor.avatar_thumbnail.url];
//        _nickName.text = [comment.visitor formatUDID];
    }
    
    __weak __typeof(self) wself = self;
    
    [_avatar sd_setImageWithURL:avatarUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        image = [image drawCircleImage];
        wself.avatar.image = image;
    }];
    
//    [_avatar setImageWithURL:avatarUrl progressBlock:^(CGFloat persent) {
//    } completedBlock:^(UIImage *image, NSError *error) {
//        image = [image drawCircleImage];
//        wself.avatar.image = image;
//    }];
    _content.text = comment.text;
    _date.text = [NSDate formatTime:comment.create_time];
    _likeNum.text = [NSString formatCount:comment.digg_count];
}





+ (CGFloat)cellHeight:(Comment *)comment {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comment.text];
    [attributedString addAttribute:NSFontAttributeName value:MediumFont range:NSMakeRange(0, attributedString.length)];
    CGSize size = [attributedString multiLineSize:MAX_CONTENT_WIDTH];
    return size.height + 30 + 30;
}


@end


#define LEFT_INSET                 15
#define RIGHT_INSET                60
#define TOP_BOTTOM_INSET           15

@interface CommentTextView ()<UITextViewDelegate>
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIImageView *atImageView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end



@implementation CommentTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = SCREEN_FRAME;
        self.backgroundColor = ColorClear;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        
        
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = ColorBlackAlpha40;
        
        _textView.clipsToBounds = NO;
        _textView.textColor = ColorWhite;
        _textView.font = BigFont;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.scrollEnabled = NO;
        _textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _textView.textContainerInset = UIEdgeInsetsMake(TOP_BOTTOM_INSET, LEFT_INSET, TOP_BOTTOM_INSET, RIGHT_INSET);
        _textHeight = ceilf(_textView.font.lineHeight);
        
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.text = @"有爱评论，说点儿好听的~";
        _placeHolderLabel.textColor = ColorGray;
        _placeHolderLabel.font = BigFont;
        _placeHolderLabel.frame = CGRectMake(LEFT_INSET, 0, SCREEN_WIDTH - LEFT_INSET - RIGHT_INSET, 50);
        [_textView addSubview:_placeHolderLabel];
        
        
        _atImageView = [[UIImageView alloc] init];
        _atImageView.contentMode = UIViewContentModeCenter;
        _atImageView.image = [UIImage imageNamed:@"iconWhiteaBefore"];
        [_textView addSubview:_atImageView];
        [self addSubview:_textView];
        
        _textView.delegate = self;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil
         ];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _atImageView.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50);
    [self updateTextViewFrame];
    
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = rounded.CGPath;
    _textView.layer.mask = shape;
    
}


- (void)updateTextViewFrame {
    CGFloat textViewHeight = _keyboardHeight > 0 ? _textHeight + 2 * TOP_BOTTOM_INSET: ceilf(_textView.font.lineHeight) + 2 * TOP_BOTTOM_INSET;
    _textView.frame = CGRectMake(0, SCREEN_HEIGHT - _keyboardHeight - textViewHeight, SCREEN_WIDTH, textViewHeight);
    
}


- (void)textViewDidChange:(UITextView *)textView {
    if (!textView.hasText) {
        _placeHolderLabel.hidden = NO;
        _textHeight = ceilf(_textView.font.lineHeight);
    }else {
        _placeHolderLabel.hidden = YES;
        
        _textHeight = [textView.attributedText multiLineSize:SCREEN_WIDTH - LEFT_INSET - RIGHT_INSET].height;
    }
     [self updateTextViewFrame];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    _keyboardHeight = [notification keyboardHeight];
    [self updateTextViewFrame];
    _atImageView.image = [UIImage imageNamed:@"iconBlackaBefore"];
    _textView.backgroundColor = ColorWhite;
    _textView.textColor = ColorBlack;
    self.backgroundColor = ColorBlackAlpha60;
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardHeight = 0;
    [self updateTextViewFrame];
    _atImageView.image = [UIImage imageNamed:@"iconWhiteaBefore"];
    _textView.backgroundColor = ColorBlackAlpha40;
    _textView.textColor = ColorWhite;
    self.backgroundColor = ColorClear;
}


- (void)handleGuesture:(UIGestureRecognizer *)ges {
    CGPoint point = [ges locationInView:_textView];
    if (![_textView.layer containsPoint:point]) {
        [_textView resignFirstResponder];
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        if (hitView.backgroundColor == ColorClear) {
            return nil;
        }
    }
    return hitView;
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
