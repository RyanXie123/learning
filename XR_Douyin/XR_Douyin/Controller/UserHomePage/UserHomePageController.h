//
//  UserHomePageController.h
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/10.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "BaseViewController.h"
#import "Constants.h"
@interface UserHomePageController : BaseViewController
@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, assign) NSInteger                        selectIndex;
@end
