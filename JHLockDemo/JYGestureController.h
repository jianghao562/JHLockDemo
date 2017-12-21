//
//  JYGestureController.h
//  LockTest
//
//  Created by Jiang Hao on 2017/12/16.
//  Copyright © 2017年 Jiang Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JYGestureController : UIViewController
@property(nonatomic,copy) void(^gestureBlock)(JYGestureLockType lockType);//1.设置 2.验证 3.修改
@end

