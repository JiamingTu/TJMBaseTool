//
//  JMCommon.m
//  AFNetworking
//
//  Created by Jiaming Tu on 2018/6/21.
//

#import "JMCommon.h"
@implementation JMCommon

SingletonM(Common)

#pragma mark - 获取当前VC
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma  mark - APP是否第一次使用
+ (BOOL)isAppFirstRun {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRunKey = [defaults objectForKey:@"last_run_version_key"];
    if (!lastRunKey) {
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        return YES;
        // App is being run for first time
        //上次运行版本为空，说明程序第一次运行
    }
    else if (![lastRunKey isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        return YES;
        // App has been updated since last run
        //有版本号，但是和当前版本号不同，说明程序已经更新了版本
    }
    return NO;
}



@end
