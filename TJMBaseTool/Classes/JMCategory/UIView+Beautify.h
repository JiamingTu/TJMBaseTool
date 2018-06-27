//
//  UIView+Beautify.h
//  WasherSharing
//
//  Created by Jiaming Tu on 2017/8/23.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Beautify)
/**添加阴影*/
- (void)addShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;

/**切圆角（指定）*/
- (void)chopCorners:(UIRectCorner)corners radius:(CGFloat)radius;
/**切所有圆角*/
- (void)chopAllCornerRadius:(CGFloat)radius;
/**添加渐变*/
- (void)addGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor isHorizon:(BOOL)isHorizon;
/**导航添加渐变*/
- (void)naviBarAddGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;
/**水平渐变*/
- (void)addHorizonGrandientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor ;

/**
 渐变 + 圆角 width / 2

 @param colors colors
 @param shadowRadius shadowRadius
 @param shadowOpacity shadowOpacity
 @param shadowColor shadowColor
 */
- (void)addGradinetAndShadowWithColors:(NSArray<UIColor *> *)colors shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity shadowColor:(UIColor *)shadowColor;

- (void)addGrayLayer;

/**添加虚线*/
- (void)constructImaginaryLineWithColor:(UIColor *)color;
/**四周阴影*/
- (void)setShadowWithShadowColor:(UIColor *)color;

- (void)addBorderWithColor:(UIColor *)color width:(CGFloat)width;

@end
