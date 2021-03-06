//
//  Constants.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//


#ifndef Constants_h
#define Constants_h

#import "UIImage+Extension.h"
#import "NSAttributedString+Extension.h"
#import "NSString+Extension.h"
#import "NSNotification+Extension.h"
#import "UIWindow+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WebCacheHelpler.h"
//UDID MD5_UDID
#define UDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define MD5_UDID [UDID md5]

#define BaseUrl @"http://116.62.9.17:8080/douyin/"
//根据用户id获取用户信息
#define FIND_USER_BY_UID_URL    @"user"
//获取用户发布的短视频列表数据
#define FIND_AWEME_POST_BY_PAGE_URL            @"aweme/post"

#define FIND_COMMENT_BY_PAGE_URL               @"comment/list"

//color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
blue:((float)(rgbValue & 0xFF)) / 255.0             \
alpha:1.0]

#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define ColorWhiteAlpha10 RGBA(255.0, 255.0, 255.0, 0.1)
#define ColorWhiteAlpha20 RGBA(255.0, 255.0, 255.0, 0.2)
#define ColorWhiteAlpha40 RGBA(255.0, 255.0, 255.0, 0.4)
#define ColorWhiteAlpha60 RGBA(255.0, 255.0, 255.0, 0.6)
#define ColorWhiteAlpha80 RGBA(255.0, 255.0, 255.0, 0.8)

#define ColorBlackAlpha1 RGBA(0.0, 0.0, 0.0, 0.01)
#define ColorBlackAlpha5 RGBA(0.0, 0.0, 0.0, 0.05)
#define ColorBlackAlpha10 RGBA(0.0, 0.0, 0.0, 0.1)
#define ColorBlackAlpha20 RGBA(0.0, 0.0, 0.0, 0.2)
#define ColorBlackAlpha40 RGBA(0.0, 0.0, 0.0, 0.4)
#define ColorBlackAlpha60 RGBA(0.0, 0.0, 0.0, 0.6)
#define ColorBlackAlpha80 RGBA(0.0, 0.0, 0.0, 0.8)
#define ColorBlackAlpha90 RGBA(0.0, 0.0, 0.0, 0.9)

#define ColorThemeGrayLight RGBA(104.0, 106.0, 120.0, 1.0)
#define ColorThemeGray RGBA(92.0, 93.0, 102.0, 1.0)
#define ColorThemeGrayDark RGBA(20.0, 21.0, 30.0, 1.0)
#define ColorThemeYellow RGBA(250.0, 206.0, 21.0, 1.0)
#define ColorThemeYellowDark RGBA(235.0, 181.0, 37.0, 1.0)
#define ColorThemeBackground RGBA(14.0, 15.0, 26.0, 1.0)

#define ColorThemeRed RGBA(241.0, 47.0, 84.0, 1.0)

#define ColorRoseRed RGBA(220.0, 46.0, 123.0, 1.0)
#define ColorClear [UIColor clearColor]
#define ColorBlack [UIColor blackColor]
#define ColorWhite [UIColor whiteColor]
#define ColorGray  [UIColor grayColor]
#define ColorBlue RGBA(40.0, 120.0, 255.0, 1.0)
#define ColorGrayLight RGBA(40.0, 40.0, 40.0, 1.0)
#define ColorGrayDark RGBA(25.0, 25.0, 35.0, 1.0)
#define ColorSmoke RGBA(230.0, 230.0, 230.0, 1.0)


//width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#define SCREEN_FRAME [UIScreen mainScreen].bounds

#define UIViewX(control) (control.frame.origin.x)
#define UIViewY(control) (control.frame.origin.y)


#define UIViewWidth(view) CGRectGetWidth(view.frame)
#define UIViewHeight(view) CGRectGetHeight(view.frame)

#define UIViewMaxX(view) CGRectGetMaxX(view.frame)
#define UIViewMaxY(view) CGRectGetMaxY(view.frame)

#define UIViewMinX(view) CGRectGetMinX(view.frame)
#define UIViewMinY(view) CGRectGetMinY(view.frame)

#define UIViewMidX(view) CGRectGetMidX(view.frame)
#define UIViewMidY(view) CGRectGetMidY(view.frame)

//Font
#define SuperSmallFont [UIFont systemFontOfSize:10.0]
#define SuperSmallBoldFont [UIFont boldSystemFontOfSize:10.0]

#define SmallFont [UIFont systemFontOfSize:12.0]
#define SmallBoldFont [UIFont boldSystemFontOfSize:12.0]

#define MediumFont [UIFont systemFontOfSize:14.0]
#define MediumBoldFont [UIFont boldSystemFontOfSize:14.0]

#define BigFont [UIFont systemFontOfSize:16.0]
#define BigBoldFont [UIFont boldSystemFontOfSize:16.0]

#define LargeFont [UIFont systemFontOfSize:18.0]
#define LargeBoldFont [UIFont boldSystemFontOfSize:18.0]

#define SuperBigFont [UIFont systemFontOfSize:26.0]
#define SuperBigBoldFont [UIFont boldSystemFontOfSize:26.0]

//获取群聊列表数据
#define FIND_GROUP_CHAT_BY_PAGE_URL            @"groupchat/list"


#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#endif /* Constants_h */
