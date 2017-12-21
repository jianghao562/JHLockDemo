
#import <UIKit/UIKit.h>
#import "JYLockView.h"
@interface JYGestureView : UIView
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;//手势提示Label
@property (weak, nonatomic) IBOutlet JYLockView *lockView;
@property(nonatomic,copy)void(^didSelectButton)(UIButton *btn);
@property(nonatomic,copy)void(^setupLabelMsg)(NSString *msg);//手势错误提示
+ (instancetype)sharedGestanceView;

@end
