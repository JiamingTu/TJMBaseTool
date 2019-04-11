//
//  TJMNetworkingManager.m
//  WasherSharing
//
//  Created by Jiaming Tu on 2017/8/17.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import "TJMNetworkingManager.h"
#import "AFNetworking.h"
#import "JMNetworkingConfig.h"

// 日志输出
#ifdef DEBUG // 开发阶段-DEBUG阶段:使用Log
#define JMNLog(...) NSLog(__VA_ARGS__)
#else // 发布阶段-上线阶段:移除Log
#define JMNLog(...)
#endif

//字符串是否空 空 return @“” 非空 return string
#define JMNStringIsEmpty(string) ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] ? @"" : string )


#define TJMResponseMessage  responseObject[@"msg"]

//#define JMTimestamp         [NSString stringWithFormat:@"%ld",time(NULL)*1000]
// 秘钥
//#define TJMSecretKey @"81bd443e4f5ad60bed6e00d42d8babfd"
@implementation TJMNetworkingManager
static AFHTTPSessionManager *httpManager = nil;
+ (AFHTTPSessionManager *)shareHttpManager {
    if (!httpManager) {
        httpManager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        httpManager.responseSerializer = jsonResponseSerializer;
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [httpManager.requestSerializer setValue:JM_NETWORKING_CONFIG.acceptHeaderFiledValue forHTTPHeaderField:@"Accept"];
        [httpManager.requestSerializer setValue:JM_NETWORKING_CONFIG.contentTypeHeaderFiledValue forHTTPHeaderField:@"Content-Type"];
        httpManager.requestSerializer.HTTPMethodsEncodingParametersInURI = JM_NETWORKING_CONFIG.httpManagerParamsInUrlSet;
        [httpManager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            return JM_AFQueryStringFromParameters(parameters);
        }];
        // 设置超时时间
        [httpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        httpManager.requestSerializer.timeoutInterval = JM_NETWORKING_CONFIG.timeoutInterval;
        [httpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return httpManager;
}

+ (AFHTTPSessionManager *)shareJsonManager {
    static AFHTTPSessionManager *jsonManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jsonManager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        jsonManager.responseSerializer = jsonResponseSerializer;
        jsonManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [jsonManager.requestSerializer setValue:JM_NETWORKING_CONFIG.acceptHeaderFiledValue forHTTPHeaderField:@"Accept"];
        [jsonManager.requestSerializer setValue:JM_NETWORKING_CONFIG.contentTypeHeaderFiledValue forHTTPHeaderField:@"Content-Type"];
        // 设置超时时间
        [jsonManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        jsonManager.requestSerializer.timeoutInterval = JM_NETWORKING_CONFIG.timeoutInterval;
        [jsonManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return jsonManager;
}
#pragma  mark - 请求
#pragma  mark GET
+ (void)GET:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress *progress))progress success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure  {
    //配置token
    [self configAuthorization:isNeedToken];
    [[TJMNetworkingManager shareHttpManager] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureWithSessionDataTask:task error:error failure:failure];
    }];
}
#pragma  mark POST
+ (void)POST:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress *progress))progress success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure {
    //配置token
    [self configAuthorization:isNeedToken];
    [[TJMNetworkingManager shareHttpManager] POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self requestFailureWithSessionDataTask:task error:error failure:failure];
    }];
}

#pragma  mark POST FormData
+ (void)POST:(NSString *)URLString
 isNeedToken:(BOOL)isNeedToken
  parameters:(NSDictionary *)parameters
        data:(NSData *)data
        name:(NSString *)name
    fileName:(NSString *)fileName
    mimeType:(NSString *)mimeType
    progress:(void(^)(NSProgress *progress))progress
     success:(void(^)(id successObj,NSString *msg))success
     failure:(void(^)(NSInteger code, NSString *failString))failure {
    //配置token
    [self configAuthorization:isNeedToken];
    [[TJMNetworkingManager shareHttpManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureWithSessionDataTask:task error:error failure:failure];
    }];
}

+ (void)POST:(NSString *)URLString
 isNeedToken:(BOOL)isNeedToken
  parameters:(NSDictionary *)parameters
      images:(NSArray<UIImage *> *)images
        name:(NSString *)name
    mimeType:(NSString *)mimeType
    progress:(void(^)(NSProgress *progress))progress
     success:(void(^)(id successObj,NSString *msg))success
     failure:(void(^)(NSInteger code, NSString *failString))failure {
    //配置token
    [self configAuthorization:isNeedToken];
    [[TJMNetworkingManager shareHttpManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = UIImageJPEGRepresentation(obj, .3f);
            [formData appendPartWithFileData:data name:name fileName:[NSString stringWithFormat:@"%zd.jpeg",idx] mimeType:mimeType];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureWithSessionDataTask:task error:error failure:failure];
    }];
}

