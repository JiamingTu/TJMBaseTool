//
//  TJMNetworkingManager.h
//  WasherSharing
//
//  Created by Jiaming Tu on 2017/8/17.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ntf_JM_Networking_Logout = @"ntf_JM_Networking_Logout";

@interface TJMNetworkingManager : NSObject

/**GET*/
+ (void)GET:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress *progress))progress success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure;
/**POST*/
+ (void)POST:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress *progress))progress success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure;
/**POST upload 单张*/
+ (void)POST:(NSString *)URLString
 isNeedToken:(BOOL)isNeedToken
  parameters:(NSDictionary *)parameters
        data:(NSData *)data
        name:(NSString *)name
    fileName:(NSString *)fileName
    mimeType:(NSString *)mimeType
    progress:(void(^)(NSProgress *progress))progress
     success:(void(^)(id successObj,NSString *msg))success
     failure:(void(^)(NSInteger code, NSString *failString))failure;
/**POST 多上传*/
+ (void)POST:(NSString *)URLString
 isNeedToken:(BOOL)isNeedToken
  parameters:(NSDictionary *)parameters
      images:(NSArray<UIImage *> *)images
        name:(NSString *)name
    mimeType:(NSString *)mimeType
    progress:(void(^)(NSProgress *progress))progress
     success:(void(^)(id successObj,NSString *msg))success
     failure:(void(^)(NSInteger code, NSString *failString))failure;
/**Json POST*/
+ (void)JsonPOST:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress *progress))progress success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure;
/**Json post 数组*/
+ (void)JsonPOST:(NSString *)URLString isNeedToken:(BOOL)isNeedToken array:(NSArray *)array uploadProgressBlock:(void(^)(NSProgress *progress))uploadProgressBlock success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure;
/**PUT*/
+ (void)PUT:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure;

/**PUT upload */
+ (void)JsonPUT:(NSString *)URLString isNeedToken:(BOOL)isNeedToken data:(NSData *)data parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress *progress))progress success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure;

/**PUT array */
+ (void)JsonPUT:(NSString *)URLString isNeedToken:(BOOL)isNeedToken array:(NSArray *)array uploadProgressBlock:(void(^)(NSProgress *progress))uploadProgressBlock success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure;

/**DELETE */
+ (void)DELETE:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure;

/**cancel*/
+ (void)cancelAll;

/**sign*/
//+ (NSDictionary *)signWithDictionary:(NSDictionary *)dictionary needTimestamp:(BOOL)isNeed;

@end
