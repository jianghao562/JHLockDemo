//
//  CMColor.h
//  LoanInternalPlus
//
//  Created by sandy on 2017/8/14.
//  Copyright © 2017年 捷越联合. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGBC         [UIColor clearColor]
#define RGBS(x,a)    [UIColor colorWithWhite:x/255.0f alpha:a]
#define HRGB(a)      [UIColor colorWithRGBHexString:a]
#define HRGBA(a)     [UIColor colorWithRGBAHexString:a]

#define kColor(a)      [UIColor colorWithRGBHexString:a]


#define COLOR(NAME, OBJECT) + (instancetype)NAME {\
static UIColor *_NAME;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_NAME = OBJECT;\
});\
return _NAME;\
}\

@interface UIColor (Integers)
+ (instancetype)colorWithIntegerWhite:(NSUInteger)white;
+ (instancetype)colorWithIntegerWhite:(NSUInteger)white alpha:(NSUInteger)alpha;

+ (instancetype)colorWithIntegerRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;
+ (instancetype)colorWithIntegerRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(NSUInteger)alpha;

+ (instancetype)colorWithIntegerHue:(NSUInteger)hue saturation:(NSUInteger)saturation brightness:(NSUInteger)brightness;
+ (instancetype)colorWithIntegerHue:(NSUInteger)hue saturation:(NSUInteger)saturation brightness:(NSUInteger)brightness alpha:(NSUInteger)alpha;
@end

@interface UIColor (Hex)
+ (instancetype)colorWithRGBHexValue:(NSUInteger)rgbHexValue;
+ (instancetype)colorWithRGBAHexValue:(NSUInteger)rgbaHexValue;
+ (instancetype)colorWithRGBHexString:(NSString*)rgbHexString;
+ (instancetype)colorWithRGBAHexString:(NSString*)rgbaHexString;
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;
- (NSString*)stringWithRGBHex;
- (NSString*)stringWithRGBAHex;
@end
@interface CMColor : NSObject

@end
