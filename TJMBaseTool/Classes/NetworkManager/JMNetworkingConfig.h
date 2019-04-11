//
//  JMNetworkingConfig.h
//  AFNetworking
//
//  Created by Jiaming Tu on 2019/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define JM_NETWORKING_CONFIG [JMNetworkingConfig shareConfig]

@interface JMNetworkingConfig : NSObject

+ (JMNetworkingConfig *)shareConfig;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, copy) NSString *acceptHeaderFiledValue;

@property (nonatomic, copy) NSString *contentTypeHeaderFiledValue;

/**
 parmas 放在 query 的请求 有哪些
 */
@property (nonatomic, strong) NSSet *httpManagerParamsInUrlSet;

/**
 数组在 query 里时 的拼接方式 x[]=y&x[]=z  or x=y&x=z
 */
@property (nonatomic, assign) BOOL arrayInQueryIsNeedBracket;

FOUNDATION_EXPORT NSString * JM_AFQueryStringFromParameters(NSDictionary *parameters);

@end

NS_ASSUME_NONNULL_END
