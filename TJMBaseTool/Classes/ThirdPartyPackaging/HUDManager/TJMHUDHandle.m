//
//  TJMHUDHandle.m
//  Mould
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import "TJMHUDHandle.h"


#define HUD_BEZELVIEWCOLOR [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]
#define HUD_TEXTCOLOR [UIColor whiteColor]

static const CGFloat alpha = 0.9f;

@interface TJMHUDHandle ()

@end

@implementation TJMHUDHandle
#pragma  mark 纯文字
+ (void)transientNoticeAtView:(UIView *)view withMessage:(NSString *)message {
    [TJMHUDHandle hiddenHUDForView:view];
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    if (message.length > 20) {
        progressHUD.detailsLabel.textColor = [JMCommon sharedCommon].hudTextColor ? [JMCommon sharedCommon].hudTextColor : HUD_TEXTCOLOR;
        progressHUD.detailsLabel.text = message;
    } else {
        progressHUD.label.textColor = [JMCommon sharedCommon].hudTextColor ? [JMCommon sharedCommon].hudTextColor : HUD_TEXTCOLOR;
        progressHUD.label.text = message;
    }
    progressHUD.label.font = [UIFont systemFontOfSize:13];
    progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHUD.bezelView.backgroundColor = [JMCommon sharedCommon].hudBackgroundColor ? [JMCommon sharedCommon].hudBackgroundColor : HUD_BEZELVIEWCOLOR;
    progressHUD.alpha = alpha;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    [progressHUD hideAnimated:YES afterDelay:1.5];
}
#pragma  mark 轻触
+ (void)tapHUDWithTarget:(id)target action:(SEL)action atView:(UIView *)view withMessage:(NSString *)message  {
    [TJMHUDHandle hiddenHUDForView:view];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:13];
    progressHUD.label.textColor = [JMCommon sharedCommon].hudTextColor ? [JMCommon sharedCommon].hudTextColor : HUD_TEXTCOLOR;
    progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHUD.bezelView.backgroundColor = [JMCommon sharedCommon].hudBackgroundColor ? [JMCommon sharedCommon].hudBackgroundColor : HUD_BEZELVIEWCOLOR;
    progressHUD.alpha = alpha;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    bgTap.numberOfTapsRequired = 1;
    [progressHUD.backgroundView addGestureRecognizer:bgTap];
    UITapGestureRecognizer *HUDTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    HUDTap.numberOfTapsRequired = 1;
    [progressHUD addGestureRecognizer:HUDTap];
}

#pragma  mark 菊花加文字
+ (MBProgressHUD *)showRequestHUDAtView:(UIView *)view message:(NSString *)message {
    [TJMHUDHandle hiddenHUDForView:view];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [JMCommon sharedCommon].hudTextColor ? [JMCommon sharedCommon].hudTextColor : HUD_TEXTCOLOR;;
    progressHUD.activityIndicatorColor = [JMCommon sharedCommon].hudTextColor ? [JMCommon sharedCommon].hudTextColor : HUD_TEXTCOLOR;;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:13];
    progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHUD.bezelView.backgroundColor = [JMCommon sharedCommon].hudBackgroundColor ? [JMCommon sharedCommon].hudBackgroundColor : HUD_BEZELVIEWCOLOR;
    progressHUD.alpha = alpha;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
//    [progressHUD hideAnimated:YES afterDelay:2];
    return progressHUD;
}

+ (void)hiddenHUDForView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}
#pragma  mark 圆圈进度
+ (MBProgressHUD *)showProgressHUDAtView:(UIView *)view message:(NSString *)message {
    [TJMHUDHandle hiddenHUDForView:view];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:13];
    progressHUD.label.textColor = [JMCommon sharedCommon].hudTextColor ? [JMCommon sharedCommon].hudTextColor : HUD_TEXTCOLOR;;
    progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHUD.bezelView.backgroundColor = [JMCommon sharedCommon].hudBackgroundColor ? [JMCommon sharedCommon].hudBackgroundColor : HUD_BEZELVIEWCOLOR;
    progressHUD.alpha = alpha;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    return progressHUD;
}



@end
