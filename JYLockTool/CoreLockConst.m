
#ifndef _CoreLockConst_H_
#define _CoreLockConst_H_

#import <UIKit/UIKit.h>

/** 选中圆大小比例 */
//const CGFloat CoreLockArcWHR = .3f;
const CGFloat CoreLockArcWHR = .98f;


/** 选中圆大小的线宽 */
const CGFloat CoreLockArcLineW = 1.0f;


/** 密码存储Key */
NSString *const CoreLockPWDKey = @"CoreLockPWDKey";
/** 登录密码存储Key */
NSString *const LoginPWDKey = @"LoginPWDKey";


/*
 *  设置密码
 */


/** 最低设置密码数目 */
const NSUInteger CoreLockMinItemCount = 4;
/** 最低设置密码数目提示 */
NSString * const CoreLockMinItemMsg =@"请连接至少4个点";
/** 设置密码提示文字 */
NSString *const CoreLockPWDTitleFirst = @"请绘制您的手势密码解锁";



/** 设置密码提示文字：确认 */
NSString *const CoreLockPWDTitleConfirm = @"请再次输入确认手势";


/** 设置密码提示文字：再次密码不一致 */
NSString *const CoreLockPWDDiffTitle = @"再次手势输入不一致";

/** 设置密码提示文字：设置成功 */
NSString *const CoreLockPWSuccessTitle = @"手势设置成功！";


/*
 *  验证密码
 */

/** 验证密码：普通提示文字 */
NSString *const CoreLockVerifyNormalTitle = @"请滑动手势解锁";


/** 验证密码：密码错误 */
NSString *const CoreLockVerifyErrorPwdTitle = @"输入手势错误";


/** 验证密码：验证成功 */
NSString *const CoreLockVerifySuccesslTitle = @"手势正确";


/*
 *  修改密码
 */
/** 修改密码：普通提示文字 */
NSString *const CoreLockModifyNormalTitle = @"请输入旧手势";




#endif
