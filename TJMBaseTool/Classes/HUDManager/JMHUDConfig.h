//
//  JMHUDConfig.h
//  AFNetworking
//
//  Created by Jiaming Tu on 2019/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define JM_HUD_CONFIG [JMHUDConfig shareConfig]

@interface JMHUDConfig : NSObject

+ (instancetype)shareConfig;

@property (nonatomic, strong) UIColor *hudBackgroundColor;

@property (nonatomic, strong) UIColor *hudTextColor;

@property (nonatomic, assign) NSTimeInterval showTimeoutInterval;

@property (nonatomic, assign) CGFloat alpha;

@end

NS_ASSUME_NONNULL_END
