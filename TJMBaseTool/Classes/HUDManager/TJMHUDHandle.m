//
//  TJMHUDHandle.m
//  Mould
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import "TJMHUDHandle.h"
#import "MBProgressHUD.h"
#import "JMHUDConfig.h"

@interface TJMHUDHandle ()

@end

@implementation TJMHUDHandle
#pragma  mark 纯文字
+ (void)transientNoticeAtView:(UIView *)view withMessage:(NSString *)message {
    [TJMHUDHandle hiddenHUDForView:view];
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    if (message.length > 20) {
        progressHUD.detailsLabel.textColor = [JMHUDConfig shareConfig].hudTextColor;
        progressHUD.detailsLabel.text = message;
    } else {
        progressHUD.label.textColor = [JMHUDConfig shareConfig].hudTextColor;
        progressHUD.label.text = message;
    }
    progressHUD.contentColor = [JMHUDConfig shareConfig].hudTextColor;
    progressHUD.label.font = [UIFont systemFontOfSize:13];
    progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHUD.bezelView.backgroundColor = [JMHUDConfig shareConfig].hudBackgroundColor;
    progressHUD.alpha = JM_HUD_CONFIG.alpha;
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
    progressHUD.label.textColor = [JMHUDConfig shareConfig].hudTextColor;
    progressHUD.contentColor = [JMHUDConfig shareConfig].hudTextColor;
    progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHUD.bezelView.backgroundColor = [JMHUDConfig shareConfig].hudBackgroundColor;
    progressHUD.alpha = JM_HUD_CONFIG.alpha;
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
    progressHUD.contentColor = [JMHUDConfig shareConfig].hudTextColor;
    progressHUD.label.text = message;
    progressHUD.label.font = [UIFont systemFontOfSize:13];
    progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHUD.bezelView.backgroundColor = [JMHUDConfig shareConfig].hudBackgroundColor;
    progressHUD.alpha = JM_HUD_CONFIG.alpha;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    // 设置超时隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([JMHUDConfig shareConfig].showTimeoutInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [progressHUD hideAnimated:YES];
    });
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
    progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    progressHUD.bezelView.backgroundColor = [JMHUDConfig shareConfig].hudBackgroundColor;
    progressHUD.contentColor = [JMHUDConfig shareConfig].hudTextColor ;
    progressHUD.alpha = JM_HUD_CONFIG.alpha;
    progressHUD.removeFromSuperViewOnHide = YES;//隐藏后从父视图移除
    progressHUD.animationType = MBProgressHUDAnimationFade;//动画类型
//     关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    progressHUD.opaque = NO;
    // 设置超时隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([JMHUDConfig shareConfig].showTimeoutInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [progressHUD hideAnimated:YES];
    });
    return progressHUD;
}


@end
