//
//  JHViewController.m
//  JHLockDemo
//
//  Created by Jiang Hao on 2017/12/21.
//  Copyright © 2017年 Jiang Hao. All rights reserved.
//

#import "JHViewController.h"
#import "JYGestureController.h"
@interface JHViewController ()
@property(nonatomic,strong)JYGestureController *gesTureVC;
@end

@implementation JHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"首页";
}
//设置
- (IBAction)gestureSetup {
    self.gesTureVC.gestureBlock(JYGestureLockTypeSetup);
    [self presentViewController:self.gesTureVC animated:YES completion:nil];
    
}
//验证
- (IBAction)gestureVertify {
     self.gesTureVC.gestureBlock(JYGestureLockTypeVerify);
     [self presentViewController:self.gesTureVC animated:YES completion:nil];
}
//修改
- (IBAction)modity {
    
  self.gesTureVC.gestureBlock(JYGestureLockTypeModify);
   [self presentViewController:self.gesTureVC animated:YES completion:nil];
}

-(JYGestureController *)gesTureVC
{
    if (!_gesTureVC) {
        _gesTureVC=[JYGestureController new];
    }
    return _gesTureVC;
}


@end
