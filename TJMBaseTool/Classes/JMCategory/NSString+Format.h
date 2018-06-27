//
//  NSString+Format.h
//  Mould
//
//  Created by Jiaming Tu on 2017/5/23.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Format)
/**银行卡号加* */
+ (NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum;
/**时间戳 格式化*/
+ (NSString *)getTimeWithTimestamp:(NSString *)timestamp formatterStr:(NSString *)formatterStr;

/**
 获取时间戳

 @param dateString 已格式化的时间
 @param formatterString 格式
 @return timeinterval
 */
+ (NSTimeInterval)getTimestampWithDateString:(NSString *)dateString formatterString:(NSString *)formatterString;

/**秒 转 时分秒*/
+ (NSString *)timeStringWithTime:(NSString *)time;

/**转 00:00:00*/
+ (NSString *)colonTimeStringWithTime:(NSInteger)time;

@end
