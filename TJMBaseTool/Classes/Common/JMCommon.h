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
///net work

/**
 登出block
 */
@property (nonatomic, copy) JMLogoutBlock logout;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, strong) UIColor *hudBackgroundColor;

@property (nonatomic, strong) UIColor *hudTextColor;

@property (nonatomic, copy) NSString *backItemImageName;

+ (UIViewController *)topViewController;

@end
