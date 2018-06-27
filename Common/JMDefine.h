//
//  JMDefine.h
//  Pods
//
//  Created by Jiaming Tu on 2018/6/22.
//

#ifndef JMDefine_h
#define JMDefine_h

//屏幕尺寸 长边始终是高
#define JMScreenWidth ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
#define JMScreenHeight ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)


#define JM_IS_IPHONE_X (JMScreenHeight == 812.f)

// 日志输出
#ifdef DEBUG // 开发阶段-DEBUG阶段:使用Log
#define JMLog(...) NSLog(__VA_ARGS__)
#else // 发布阶段-上线阶段:移除Log
#define JMLog(...)
#endif

//字符串是否空 空 return @“” 非空 return string
#define JMStringIsEmpty(string) ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] ? @"" : string )


//iOS版本
#define JMCurrentDevice [[[UIDevice currentDevice] systemVersion] floatValue]
//App版本
#define JMAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

static NSString *const kIgnoreVersion = @"JM_IgnoreVersion";

#endif /* JMDefine_h */
