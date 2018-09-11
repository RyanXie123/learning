//
//  XRDChatlistVC.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "XRDChatlistVC.h"
#import "XRDGroupChatListRequest.h"
#import "NetworkHelper.h"
#import "ChatListResponse.h"
#import "TextMessageCell.h"
#import "RefreshControl.h"
#import "ChatTextView.h"


@interface XRDChatlistVC ()<UITableViewDataSource,UITableViewDelegate>



@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray<GroupChat *> *data;
@property (nonatomic, strong) ChatTextView *textView;

@property (nonatomic, strong) RefreshControl *refreshControl;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XRDChatlistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _data = [NSMutableArray array];
    _pageIndex = 0;
    _pageSize = 20;
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [self navagationBarHeight]+STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - ([self navagationBarHeight]+STATUS_BAR_HEIGHT)-10) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = ColorClear;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceVertical = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[TextMessageCell class] forCellReuseIdentifier:NSStringFromClass(TextMessageCell.class)];
    
    if (@available(iOS 11.0,*)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_tableView];
    
    _refreshControl = [RefreshControl new];
    __weak typeof(self) weakSelf =self;
    [_refreshControl setOnRefreshBlock:^{
        [weakSelf loadData:weakSelf.pageIndex pageSize:weakSelf.pageSize];
    }];
    [_tableView addSubview:_refreshControl];
    
    _textView = [ChatTextView new];
    
    
    
    
    [self loadData:_pageIndex pageSize:_pageSize];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarTitle:@"QSHI"];
    [self setNavigationBarTitleColor:ColorWhite];
    [self setNavigationBarBackgroundColor:ColorThemeGrayDark];
    [self setStatusBarBackgroundColor:ColorThemeGrayDark];
    
    
    [_textView show];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupChat *chat = _data[indexPath.row];
    return chat.cellHeight;
//    return <#expression#>
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TextMessageCell.class)];
    GroupChat *chatData = _data[indexPath.row];
    [cell initData:chatData];
    return cell;
}


//load data
- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    XRDGroupChatListRequest *request = [XRDGroupChatListRequest new];
    request.page = pageIndex;
    request.size = pageSize;
    
    __weak typeof(self) weakSelf = self;
    [NetworkHelper getWithUrlPath:FIND_GROUP_CHAT_BY_PAGE_URL request:request success:^(id data) {
        ChatListResponse *response = [[ChatListResponse alloc]initWithDictionary:data error:nil];
        
        NSArray<GroupChat *> *array = response.data;
        
        NSInteger preCount = weakSelf.data.count;
        
        [UIView setAnimationsEnabled:NO];
        [weakSelf processData:array];
    
        NSInteger curCount = weakSelf.data.count;
        

        if (weakSelf.pageIndex++ == 0 || preCount == 0) {
            [weakSelf scrollToBottom];
        }else {
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:curCount - preCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        [weakSelf.refreshControl endRefresh];
        if (!response.has_more) {
            [weakSelf.refreshControl loadAll];
        }
        [UIView setAnimationsEnabled:YES];
        
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefresh];
    }];
    
}

- (void)processData:(NSArray <GroupChat *> *)data {
    if (data.count == 0) {
        return;
    }
    //test 先显示文字信息
    NSMutableArray *tempArray = [NSMutableArray array];
    for (GroupChat *chat in data) {
        if ([chat.msg_type isEqualToString:@"text"]) {
            chat.cellHeight = [TextMessageCell cellHeight:chat];
            [tempArray addObject:chat];
            
        }
    }
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempArray count])];
    [self.data insertObjects:tempArray atIndexes:indexes];
    [self.tableView reloadData];
}



- (void)scrollToBottom {
    if (self.data.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}







@end
