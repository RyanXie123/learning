//
//  Constants.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//


#ifndef Constants_h
#define Constants_h



#define BaseUrl @"http://116.62.9.17:8080/douyin/"
#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define ColorThemeGrayDark RGBA(20.0, 21.0, 30.0, 1.0)
#define ColorWhite [UIColor whiteColor]
#define ColorThemeBackground RGBA(14.0, 15.0, 26.0, 1.0)

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


//获取群聊列表数据
#define FIND_GROUP_CHAT_BY_PAGE_URL            @"groupchat/list"


#endif /* Constants_h */
