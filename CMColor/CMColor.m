//
//  CMColor.m
//  LoanInternalPlus
//
//  Created by sandy on 2017/8/14.
//  Copyright © 2017年 捷越联合. All rights reserved.
//

#import "CMColor.h"

static const CGFloat redDivisor = 255;
static const CGFloat greenDivisor = 255;
static const CGFloat blueDivisor = 255;

static const CGFloat hueDivisor = 360;
static const CGFloat saturationDivisor = 100;
static const CGFloat brightnessDivisor = 100;

static const CGFloat whiteDivisor = 100;
static const CGFloat alphaDivisor = 100;

#define ADD_RED_MASK        0xFF0000
#define ADD_GREEN_MASK      0xFF00
#define ADD_BLUE_MASK       0xFF
#define ADD_ALPHA_MASK      0xFF000000
#define ADD_COLOR_SIZE      255.0
#define ADD_RED_SHIFT       16
#define ADD_GREEN_SHIFT     8
#define ADD_BLUE_SHIFT      0
#define ADD_ALPHA_SHIFT     24


@implementation UIColor (Integers)

#pragma mark --
#pragma mark Grayscale
+ (instancetype)colorWithIntegerWhite:(NSUInteger)white
{
    return [self colorWithIntegerWhite:white
                                 alpha:alphaDivisor];
}

+ (instancetype)colorWithIntegerWhite:(NSUInteger)white alpha:(NSUInteger)alpha
{
    return [self colorWithWhite:white/whiteDivisor
                          alpha:alpha/alphaDivisor];
}


#pragma mark --
#pragma mark RGB
+ (instancetype)colorWithIntegerRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue
{
    return [self colorWithIntegerRed:red
                               green:green
                                blue:blue
                               alpha:alphaDivisor];
}

+ (instancetype)colorWithIntegerRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(NSUInteger)alpha
{
    return [self colorWithRed:red/redDivisor
                        green:green/greenDivisor
                         blue:blue/blueDivisor
                        alpha:alpha/alphaDivisor];
}


#pragma mark --
#pragma mark HSB
+ (instancetype)colorWithIntegerHue:(NSUInteger)hue saturation:(NSUInteger)saturation brightness:(NSUInteger)brightness
{
    return [self colorWithIntegerHue:hue
                          saturation:saturation
                          brightness:brightness
                               alpha:alphaDivisor];
}

+ (instancetype)colorWithIntegerHue:(NSUInteger)hue saturation:(NSUInteger)saturation brightness:(NSUInteger)brightness alpha:(NSUInteger)alpha
{
    return [self colorWithHue:hue/hueDivisor
                   saturation:saturation/saturationDivisor
                   brightness:brightness/brightnessDivisor
                        alpha:alpha/alphaDivisor];
}
@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIColor (Hex)
+ (instancetype)colorWithRGBHexValue:(NSUInteger)rgbHexValue
{
    return [UIColor colorWithRed:((CGFloat)((rgbHexValue & ADD_RED_MASK) >> ADD_RED_SHIFT))/ADD_COLOR_SIZE
                           green:((CGFloat)((rgbHexValue & ADD_GREEN_MASK) >> ADD_GREEN_SHIFT))/ADD_COLOR_SIZE
                            blue:((CGFloat)((rgbHexValue & ADD_BLUE_MASK) >> ADD_BLUE_SHIFT))/ADD_COLOR_SIZE
                           alpha:1.0];
}

+ (instancetype)colorWithRGBAHexValue:(NSUInteger)rgbaHexValue
{
    return [UIColor colorWithRed:((CGFloat)((rgbaHexValue & ADD_RED_MASK) >> ADD_RED_SHIFT))/ADD_COLOR_SIZE
                           green:((CGFloat)((rgbaHexValue & ADD_GREEN_MASK) >> ADD_GREEN_SHIFT))/ADD_COLOR_SIZE
                            blue:((CGFloat)((rgbaHexValue & ADD_BLUE_MASK) >> ADD_BLUE_SHIFT))/ADD_COLOR_SIZE
                           alpha:((CGFloat)((rgbaHexValue & ADD_ALPHA_MASK) >> ADD_ALPHA_SHIFT))/ADD_COLOR_SIZE];
}

+ (instancetype)colorWithRGBHexString:(NSString*)rgbHexString
{
    NSUInteger rgbHexValue;
    
    NSScanner* scanner = [NSScanner scannerWithString:rgbHexString];
    BOOL successful = [scanner scanHexInt:(unsigned *)&rgbHexValue];
    
    if (!successful)
        return nil;
    
    return [self colorWithRGBHexValue:rgbHexValue];
}

