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


@interface XRDChatlistVC ()
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@end

@implementation XRDChatlistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _pageIndex = 0;
    _pageSize = 20;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarTitle:@"QSHI"];
    [self setNavigationBarTitleColor:ColorWhite];
    [self setNavigationBarBackgroundColor:ColorThemeGrayDark];
    [self setStatusBarBackgroundColor:ColorThemeGrayDark];
    
    [self loadData:_pageIndex pageSize:_pageSize];
    
}



//load data
- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    XRDGroupChatListRequest *request = [XRDGroupChatListRequest new];
    request.page = pageIndex;
    request.size = pageSize;
    
    
    [NetworkHelper getWithUrlPath:FIND_GROUP_CHAT_BY_PAGE_URL request:request success:^(id data) {
        ChatListResponse *response = [[ChatListResponse alloc]initWithDictionary:data error:nil];
        
        NSArray<GroupChat *> *array = response.data;
        
        
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)processData:(NSArray <GroupChat *> *)data {
    if (data.count == 0) {
        return;
    }
    
    
    
    
}

@end
