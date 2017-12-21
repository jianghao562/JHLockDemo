//  JYLockButton.m
//  LockTest
//  Created by Jiang Hao on 2017/12/16.
//  Copyright © 2017年 Jiang Hao. All rights reserved.
#define touchValue 50.0f
#import "JYLockButton.h"
@implementation JYLockButton

/** 使用文件创建会调用 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initLockButton];
    }
    return self;
}

/** 使用代码创建会调用 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLockButton];
    }
    return self;
}

/** 初始化 */
- (void) initLockButton {
    // 取消交互事件（点击）
    self.userInteractionEnabled = NO;
    
    // 设置普通状态图片
    [self setBackgroundImage:[UIImage imageNamed:@"gesture_nor"] forState:UIControlStateNormal];
    
    // 设置选中状态图片
    [self setBackgroundImage:[UIImage imageNamed:@"gesture_sel"] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 可触碰范围
    CGFloat touchX = self.center.x - touchValue/2;
    CGFloat touchY = self.center.y - touchValue/2;
    self.touchFrame = CGRectMake(touchX, touchY, touchValue, touchValue);
}

@end
