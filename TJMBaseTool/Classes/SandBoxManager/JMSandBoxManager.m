//
//  JMSandBoxManager.m
//  TJMBaseTool
//
//  Created by Jiaming Tu on 2018/6/26.
//

#import "JMSandBoxManager.h"
static NSString *const SBM_INSTANCE_DIR_NAME = @"jm_instance";
static NSString *const SBM_ARRAY_DIR_NAME = @"jm_array";

// 日志输出
#ifdef DEBUG // 开发阶段-DEBUG阶段:使用Log
#define SBMLog(...) NSLog(__VA_ARGS__)
#else // 发布阶段-上线阶段:移除Log
#define SBMLog(...)
#endif

@implementation JMSandBoxManager

#pragma  mark - base
+ (NSString *)getDocumentDirecrory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirecrory = [paths objectAtIndex:0];
    return documentDirecrory;
}

+ (NSString *)createDirectoryAtDocument:(NSString *)path {
    if (!path) return nil;
    if ([[path substringToIndex:1] isEqualToString:@"/"]) return nil;
    NSString *documentDir = [self getDocumentDirecrory];
    NSString *targetDirectory = [documentDir stringByAppendingPathComponent:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:targetDirectory]) {
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:targetDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (result) {
            return targetDirectory;
        } else {
            return nil;
        }
    } else {
        return targetDirectory;
    }
}

#pragma  mark - 保存实体
+ (BOOL)saveInstance:(id)instance name:(NSString *)name {
    //是否遵循NSCoding 协议 不遵循 返回NO
    BOOL isCoding = [[instance class] conformsToProtocol:@protocol(NSCoding)];
    if (isCoding) {
        NSString *filePath = [[self createDirectoryAtDocument:SBM_INSTANCE_DIR_NAME] stringByAppendingPathComponent:name];
        SBMLog(@"%@", filePath);
        BOOL result = [NSKeyedArchiver archiveRootObject:instance toFile: filePath];
        return result;
    }
    return NO;
}

+ (id)getInstanceWithName:(NSString *)name {
    NSString *filePath = [[self createDirectoryAtDocument:SBM_INSTANCE_DIR_NAME] stringByAppendingPathComponent:name];
    id instance = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return instance;
}

+ (BOOL)deleteInstanceWithName:(NSString *)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dir = [self createDirectoryAtDocument:SBM_INSTANCE_DIR_NAME];
    if ([fileManager fileExistsAtPath:dir]) {
        NSError *error = nil;
        NSString *path = [dir stringByAppendingPathComponent:name];
        BOOL result = [fileManager removeItemAtPath:path error:&error];
        if (result) {
            return YES;
        } else {
            SBMLog(@"instance delete fail，%@",error);
            return NO;
        }
    } else {
        SBMLog(@"instance dir not exist");
        return NO;
    }
}

#pragma  mark - 保存数组
+ (BOOL)saveArray:(NSArray *)array name:(NSString *)name {
    //是否遵循NSCoding 协议 不遵循 返回NO
    for (id instance in array) {
        BOOL isCoding = [[instance class] conformsToProtocol:@protocol(NSCoding)];
        if (!isCoding) return NO;
    }
    NSString *filePath = [[self createDirectoryAtDocument:SBM_ARRAY_DIR_NAME] stringByAppendingPathComponent:name];
    BOOL result = [NSKeyedArchiver archiveRootObject:array toFile:filePath];
    return result;
}

+ (NSArray *)getArrayWithName:(NSString *)name {
    NSString *filePath = [[self createDirectoryAtDocument:SBM_ARRAY_DIR_NAME] stringByAppendingPathComponent:name];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return array;
}

+ (BOOL)deleteArrayWithName:(NSString *)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dir = [self createDirectoryAtDocument:SBM_ARRAY_DIR_NAME];
    if ([fileManager fileExistsAtPath:dir]) {
        NSError *error = nil;
        NSString *path = [dir stringByAppendingPathComponent:name];
        BOOL result = [fileManager removeItemAtPath:path error:&error];
        if (result) {
            return YES;
        } else {
            SBMLog(@"array delete fail，%@",error);
            return NO;
        }
    } else {
        SBMLog(@"array dir not exist");
        return NO;
    }
}

#pragma  mark - 存在plist
#pragma  mark 删除
+ (void)deleteValueFromInfoPlistWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

