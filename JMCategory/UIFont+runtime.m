//
//  UIFont+runtime.m
//  字体大小适配-runtime
//
//  Created by 刘龙 on 2017/3/23.
//  Copyright © 2017年 xixhome. All rights reserved.
//

#import "UIFont+runtime.h"
#import <objc/runtime.h>
@implementation UIFont (runtime)
+ (void)load{
    //获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    //获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    //然后交换类方法
    method_exchangeImplementations(newMethod, method);
    //加粗
    //获取替换后的类方法
    Method boldNewMethod = class_getClassMethod([self class], @selector(jm_boldSystemFontOfSize:));
    //获取替换前的类方法
    Method boldMethod = class_getClassMethod([self class], @selector(boldSystemFontOfSize:));
    //然后交换类方法
    method_exchangeImplementations(boldNewMethod, boldMethod);
}


+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont=nil;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //防止横竖屏混淆
    CGFloat realWidth = screenWidth < screenHeight ? screenWidth : screenHeight;
//    newFont = [UIFont adjustFont:fontSize * realWidth / YourUIScreen];
    // 5 6 X 不变 Plus +2
    if (realWidth == 414) {
        newFont = [UIFont adjustFont:fontSize + 2];
    } else {
        newFont = [UIFont adjustFont:fontSize];
    }
    return newFont;
}

+ (UIFont *)jm_boldSystemFontOfSize:(CGFloat)fontSize {
    UIFont *newFont=nil;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //防止横竖屏混淆
    CGFloat realWidth = screenWidth < screenHeight ? screenWidth : screenHeight;
    if (realWidth == 414) {
        newFont = [UIFont jm_boldSystemFontOfSize:fontSize + 2];
    } else {
        newFont = [UIFont jm_boldSystemFontOfSize:fontSize];
    }
    return newFont;
}


@end
