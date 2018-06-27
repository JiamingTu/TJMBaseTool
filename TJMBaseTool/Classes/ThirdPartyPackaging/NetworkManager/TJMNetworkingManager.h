//
//  TJMNetworkingManager.h
//  WasherSharing
//
//  Created by Jiaming Tu on 2017/8/17.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^JMNetworkingSuccess)(id successObj,NSString *msg);
typedef void(^JMNetworkingFailure)(NSInteger code, NSString *failString);
typedef void(^JMNetworkingProgress)(NSProgress *progress);


@interface TJMNetworkingManager : NSObject



/**GET*/
+ (void)GET:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(JMNetworkingProgress)progress success:(JMNetworkingSuccess)success failure:(JMNetworkingFailure)failure;
/**POST*/
+ (void)POST:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(JMNetworkingProgress)progress success:(JMNetworkingSuccess)success failure:(JMNetworkingFailure)failure;
/**POST upload 单张*/
+ (void)POST:(NSString *)URLString
 isNeedToken:(BOOL)isNeedToken
  parameters:(NSDictionary *)parameters
        data:(NSData *)data
        name:(NSString *)name
    fileName:(NSString *)fileName
    mimeType:(NSString *)mimeType
    progress:(JMNetworkingProgress)progress
     success:(JMNetworkingSuccess)success
     failure:(JMNetworkingFailure)failure;
/**POST 多上传*/
+ (void)POST:(NSString *)URLString
 isNeedToken:(BOOL)isNeedToken
  parameters:(NSDictionary *)parameters
      images:(NSArray<UIImage *> *)images
        name:(NSString *)name
    mimeType:(NSString *)mimeType
    progress:(JMNetworkingProgress)progress
     success:(JMNetworkingSuccess)success
     failure:(JMNetworkingFailure)failure;
/**Json POST*/
+ (void)JsonPOST:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(JMNetworkingProgress)progress success:(JMNetworkingSuccess)success failure:(JMNetworkingFailure)failure;
/**Json post 数组*/
+ (void)JsonPost:(NSString *)URLString isNeedToken:(BOOL)isNeedToken array:(NSArray *)array progress:(JMNetworkingProgress)progress success:(JMNetworkingSuccess)success failure:(JMNetworkingFailure)failure;
/**PUT*/
+ (void)PUT:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters success:(JMNetworkingSuccess)success failure:(JMNetworkingFailure)failure;

/**PUT upload */
+ (void)PUT:(NSString *)URLString isNeedToken:(BOOL)isNeedToken data:(NSData *)data parameters:(NSDictionary *)parameters progress:(JMNetworkingProgress)progress success:(JMNetworkingSuccess)success failure:(JMNetworkingFailure)failure;

/**DELETE */
+ (void)DELETE:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters success:(JMNetworkingSuccess)success failure:(JMNetworkingFailure)failure;

/**cancel*/
+ (void)cancelAll;

/**sign*/
+ (NSDictionary *)signWithDictionary:(NSDictionary *)dictionary needTimestamp:(BOOL)isNeed;

@end
