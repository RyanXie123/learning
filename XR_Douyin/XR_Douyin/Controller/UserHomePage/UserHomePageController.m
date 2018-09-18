//
//  UserHomePageController.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/10.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "UserHomePageController.h"
#import "NetworkHelper.h"
#import "UserRequest.h"
#import "UserResponse.h"
#import "UserInfoHeader.h"
#import "XRDChatlistVC.h"
#import "AwemeListRequest.h"
#import "AwemeListResponse.h"
#import "AwemeCollectoinCell.h"
#import "LoadMoreControl.h"
#define USER_INFO_HEADER_HEIGHT 340 + STATUS_BAR_HEIGHT




@interface UserHomePageController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UserInfoDelegate>

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray<Aweme *> *workAwemes;
@property (nonatomic, strong) UserInfoHeader *userInfoHeader;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, strong) LoadMoreControl *loadMore;
@end

@implementation UserHomePageController

- (instancetype)init {
    if (self = [super init]) {
        _uid = @"97795069353";
        _workAwemes = [[NSMutableArray alloc]init];
        _pageSize = 21;
        _pageIndex = 0;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNetworkStatusChagned:) name:NetworkStatusChangeNotification object:nil];
}


- (void)initCollectionView {
    _itemWidth = (SCREEN_WIDTH - (CGFloat)(((NSInteger)(SCREEN_WIDTH)) % 3) ) / 3.0f - 1.0f;
    _itemHeight = _itemWidth * 1.3f;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(_itemWidth, _itemHeight);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:SCREEN_FRAME collectionViewLayout:layout];
    _collectionView.backgroundColor = ColorClear;
    if (@available(iOS 11.0,*)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    [_collectionView registerClass:UserInfoHeader.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UserInfoHeader.class)];
    [_collectionView registerClass:AwemeCollectoinCell.class forCellWithReuseIdentifier:NSStringFromClass(AwemeCollectoinCell.class)];
    
    [self.view addSubview:_collectionView];
    
    _loadMore = [[LoadMoreControl alloc]initWithFrame:CGRectMake(0, USER_INFO_HEADER_HEIGHT, SCREEN_WIDTH, 50) surplusCount:15];
    [_loadMore startLoading];
    __weak __typeof(self) wself = self;
    [_loadMore setOnLoad:^{
        [wself loadData:wself.pageIndex pageSize:wself.pageSize];
    }];
    [_collectionView addSubview:_loadMore];
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            UserInfoHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UserInfoHeader.class) forIndexPath:indexPath];
            if(_user) {
                [header initData:_user];
                header.delegate = self;
            }
            _userInfoHeader = header;
            return header;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return _workAwemes.count;
    }else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AwemeCollectoinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(AwemeCollectoinCell.class) forIndexPath:indexPath];
    Aweme *aweme;
    aweme = [_workAwemes objectAtIndex:indexPath.row];
    [cell initData:aweme];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return CGSizeMake(SCREEN_WIDTH, )
//    }else {
//        return CGSizeZero;
//    }
//
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, USER_INFO_HEADER_HEIGHT);
    }else {
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(_itemWidth, _itemHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarTitleColor:ColorClear];
    [self setNavigationBarBackgroundColor:ColorClear];
    [self setStatusBarBackgroundColor:ColorClear];
    [self setStatusBarHidden:NO];
}

- (void)onNetworkStatusChagned:(NSNotification *)noti {
    if ([NetworkHelper networkStatus] != AFNetworkReachabilityStatusNotReachable) {
        if (!_user) {
            [self loadUserData];
        }
        [self loadData:_pageIndex pageSize:_pageSize];
    }
}


- (void)loadUserData {
    __weak typeof(self) weakSelf = self;
    UserRequest *request = [UserRequest new];
    request.uid = _uid;
    
    [NetworkHelper getWithUrlPath:FIND_USER_BY_UID_URL request:request success:^(id data) {
        UserResponse *response = [[UserResponse alloc]initWithDictionary:data error:nil];
        weakSelf.user = response.data;
        [weakSelf setTitle:weakSelf.user.nickname];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [UIWindow showTips:error.description];
    }];
    
}

- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    AwemeListRequest *request = [AwemeListRequest new];
    request.page = pageIndex;
    request.size = pageSize;
    request.uid = _uid;
    
    __weak typeof(self) wSelf = self;
    [NetworkHelper getWithUrlPath:FIND_AWEME_POST_BY_PAGE_URL request:request success:^(id data) {
        AwemeListResponse *response = [[AwemeListResponse alloc] initWithDictionary:data error:nil];
    
        NSArray<Aweme *> *array = response.data;
        wSelf.pageIndex++;
        
        [UIView setAnimationsEnabled:NO];
        [wSelf.collectionView performBatchUpdates:^{
            [wSelf.workAwemes addObjectsFromArray:array];
            NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
            for(NSInteger row = wSelf.workAwemes.count - array.count; row<wSelf.workAwemes.count; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                [indexPaths addObject:indexPath];
            }
            [wSelf.collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            [UIView setAnimationsEnabled:YES];
        }];
        [wSelf.loadMore endLoading];
        if (!response.has_more) {
            [wSelf.loadMore loadingAll];
        }
        
        
    } failure:^(NSError *error) {
        [wSelf.loadMore loadingFailed];
    }];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY < 0) {
        [_userInfoHeader overScrollAction:contentOffsetY];
    }else {
        
    }
    
}


- (void)onUserActionTap:(NSInteger)tag {
    switch (tag) {
    case SEND_MESSAGE_TAG:
        [self.navigationController pushViewController:[[XRDChatlistVC alloc] init] animated:YES];
        break;
        case FOCUS_CANCEL_TAG:
        case FOCUS_TAG:
            if (_userInfoHeader) {
                [_userInfoHeader startFocusAnimation];
            }
            break;
            
        default:
            break;
    }
}


@end
