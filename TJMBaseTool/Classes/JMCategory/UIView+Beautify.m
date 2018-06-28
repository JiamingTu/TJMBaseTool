//
//  UIView+Beautify.m
//  WasherSharing
//
//  Created by Jiaming Tu on 2017/8/23.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import "UIView+Beautify.h"
#import "JMDefine.h"
@implementation UIView (Beautify)

- (void)addShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    // Creating shadow path for better performance
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.clipsToBounds = NO;
}
#pragma  mark - 渐变
- (void)addGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor isHorizon:(BOOL)isHorizon {
    [self layoutIfNeeded];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    CGPoint endPoint = isHorizon ? CGPointMake(1.0, 0) : CGPointMake(0, 1.0);
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame = self.bounds;
    [self.layer addSublayer:gradientLayer];
}

- (void)naviBarAddGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    [self layoutIfNeeded];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(1.0, 0);
    gradientLayer.endPoint = endPoint;
    CGRect frame = self.bounds;
    //ios 11 适配
    if (JM_IS_IPHONE_X) {
        frame.size.height += 44;
    } else {
        frame.size.height += 20;
    }
    gradientLayer.frame = frame;
    [self.layer addSublayer:gradientLayer];
}

- (void)addHorizonGrandientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    [self layoutIfNeeded];
    [self addGradientWithStartColor:startColor endColor:endColor isHorizon:YES];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
}

- (void)addGrayLayer {
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = self.bounds;
    layer.backgroundColor = [UIColor colorWithRed:82 / 255.0 green:82 / 255.0 blue:82 / 255.0 alpha:1.0].CGColor;
    [self.layer addSublayer:layer];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
}

- (void)addGradinetAndShadowWithColors:(NSArray<UIColor *> *)colors shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity shadowColor:(UIColor *)shadowColor {
    [self layoutIfNeeded];
    self.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *colorArr = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorArr addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = colorArr;
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, 1.0);
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame = self.bounds;
    gradientLayer.cornerRadius = self.bounds.size.height / 2;
    gradientLayer.shadowColor = shadowColor.CGColor;
    gradientLayer.shadowOffset = CGSizeMake(1, 2);
    gradientLayer.shadowRadius = shadowRadius;
    gradientLayer.shadowOpacity = shadowOpacity;
    [self.layer addSublayer:gradientLayer];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];

}

#pragma  mark - 切圆角（指定）
- (void)chopCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
#pragma  mark - 切所有圆角
- (void)chopAllCornerRadius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners: UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma  mark - 画虚线
- (void)constructImaginaryLineWithColor:(UIColor *)color {
    [self layoutIfNeeded];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:color.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:7], [NSNumber numberWithInt:3], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(self.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [self.layer addSublayer:shapeLayer];
}

#pragma  mark - 四周阴影
#pragma  mark - 设置阴影
- (void)setShadowWithShadowColor:(UIColor *)color {
    //设置阴影
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = 0.3;
//    self.layer.shadowRadius = 5;
    //路径阴影
//    float addWH = 8 * TJMHeightRatio;
//    float width = self.bounds.size.width;
//    float height = self.bounds.size.height;
//    float x = self.bounds.origin.x - addWH;
//    float y = self.bounds.origin.y - addWH;
//    
//    
//    UIBezierPath* aPath = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, width + addWH * 2, height + addWH * 2)];
//    //设置阴影路径
//    self.layer.shadowPath = aPath.CGPath;
}

- (void)addBorderWithColor:(UIColor *)color width:(CGFloat)width  {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

@end
