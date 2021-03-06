//
//  TJMHUDHandle.h
//  Mould
//
//  Created by Jiaming Tu on 2017/4/13.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
@interface TJMHUDHandle : NSObject
/**纯文字1.5s后消失*/
+ (void)transientNoticeAtView:(UIView *)view withMessage:(NSString *)message;
/** 菊花加文字 */
+ (MBProgressHUD *)showRequestHUDAtView:(UIView *)view message:(NSString *)message;
+ (void)hiddenHUDForView:(UIView *)view;
/**圆圈进度条*/
+ (MBProgressHUD *)showProgressHUDAtView:(UIView *)view message:(NSString *)message;
/**轻触*/
+ (void)tapHUDWithTarget:(id)target action:(SEL)action atView:(UIView *)view withMessage:(NSString *)message;


@end
