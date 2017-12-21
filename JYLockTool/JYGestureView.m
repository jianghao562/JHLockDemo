
#import "JYGestureView.h"
@interface JYGestureView ()
@property (weak, nonatomic) IBOutlet UILabel *titleMsgLabel;
@end
@implementation JYGestureView

static JYGestureView *instance = nil;
+ (instancetype)sharedGestanceView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSBundle mainBundle] loadNibNamed:@"JYGestureView" owner:self options:nil].lastObject;
    });
    return instance;
}

- (IBAction)onClickButton:(UIButton *)button {
    if (_didSelectButton) {
        _didSelectButton(button);
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleMsgLabel.text=[NSString stringWithFormat:@"欢迎您，%@",@"刘德华"];
    self.titleMsgLabel.textColor=kColor(@"3388FF");
     typeof(self) weakSelf =self;
     self.setupLabelMsg = ^(NSString *msg) {
        weakSelf.promptLabel.textColor=[UIColor redColor];
        weakSelf.promptLabel.text=msg;
        [weakSelf shakeAnimationForView:weakSelf.promptLabel];
    };
    
}


//抖动效果
 - (void)shakeAnimationForView:(UIView *) view
 {
       // 获取到当前的View
    
       CALayer *viewLayer = view.layer;
    
         // 获取当前View的位置
    
         CGPoint position = viewLayer.position;
    
         // 移动的两个终点位置
   
       CGPoint x = CGPointMake(position.x + 10, position.y);
   
         CGPoint y = CGPointMake(position.x - 10, position.y);
    
       // 设置动画
   
         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
         // 设置运动形式
    
         [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
         // 设置开始位置
    
         [animation setFromValue:[NSValue valueWithCGPoint:x]];
   
        // 设置结束位置
   
         [animation setToValue:[NSValue valueWithCGPoint:y]];
    
         // 设置自动反转
    
         [animation setAutoreverses:YES];
    
        // 设置时间
    
         [animation setDuration:.06];
   
         // 设置次数
    
        [animation setRepeatCount:3];
    
         // 添加上动画
    
         [viewLayer addAnimation:animation forKey:nil];
    
     }

@end
