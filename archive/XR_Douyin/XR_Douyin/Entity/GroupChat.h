//
//  GroupChat.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseModel.h"
#import "Visitor.h"
#import "PictureInfo.h"
#import <UIKit/UIKit.h>
@protocol GroupChat;
@interface GroupChat : BaseModel


@property (nonatomic , copy) NSString              *id;
@property (nonatomic , copy) NSString              *msg_type;
@property (nonatomic , copy) NSString              *msg_content;
@property (nonatomic , strong) Visitor             *visitor;
@property (nonatomic , strong) PictureInfo         *pic_original;
@property (nonatomic , strong) PictureInfo         *pic_large;
@property (nonatomic , strong) PictureInfo         *pic_medium;
@property (nonatomic , strong) PictureInfo         *pic_thumbnail;
@property (nonatomic , assign) NSInteger           create_time;

@property (nonatomic, assign) CGFloat cellHeight;

@end
