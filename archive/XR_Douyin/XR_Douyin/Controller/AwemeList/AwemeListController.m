//
//  AwemeListController.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/18.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "AwemeListController.h"
#import "AwemeListCell.h"
#import "AVPlayerManager.h"

@interface AwemeListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger                         pageIndex;
@property (nonatomic, assign) NSInteger                         pageSize;
@property (nonatomic, assign) AwemeType                         awemeType;
@property (nonatomic, copy) NSString                            *uid;
@property (nonatomic, strong) NSMutableArray<Aweme *>           *data;
@property (nonatomic, strong) NSMutableArray<Aweme *>           *awemes;
@end

@implementation AwemeListController

- (instancetype)initWithVideoData:(NSMutableArray<Aweme *> *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid {
    self = [super init];
    if (self) {
        _currentIndex = currentIndex;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _awemeType = type;
        _uid = uid;
        
        _awemes = [data mutableCopy];
        _data = [[NSMutableArray alloc] initWithObjects:[_awemes objectAtIndex:_currentIndex], nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundImage:@"img_video_loading"];
    [self setUpView];
    [self setLeftButton:@"icon_titlebar_whiteback"];
}


- (void)setUpView {
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableView.backgroundColor = ColorClear;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [_tableView registerClass:AwemeListCell.class forCellReuseIdentifier:NSStringFromClass(AwemeListCell.class)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.tableView];
        self.data = self.awemes;
        [self.tableView reloadData];
        
        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    });
    
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
//        _isCurPlayerPause = NO;
        //获取当前显示的cell
        AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        __weak typeof (cell) wcell = cell;
        __weak typeof (self) wself = self;
        //判断当前cell的视频源是否已经准备播放
        if(cell.isPlayerReady) {
            //播放视频
            [cell replay];
        }else {
            [[AVPlayerManager shareManager] pauseAll];
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等带视频准备好后通知播放
            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                if(indexPath && indexPath.row == wself.currentIndex) {
                    [wcell play];
                }
            };
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark -  tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AwemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AwemeListCell.class)];
//    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor greenColor] : [UIColor yellowColor];
    [cell initData:[_data objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    //为啥异步在主线程 ？？？
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatePoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        scrollView.panGestureRecognizer.enabled = NO;
        if (translatePoint.y < -50 && self.currentIndex < (self.data.count - 1)) {
            self.currentIndex ++;
        }

        if (translatePoint.y > 50 && self.currentIndex > 1) {
            self.currentIndex --;
        }

        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } completion:^(BOOL finished) {
            scrollView.panGestureRecognizer.enabled = YES;
        }];
    });
    
    
}



@end
