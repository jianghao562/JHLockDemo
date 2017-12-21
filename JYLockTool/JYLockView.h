//  JYLockView.h
//  Created by by Jiang Hao on 2017/12/16.
//  Copyright © 2017年 Jiang Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYLockView;
@protocol JYLockViewDelegate <NSObject>

/** 结束手势解锁代理事件 */
@optional
- (void) jy_LockView:(JYLockView *) lockView didFinishedWithPath:(NSString *) path;

@end

@interface JYLockView : UIView

/** 代理 */
@property(nonatomic, weak) IBOutlet id<JYLockViewDelegate> delegate;

@end