#pragma  mark - json post
+ (void)JsonPOST:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress *progress))progress success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure {
    //配置token
    [self configAuthorization:isNeedToken];
    [[TJMNetworkingManager shareJsonManager] POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureWithSessionDataTask:task error:error failure:failure];
    }];
}

#pragma  mark - json post 参数 array
+ (void)JsonPOST:(NSString *)URLString isNeedToken:(BOOL)isNeedToken array:(NSArray *)array uploadProgressBlock:(void(^)(NSProgress *progress))uploadProgressBlock success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure {
    if (JM_NETWORKING_CONFIG.token) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:nil error:nil];
        if (isNeedToken) [request setValue:JM_NETWORKING_CONFIG.token forHTTPHeaderField:@"Authorization"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:data];
        __block NSURLSessionDataTask *task;
        task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            if (uploadProgressBlock) uploadProgressBlock(uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                JMNLog(@"json post array noerror,\n url : %@,\n responseObject : %@", URLString, responseObject);
                [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
            } else {
                JMNLog(@"json post array error,\n url : %@,\n error : %@", URLString, error);
                [self requestFailureWithSessionDataTask:task error:error failure:failure];
            }
        }];
        [task resume];
    } else {
        JMNLog(@"url : %@, common.token 未设置", URLString);
    }
}

#pragma  mark PUT
+ (void)PUT:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure {
    [self configAuthorization:isNeedToken];
    [[TJMNetworkingManager shareHttpManager] PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureWithSessionDataTask:task error:error failure:failure];
    }];
}

+ (void)JsonPUT:(NSString *)URLString isNeedToken:(BOOL)isNeedToken data:(NSData *)data parameters:(NSDictionary *)parameters progress:(void(^)(NSProgress *progress))progress success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure {
    if (JM_NETWORKING_CONFIG.token) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (data) {
                [formData appendPartWithFileData:data name:@"face" fileName:@"face.jpeg" mimeType:@"image/jpeg"];
            }
        } error:nil];
        if (isNeedToken) {
            [request setValue:JM_NETWORKING_CONFIG.token forHTTPHeaderField:@"Authorization"];
        } else {
            [request setValue:nil forHTTPHeaderField:@"Authorization"];
        }
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if (parameters && parameters.count > 0) {
            [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil]];
        }
        __block NSURLSessionDataTask *task;
        task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
            } else {
                [self requestFailureWithSessionDataTask:task error:error failure:failure];
            }
        }];
        [task resume];
    }
}

+ (void)JsonPUT:(NSString *)URLString isNeedToken:(BOOL)isNeedToken array:(NSArray *)array uploadProgressBlock:(void(^)(NSProgress *progress))uploadProgressBlock success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure {
    if (JM_NETWORKING_CONFIG.token) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:URLString parameters:nil constructingBodyWithBlock:nil error:nil];
        if (isNeedToken) [request setValue:JM_NETWORKING_CONFIG.token forHTTPHeaderField:@"Authorization"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:data];
        __block NSURLSessionDataTask *task;
        task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            if (uploadProgressBlock) uploadProgressBlock(uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                JMNLog(@"json post array noerror,\n url : %@,\n responseObject : %@", URLString, responseObject);
                [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
            } else {
                JMNLog(@"json post array error,\n url : %@,\n error : %@", URLString, error);
                [self requestFailureWithSessionDataTask:task error:error failure:failure];
            }
        }];
        [task resume];
    } else {
        JMNLog(@"url : %@, common.token 未设置", URLString);
    }
}

+ (void)DELETE:(NSString *)URLString isNeedToken:(BOOL)isNeedToken parameters:(NSDictionary *)parameters success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure {
    [self configAuthorization:isNeedToken];
    [[TJMNetworkingManager shareHttpManager] DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailureWithSessionDataTask:task error:error failure:failure];
    }];
}

#pragma  mark - cancel
+ (void)cancelAll {
    [[TJMNetworkingManager shareHttpManager].operationQueue cancelAllOperations];
    [[TJMNetworkingManager shareJsonManager].operationQueue cancelAllOperations];
}

