//
//  UINavigationBar+BackgroundColor.m
//  Mould
//
//  Created by Jiaming Tu on 2017/5/2.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>
#import "JMDefine.h"
@implementation UINavigationBar (BackgroundColor)

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, @"overlay");
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, @"overlay", overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)tjm_setBackgroundColor:(UIColor *)backgroundColor {
    UIView *backgroundView = [self tjm_getBackgroundView];
    if (!self.overlay && backgroundView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:backgroundView.bounds];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [backgroundView insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (UIView *)tjm_getBackgroundView {
    //iOS10之前为 _UINavigationBarBackground, iOS10为 _UIBarBackground
    //_UINavigationBarBackground实际为UIImageView子类，而_UIBarBackground是UIView子类
    //之前setBackgroundImage直接赋值给_UINavigationBarBackground，现在则是设置后为_UIBarBackground增加一个UIImageView子控件方式去呈现图片
    if (JMCurrentDevice >= 10.0) {
        UIView *_UIBackground;
        NSString *targetName = @"_UIBarBackground";
        Class _UIBarBackgroundClass = NSClassFromString(targetName);
        
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:_UIBarBackgroundClass.class]) {
                _UIBackground = subview;
                break;
            }
        }
        return _UIBackground;
    } else {
        UIView *_UINavigationBarBackground;
        NSString *targetName = @"_UINavigationBarBackground";
        Class _UINavigationBarBackgroundClass = NSClassFromString(targetName);
        
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:_UINavigationBarBackgroundClass.class]) {
                _UINavigationBarBackground = subview;
                break;
            }
        }
        return _UINavigationBarBackground;
    }
}

- (void)tjm_removeBackgroundView {
    if (self.overlay) {
        [self.overlay removeFromSuperview];
        self.overlay = nil;
//        UIView *backgroundView = [self tjm_getBackgroundView];
        
    }
}

#pragma mark - shadow view
- (void)tjm_hideShadowImageOrNot:(BOOL)bHidden
{
    UIView *bgView = [self tjm_getBackgroundView];
    
    //shadowImage应该是只占一个像素，即1.0/scale
    for (UIView *subview in bgView.subviews) {
        if (CGRectGetHeight(subview.bounds) <= 1.0) {
            subview.hidden = bHidden;
        }
    }
}


#pragma  mark - 导航基本设置
- (void)tjm_navigationBarBasicSettingWithBgColor:(UIColor *)color showLine:(BOOL)showLine shadow:(BOOL)isShadow {
    [self tjm_hideShadowImageOrNot:showLine];
    [self tjm_setBackgroundColor:color];
    if (isShadow) {
        CGFloat value = 102 / 255.0;
        
        self.layer.shadowColor = [UIColor colorWithRed:value green:value blue:value alpha:1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        
        // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
        self.clipsToBounds = NO;
    }
}


@end
