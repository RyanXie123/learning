//
//  AwemeListCell.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/18.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "AwemeListCell.h"
#import "Constants.h"
#import <Masonry.h>
#import "CommentsPopView.h"


#define COMMENT_TAP_ACTION 3000



@interface AwemeListCell ()<AVPlayerUpdateDelegate>
@property (nonatomic, strong) UIView *container;


@end

@implementation AwemeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorBlackAlpha1;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _playerView = [AVPlayerView new];
    _playerView.delegate = self;
    [self.contentView addSubview:_playerView];
    
    //init hover on player view container
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    
    
    _comment = [[UIImageView alloc]init];
    _comment.contentMode = UIViewContentModeCenter;
    _comment.image = [UIImage imageNamed:@"icon_home_comment"];
    _comment.userInteractionEnabled = YES;
    _comment.tag = COMMENT_TAP_ACTION;
    [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [_container addSubview:_comment];
    
    _commentNum = [[UILabel alloc]init];
    _commentNum.text = @"0";
    _commentNum.textColor = ColorWhite;
    _commentNum.font = SmallFont;
    [_container addSubview:_commentNum];
}


- (void)prepareForReuse {
    [super prepareForReuse];
    _isPlayerReady = NO;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerView.frame = self.bounds;
    _container.frame = self.bounds;
    
    
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.share.mas_top).inset(25);
        make.bottom.equalTo(self).inset(100);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom);
        make.centerX.equalTo(self.comment);
    }];
}


- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case COMMENT_TAP_ACTION: {
            CommentsPopView *popView = [[CommentsPopView alloc]initWithAwemeId:_aweme.aweme_id];
            [popView show];
            break;
        }
        default:
            break;
    }
}



- (void)initData:(Aweme *)aweme {
    _aweme = aweme;
    [_playerView setPlayerWithUrl:aweme.video.play_addr.url_list.firstObject];
    
    
}

// AVPlayerUpdateDelegate
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
//            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
//            [self startLoadingPlayItemAnim:NO];
            
            self.isPlayerReady = YES;
//            [self.musicAlum startAnimation:_aweme.rate];
            
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
//            [self startLoadingPlayItemAnim:NO];
            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}

-(void)play {
    [_playerView play];
}

-(void)pause {
    [_playerView pause];
}

-(void)replay {
    [_playerView replay];
}

- (void)dealloc {
    _playerView = nil;
}
@end
