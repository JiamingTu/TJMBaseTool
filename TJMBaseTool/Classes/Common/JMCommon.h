//
//  JMCommon.h
//  AFNetworking
//
//  Created by Jiaming Tu on 2018/6/21.
//

#import <Foundation/Foundation.h>
#import "JMSingleton.h"
typedef void(^JMLogoutBlock)(void);

@interface JMCommon : NSObject

SingletonH(Common)

/**
 返回按钮图片name
 */
@property (nonatomic, copy) NSString *backItemImageName;


/**
 获取最顶层vc

 @return vc
 */
+ (UIViewController *)topViewController;

/**
 APP是否第一次启动

 @return bool
 */
+ (BOOL)isAppFirstRun;

///颜色
@property (nonatomic, strong) UIColor *mainColor;

@property (nonatomic, strong) UIColor *subColor;

@property (nonatomic, strong) UIColor *leastColor;

@property (nonatomic, strong) UIColor *mainTextColor;

@property (nonatomic, strong) UIColor *subTextColor;

@property (nonatomic, strong) UIColor *leastTextColor;

@property (nonatomic, strong) UIColor *lineColor;



@end