+ (instancetype)colorWithRGBAHexString:(NSString*)rgbaHexString
{
    NSUInteger rgbHexValue;
    
    NSScanner *scanner = [NSScanner scannerWithString:rgbaHexString];
    BOOL successful = [scanner scanHexInt:(unsigned *)&rgbHexValue];
    
    if (!successful)
        return nil;
    
    return [self colorWithRGBAHexValue:rgbHexValue];
}
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString {
    if ([hexColorString length] <6) {//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]) {//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"]) {//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6) {
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    return [UIColor colorWithRed:((float) r /255.0f)
                           green:((float) g /255.0f)
                            blue:((float) b /255.0f)
                           alpha:1.0f];
}

- (BOOL)getRGBHexValue:(NSUInteger*)rgbHex
{
    size_t numComponents = CGColorGetNumberOfComponents(self.CGColor);
    CGFloat const * components = CGColorGetComponents(self.CGColor);
    
    if (numComponents == 4){
        CGFloat rFloat = components[0]; // red
        CGFloat gFloat = components[1]; // green
        CGFloat bFloat = components[2]; // blue
        
        NSUInteger r = (NSUInteger)roundf(rFloat*ADD_COLOR_SIZE);
        NSUInteger g = (NSUInteger)roundf(gFloat*ADD_COLOR_SIZE);
        NSUInteger b = (NSUInteger)roundf(bFloat*ADD_COLOR_SIZE);
        
        *rgbHex = (r << ADD_RED_SHIFT) + (g << ADD_GREEN_SHIFT) + (b << ADD_BLUE_SHIFT);
        
        return YES;
    }
    else if (numComponents == 2){
        CGFloat gFloat = components[0]; // gray
        NSUInteger g = (NSUInteger)roundf(gFloat*ADD_COLOR_SIZE);
        *rgbHex = (g << ADD_RED_SHIFT) + (g << ADD_GREEN_SHIFT) + (g << ADD_BLUE_SHIFT);
        return YES;
    }
    
    return NO;
}

- (BOOL)getRGBAHexValue:(NSUInteger*)rgbaHex;
{
    size_t numComponents = CGColorGetNumberOfComponents(self.CGColor);
    CGFloat const * components = CGColorGetComponents(self.CGColor);
    
    if (numComponents == 4){
        CGFloat rFloat = components[0]; // red
        CGFloat gFloat = components[1]; // green
        CGFloat bFloat = components[2]; // blue
        CGFloat aFloat = components[3]; // alpha
        
        NSUInteger r = (NSUInteger)roundf(rFloat*ADD_COLOR_SIZE);
        NSUInteger g = (NSUInteger)roundf(gFloat*ADD_COLOR_SIZE);
        NSUInteger b = (NSUInteger)roundf(bFloat*ADD_COLOR_SIZE);
        NSUInteger a = (NSUInteger)roundf(aFloat*ADD_COLOR_SIZE);
        
        *rgbaHex = (r << ADD_RED_SHIFT) + (g << ADD_GREEN_SHIFT) + (b << ADD_BLUE_SHIFT) + (a << ADD_ALPHA_SHIFT);
        
        return YES;
    }
    else if (numComponents == 2){
        CGFloat gFloat = components[0]; // gray
        CGFloat aFloat = components[1]; // alpha
        
        NSUInteger g = (NSUInteger)roundf(gFloat*ADD_COLOR_SIZE);
        NSUInteger a = (NSUInteger)roundf(aFloat *ADD_COLOR_SIZE);
        
        *rgbaHex = (g << ADD_RED_SHIFT) + (g << ADD_GREEN_SHIFT) + (g << ADD_BLUE_SHIFT) + (a << ADD_ALPHA_SHIFT);
        
        return YES;
    }
    
    return NO;
}

- (NSString*)stringWithRGBHex
{
    NSUInteger value = 0;
    BOOL compatible = [self getRGBHexValue:&value];
    
    if (!compatible)
        return nil;
    
    return [NSString stringWithFormat:@"%x", (unsigned)value];
}

- (NSString*)stringWithRGBAHex
{
    NSUInteger value = 0;
    BOOL compatible = [self getRGBAHexValue:&value];
    
    if (!compatible)
        return nil;
    
    return [NSString stringWithFormat:@"%x", (unsigned)value];
}
@end

@implementation CMColor

@end

