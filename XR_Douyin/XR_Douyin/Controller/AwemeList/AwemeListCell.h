//
//  AwemeListCell.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/18.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Aweme.h"
#import "AVPlayerView.h"


typedef void (^OnPlayerReady)(void);


@interface AwemeListCell : UITableViewCell


@property (nonatomic, strong) AVPlayerView   *playerView;
@property (nonatomic, strong) Aweme *aweme;
@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, assign) BOOL             isPlayerReady;

@property (nonatomic, strong) UIImageView *comment;
@property (nonatomic, strong) UILabel *commentNum;



- (void)initData:(Aweme *)aweme;

-(void)play;

-(void)pause;

-(void)replay;
@end


