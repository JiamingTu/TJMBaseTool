//
//  JMSandBoxManager.h
//  TJMBaseTool
//
//  Created by Jiaming Tu on 2018/6/26.
//

#import <Foundation/Foundation.h>

@interface JMSandBoxManager : NSObject


/**
 在doument 文件夹下 创建文件夹 若存在直接返回

 @param path 下级路径 @“xxx/xxx”
 @return 完整路径
 */
+ (NSString *)createDirectoryAtDocument:(NSString *)path;

/**
 保存实体 等 （遵循 NSCoding 否则返回NO）

 @param instance 实体
 @param name 保存成文件的 文件名
 @return bool
 */
+ (BOOL)saveInstance:(id)instance name:(NSString *)name;

/**
 获取 实体

 @param name 已保存的文件名
 @return id
 */
+ (id)getInstanceWithName:(NSString *)name;

/**
 删除已保存的实体

 @param name 已保存的文件名
 @return bool
 */
+ (BOOL)deleteInstanceWithName:(NSString *)name;

/**
 保存 Array （元素遵循 NSCoding 否则返回NO）

 @param array 数组
 @param name 保存成的文件名
 @return bool
 */
+ (BOOL)saveArray:(NSArray *)array name:(NSString *)name;

/**
 获取 数组

 @param name 已保存的文件名
 @return array
 */
+ (NSArray *)getArrayWithName:(NSString *)name;

/**
 删除已保存的数组

 @param name 已保存的文件名
 @return bool
 */
+ (BOOL)deleteArrayWithName:(NSString *)name;

///plist 增删改查

/**
 从plist 根据key删除

 @param key key
 */
+ (void)deleteValueFromInfoPlistWithKey:(NSString *)key;

+ (__kindof id)modelFromInfoPlistWithKey:(NSString *)key;
+ (void)saveModel:(id)model key:(NSString *)key;

+ (void)setBool:(BOOL)value key:(NSString *)key;
+ (BOOL)boolFromPlistWithKey:(NSString *)key;

+ (void)setString:(NSString *)string key:(NSString *)key;
+ (NSString *)stringFromPlistWithKey:(NSString *)key;

+ (void)setInteger:(NSInteger)value key:(NSString *)key;
+ (NSInteger)integerFromPlistWithKey:(NSString *)key;

+ (void)setFloat:(float)value key:(NSString *)key;
+ (float)floatFromPlistWithKey:(NSString *)key;

+ (void)setDuble:(double)value key:(NSString *)key;
+ (float)doubleFromPlistWithKey:(NSString *)key;


///txt 文件处理

/**
 创建 TXT 文件

 @param string TXT 内容
 @param path 路径（含文件名）
 @param saveResult block
 */
+ (void)creatTxtFileWithSting:(NSString *)string path:(NSString *)path saveResult:(void (^)(BOOL isSave))saveResult;

/**
 删除 TXT 文件

 @param path 路径（含文件名）
 @return bool
 */
+ (BOOL)deleteFileWithPath:(NSString *)path;

/**
 往已有的TXT中添加内容

 @param string 添加的内容
 @param path 路径（含文件名）
 @param updateResult block
 */
+ (void)updateTxtFileWithString:(NSString *)string path:(NSString *)path updateResult:(void (^)(BOOL isSave))updateResult;

/**
 获取TXT中的文字

 @param path 路径（含文件名）
 @return string
 */
+ (NSString *)getTxtStringWithPath:(NSString *)path;


///文件（夹）大小
/**
 单个文件的大小

 @param filePath 文件路径
 @return byte
 */
+ (long long)fileSizeAtPath:(NSString *)filePath;


/**
 文件夹大小

 @param folderPath 文件夹路径
 @return M
 */
+ (float)folderSizeAtPath:(NSString *)folderPath;


///version check
/**
 获取新版本 并是否需要弹框

 @param AppleId AppleId
 @param alert block
 */
- (void)checkVersionRequestWithAppleId:(NSString *)AppleId alert:(void(^)(NSString *newVersion))alert;
@end
