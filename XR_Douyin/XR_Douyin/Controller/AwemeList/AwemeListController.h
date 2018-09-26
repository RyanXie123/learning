//
//  AwemeListController.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/18.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "Aweme.h"
typedef NS_ENUM(NSUInteger, AwemeType) {
    AwemeWork        = 0,
    AwemeFavorite    = 1
};


@interface AwemeListController : BaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;


-(instancetype)initWithVideoData:(NSMutableArray<Aweme *> *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid;
@end





