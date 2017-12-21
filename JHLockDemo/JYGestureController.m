//
//  JYGestureController.m
//  LockTest
//
//  Created by Jiang Hao on 2017/12/16.
//  Copyright © 2017年 Jiang Hao. All rights reserved.
//

#import "JYGestureController.h"
#import "JYLockView.h"
#import "JYGestureView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "CoreLockConst.h"
#import "AppDelegate.h"
#import "CoreArchive.h"
@interface JYGestureController ()<JYLockViewDelegate>
@property(nonatomic,strong)JYGestureView *gestureView;
@property(nonatomic,strong)UILabel *gesturePromptLabel;//提示Label
@property(nonatomic,assign)JYGestureLockType lockType;
@end

@implementation JYGestureController
static  NSInteger gestureCount=1;//手势设置次数
static  NSString *fistPath=nil;//记录第一次手势
static  NSInteger verCount=3;//手势验证次数

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseData];
    
  
}




-(void)setupBaseData{
    self.gestureView=[JYGestureView sharedGestanceView];
    _gestureView.lockView.delegate=self;
    self.gesturePromptLabel=_gestureView.promptLabel;
    _gestureView.frame=self.view.bounds;
    [self.view addSubview:_gestureView];
    typeof(self)weakSelf = self;
    _gestureView.didSelectButton = ^(UIButton *btn) {
        if (btn.tag==10)[weakSelf onSwitchAccount];
        else[weakSelf onForgetPwd];
    };
    if (_gestureBlock) {
        _gestureBlock(_lockType);
    }
}

 //切换账号
// 先清除当前的数据再做切换
-(void)onSwitchAccount{
    [CoreArchive removeStrForKey:@"CoreLockPWDKey"];
    self.lockType=JYGestureLockTypeSetup;
    [self dismissViewControllerAnimated:YES completion:nil];
  
}

//忘记密码
//先验指纹，若指纹不支持或验证失败再验密码
-(void)onForgetPwd{
    
    [CoreArchive setStr:@"123" key:LoginPWDKey];
   [self beginValidationFingerprint];
}

#pragma 设置手势
-(void)setupGestureWithPath:(NSString *)path{
    
    fistPath=(fistPath.length==0)?path:fistPath;
    //设置成功
    if (gestureCount==2&&[path isEqualToString:fistPath]) {
        [self setupGesturePromptLabelMsg:CoreLockPWSuccessTitle];
        [CoreArchive setStr:path key:CoreLockPWDKey];
        fistPath=nil;
        gestureCount=1;
        [self dismissViewControllerAnimated:YES completion:nil];
          return;
        
    }
    //两次不一致提示
    else if(gestureCount==2&&(![path isEqualToString:fistPath])){
        self.gestureView.setupLabelMsg(CoreLockPWDDiffTitle);
        fistPath=nil;
        gestureCount=1;
        return;
    }
    
    [self setupGesturePromptLabelMsg:CoreLockPWDTitleConfirm];
    gestureCount++;
    
}

