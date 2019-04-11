
//
//  JMHUDConfig.m
//  AFNetworking
//
//  Created by Jiaming Tu on 2019/3/20.
//

#import "JMHUDConfig.h"

@implementation JMHUDConfig

+ (instancetype)shareConfig {
    static JMHUDConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [self new];
        config.hudBackgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        config.hudTextColor = [UIColor whiteColor];
        config.showTimeoutInterval = 12.f;
        config.alpha = 0.9f;
    });
    return config;
}


@end
