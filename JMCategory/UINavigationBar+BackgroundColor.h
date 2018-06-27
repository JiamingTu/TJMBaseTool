//
//  UINavigationBar+BackgroundColor.h
//  Mould
//
//  Created by Jiaming Tu on 2017/5/2.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundColor)

@property (nonatomic,strong) UIView *overlay;
- (void)tjm_setBackgroundColor:(UIColor *)backgroundColor;
- (void)tjm_hideShadowImageOrNot:(BOOL)bHidden;
- (void)tjm_removeBackgroundView;

/**导航基础设置*/
- (void)tjm_navigationBarBasicSettingWithShadow:(BOOL)isShadow;
@end