//获得顶级VC
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark - 手势结果
-(void)jy_LockView:(JYLockView *)lockView didFinishedWithPath:(NSString *)path
{
   if (!path.length)return;
    //设置的点需大于4
    if (path.length<4) {
        self.gestureView.setupLabelMsg(CoreLockMinItemMsg);
        return;
    }
    
    //手势设置
    if (_lockType==JYGestureLockTypeSetup) {
        [self setupGestureWithPath:path];
    }
    
    //手势验证
    else if (_lockType==JYGestureLockTypeVerify){
        
     NSString *pathMsg= [CoreArchive strForKey:CoreLockPWDKey];
        if ([path isEqualToString:pathMsg]) {
             [self setupGesturePromptLabelMsg:@"手势正确"];
           // JYLog(@"成功!");
            [self dismissViewControllerAnimated:YES completion:nil];
            //成功
            verCount=3;
            return;
        }
        else{
            if (verCount==0) {
               self.gestureView.setupLabelMsg(@"手势输入错误字数超限");
                [CoreArchive removeStrForKey:CoreLockPWDKey];
                [self beginValidationFingerprint];
                verCount=3;
                return;
            }
            
          self.gestureView.setupLabelMsg(CoreLockVerifyErrorPwdTitle);
            verCount--;
        }
       
        
    }
    //手势修改
    else
    {
        NSString *pathMsg= [CoreArchive strForKey:CoreLockPWDKey];
        if ([path isEqualToString:pathMsg]) {
            [self setupGesturePromptLabelMsg:@"手势正确"];
            _lockType=JYGestureLockTypeSetup;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setupGesturePromptLabelMsg:@"请绘制您的新手势解锁密码"];
            });
            verCount=3;
            return;
        }
        //旧手势错误逻辑
        else{
            if (verCount==0) {
                self.gestureView.setupLabelMsg(@"手势输入错误字数超限");
                [CoreArchive removeStrForKey:CoreLockPWDKey];
                verCount=3;
                 [self beginValidationFingerprint];
                return;
            }
            
            self.gestureView.setupLabelMsg(CoreLockVerifyErrorPwdTitle);
            verCount--;
           
            
        }
        
    
        
    }
    
//  NSLog(@"----%@",path);
    
}

#pragma mark - 指纹验证
-(void)beginValidationFingerprint{
    LAContext *context = [[LAContext alloc] init];
     WEAKSELF
        //不支持指纹
        if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showAlertView];
            });
            
        }
        
        else
        {
            
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按手指" reply:^(BOOL success, NSError * _Nullable error) {
                // 指纹正确
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf setupGesturePromptLabelMsg:CoreLockPWDTitleFirst];
                        weakSelf.lockType=JYGestureLockTypeSetup;
                        
                    });
                }
                //指纹错误
                else
                {
                    
                 if(error.code!=LAErrorUserCancel){
                   dispatch_async(dispatch_get_main_queue(), ^{
                             [weakSelf showAlertView];
                                        });
                                    }
                    
                    
                }
            }];
        }
    
}
#pragma mark - 登录密码指纹
-(void)showAlertView{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"密码验证"
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入登录密码";
        textField.clearButtonMode = UITextFieldViewModeNever;
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;
    }];
    WEAKSELF
    [alertController addAction:[UIAlertAction actionWithTitle:@"开始验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * passwordfiled = textfields.firstObject;
        NSString *logPWKey=[CoreArchive strForKey:@"LoginPWDKey"];
        if ([logPWKey isEqualToString:passwordfiled.text]) {
             [weakSelf setupGesturePromptLabelMsg:CoreLockPWDTitleFirst];
            weakSelf.lockType=JYGestureLockTypeSetup;
        }
        else{
            weakSelf.gestureView.setupLabelMsg(@"密码验证错误");
        }
        
        NSLog(@"%@",passwordfiled.text);
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    

}
//设置手势提示信息
-(void)setupGesturePromptLabelMsg:(NSString *)msg{
    self.gesturePromptLabel.textColor=kColor(@"2772FF");
    self.gesturePromptLabel.text=msg;
}


- (instancetype)init
{
    if (self = [super init]) {
         typeof(self)weakSelf = self;
        _gestureBlock = ^(JYGestureLockType lockType) {
            weakSelf.lockType=lockType;
            gestureCount=1;verCount=3;fistPath=nil;
            if (_lockType==JYGestureLockTypeSetup)
                [weakSelf setupGesturePromptLabelMsg:CoreLockPWDTitleFirst];
            else if (_lockType==JYGestureLockTypeVerify)
                [weakSelf setupGesturePromptLabelMsg:CoreLockVerifyNormalTitle];
            else if (_lockType==JYGestureLockTypeModify)
                [weakSelf setupGesturePromptLabelMsg:CoreLockModifyNormalTitle];
            
        };
    }
    return self;
}




@end