#pragma  mark 存取
+ (__kindof id)modelFromInfoPlistWithKey:(NSString *)key {
    NSData *data =[[NSUserDefaults standardUserDefaults] dataForKey:key];
    if (data) {
        id model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model;
    } else {
        return nil;
    }
}
+ (void)saveModel:(id)model key:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    }
}

+ (void)setBool:(BOOL)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
}
+ (BOOL)boolFromPlistWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setString:(NSString *)string key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
}
+ (NSString *)stringFromPlistWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (void)setInteger:(NSInteger)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}
+ (NSInteger)integerFromPlistWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)setFloat:(float)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
}
+ (float)floatFromPlistWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

+ (void)setDuble:(double)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
}
+ (float)doubleFromPlistWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

#pragma  mark - 存 txt

+ (void)creatTxtFileWithSting:(NSString *)string path:(NSString *)path saveResult:(void (^)(BOOL isSave))saveResult {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //\n
        BOOL isSaved = [[NSFileManager defaultManager] createFileAtPath:path contents:[string dataUsingEncoding:NSUTF8StringEncoding]  attributes:nil];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (saveResult) {
                saveResult(isSaved);
            }
        }];
    });
}

+ (BOOL)deleteFileWithPath:(NSString *)path {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

+ (void)updateTxtFileWithString:(NSString *)string path:(NSString *)path updateResult:(void (^)(BOOL isSave))updateResult {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //\n
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
               if (updateResult) updateResult(NO);
            }];
        } else {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
            [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
            NSData* stringData  = [string dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData]; //追加写入数据
            [fileHandle closeFile];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (updateResult) updateResult(YES);
            }];
        }
    });
}

+ (NSString *)getTxtStringWithPath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    return nil;
}

#pragma  mark - 文件（夹） 大小
//单个文件的大小
+ (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


#pragma  mark - software version
#pragma  mark - 版本确认
+ (void)checkVersionRequestFromAppStroreWithAppleId:(NSString *)AppleId alert:(void(^)(NSString *newVersion))alert  {
        NSString *urlStr = @"http://itunes.apple.com/cn/lookup";
//    NSString *url = @"http://itunes.apple.com/lookup";
    
    NSString *queryUrlStr = [NSString stringWithFormat:@"%@?id=%@", urlStr, AppleId];
    NSURL *url = [NSURL URLWithString:queryUrlStr];
    
    //2.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //3.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求路径
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     注意：
     1）该方法内部会自动将请求路径包装成一个请求对象，该请求对象默认包含了请求头信息和请求方法（GET）
     2）如果要发送的是POST请求，则不能使用该方法
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            SBMLog(@"get version from apple.com fail : %@", error.localizedDescription);
        } else {
            //5.解析数据
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            SBMLog(@"%@",responseObject);
            if (responseObject) {
                NSArray *array = responseObject[@"results"];
                if (array.count != 0) {// 先判断返回的数据是否为空
                    NSDictionary *dict = array[0];
                    NSString *version = dict[@"version"];
                    if (version) {
                        [self checkWithNewVersion:version alert:alert];
                    }
                }
            }
        }
    }];
    
    //4.执行任务
    [dataTask resume];
}

+ (void)checkWithNewVersion:(NSString *)newVersion alert:(void(^)(NSString *newVersion))alert {
    //判断此版本是否为忽略更新版本
    NSString *ignoreVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kIgnoreVersion];
    if (ignoreVersion) {
        if (![ignoreVersion isEqualToString:newVersion] && [self judgeNewVersion:newVersion withOldVersion:JMAppVersion]) {
            //如果这个新版本不是忽略版本，且当前版本比新版本旧，则提示更新
            if (alert) alert(newVersion);
        }
    } else {
        if ([self judgeNewVersion:newVersion withOldVersion:JMAppVersion]) {
            //提示更新
            if (alert) alert(newVersion);
        }
    }
}

//判断当前app版本和AppStore最新app版本大小
+ (BOOL)judgeNewVersion:(NSString *)newVersion withOldVersion:(NSString *)oldVersion {
    NSArray *newArray = [newVersion componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    NSArray *oldArray = [oldVersion componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    for (NSInteger i = 0; i < newArray.count; i ++) {
        NSInteger newValue = [newArray[i] integerValue];
        NSInteger oloValue = [oldArray[i] integerValue];
        if (newValue > oloValue) {
            return YES;
        } else if (newValue < oloValue) {
            return NO;
        } else {
            continue;
        }
    }
    return NO;
}

@end