#pragma  mark - 公共配置
//是否token
+ (void)configAuthorization:(BOOL)isNeed {
    if (isNeed) {
        [[TJMNetworkingManager shareHttpManager].requestSerializer setValue:JM_NETWORKING_CONFIG.token forHTTPHeaderField:@"Authorization"];
        [[TJMNetworkingManager shareJsonManager].requestSerializer setValue:JM_NETWORKING_CONFIG.token forHTTPHeaderField:@"Authorization"];
    } else {
        [[TJMNetworkingManager shareHttpManager].requestSerializer clearAuthorizationHeader];
        [[TJMNetworkingManager shareJsonManager].requestSerializer clearAuthorizationHeader];
    }
}


//网络请求成功后处理结果
+ (void)requestSuccessWithSessionDataTask:(NSURLSessionTask *)task responseObject:(id)responseObject success:(void(^)(id successObj,NSString *msg))success failure:(void(^)(NSInteger code, NSString *failString))failure {
    if ([responseObject[@"error"] boolValue] == NO) {
        if (success) {
            if ([TJMResponseMessage isEqual:[NSNull null]]) {
                success(responseObject,@"成功");
            } else {
                success(responseObject,TJMResponseMessage);
            }
        }
    } else {
        // 其他都是错误
        if ([responseObject[@"code"] integerValue] == 401 || [responseObject[@"code"] integerValue] == 403) {
            //未授权 授权过期
            if (failure) {
                failure([responseObject[@"code"] integerValue], JMNStringIsEmpty(TJMResponseMessage));
            }
            //显示 未授权 并 切换到 登录界面
            [[NSNotificationCenter defaultCenter] postNotificationName:ntf_JM_Networking_Logout object:nil];
        } else {
            //其他情况
            if (failure) {
                NSString *failString = @"";
                if ([JMNStringIsEmpty(TJMResponseMessage) isEqualToString:@""]) {
                    failString = @"未知错误，请尝试重新登录";
                } else {
                    failString = TJMResponseMessage;
                }
                failure([responseObject[@"code"] integerValue], failString);
            }
        }
    }
}
+ (void)requestFailureWithSessionDataTask:(NSURLSessionTask *)task error:(NSError *)error failure:(void(^)(NSInteger code, NSString *failString))failure {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger code = response.statusCode;
    if (code == 401 || code == 403) {
        //未授权 授权过期
        if (failure) {
            failure(code, error.localizedDescription);
        }
        //显示 未授权 并 切换到 登录界面
        [[NSNotificationCenter defaultCenter] postNotificationName:ntf_JM_Networking_Logout object:nil];
    } else if (code == 404) {
        failure(code, @"404 NOT FOUND");
    }
    else {
        //其他情况
        if (error.code == - 1009) {
            if (failure) {
                failure(code, @"网络连接错误");
            }
        } else if (error.code == - 1004) {
            if (failure) {
                failure(code, @"连接服务器失败");
            }
        } else if (error.code == - 1001) {
            if (failure) {
                failure(code, @"请求超时");
            }
        }
        else {
            if (failure) {
                failure(code, error.localizedDescription);
            }
        }
        
    }
    
}
/*
 #pragma  mark - sign 处理
 + (NSDictionary *)signWithDictionary:(NSDictionary *)dictionary needTimestamp:(BOOL)isNeed passwordKey:(NSString *)passwordKey {
 //变为可变数组
 NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dictionary];
 //加入时间戳
 if (isNeed) {
 
 [parameters setObject:JMTimestamp forKey:@"timestamp"];
 }
 //MD5 加密
 NSString *pswd = parameters[passwordKey];
 if (![JMNStringIsEmpty(pswd) isEqualToString:@""]) {
 pswd = [pswd MD5];
 parameters[passwordKey] = pswd;
 }
 //升序得到 健值对应的两个数组
 NSArray *allKeyArray = [parameters allKeys];
 NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
 NSComparisonResult resuest = [obj1 compare:obj2];
 return resuest;
 }];
 //通过排列的key值获取value
 NSMutableArray *valueArray = [NSMutableArray array];
 for (NSString *sortsing in afterSortKeyArray) {
 NSString *valueString = [parameters objectForKey:sortsing];
 [valueArray addObject:valueString];
 }
 //健值合并
 NSMutableArray *signArray = [NSMutableArray array];
 for (int i = 0 ; i < afterSortKeyArray.count; i++) {
 NSString *keyValue = [NSString stringWithFormat:@"%@%@",afterSortKeyArray[i],valueArray[i]];
 [signArray addObject:keyValue];
 }
 //signString用于签名的原始参数集合
 NSString *signString = [signArray componentsJoinedByString:@""];
 //秘钥拼接
 signString = [NSString stringWithFormat:@"%@%@%@",TJMSecretKey,signString,TJMSecretKey];
 //MD5加密
 signString = [signString MD5];
 //添加健值  sign
 [parameters setObject:signString forKey:@"sign"];
 return parameters;
 }
 */



@end
