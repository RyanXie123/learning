//
//  PictureInfo.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseModel.h"

@interface PictureInfo : BaseModel
@property (nonatomic, copy) NSString *file_id;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy) NSString *type;
@end
