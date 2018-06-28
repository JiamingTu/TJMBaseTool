//
//  NSString+Format.m
//  Mould
//
//  Created by Jiaming Tu on 2017/5/23.
//  Copyright © 2017年 fujianzhiyou. All rights reserved.
//

#import "NSString+Format.h"
#import "JMDefine.h"
@implementation NSString (Format)

#pragma  mark - 银行卡号加*
+ (NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum
{
    NSMutableString *mutableStr;
    if (bankNum.length) {
        mutableStr = [NSMutableString stringWithString:bankNum];
        for (NSInteger i = 0 ; i < mutableStr.length; i ++) {
            if (i>2&&i<mutableStr.length - 3) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    return bankNum;
}

+ (NSString *)getTimeWithTimestamp:(NSString *)timestamp formatterStr:(NSString *)formatterStr {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp.integerValue / 1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString *timeString = [formatter stringFromDate:confromTimesp];
    return timeString;
}

+ (NSTimeInterval)getTimestampWithDateString:(NSString *)dateString formatterString:(NSString *)formatterString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterString];
    NSDate *date = [formatter dateFromString:dateString];
    NSTimeInterval timeInterval = date.timeIntervalSince1970;
    return timeInterval;
}

+ (NSString *)isNullToString:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
    {
        return @"";
        
        
    }else
    {
        
        return (NSString *)string;
    }
}

+ (NSString *)timeStringWithTime:(NSString *)time {
    if (![JMStringIsEmpty(time) isEqualToString:@""]) {
        NSInteger x = [time integerValue];
        NSInteger min = x / 60;
        if (min >= 60) {
            return [NSString stringWithFormat:@"%zdhour",min / 60];
        } else {
            return [NSString stringWithFormat:@"%zdmin",min];
        }
    } else {
        return nil;
    }
}

+ (NSString *)colonTimeStringWithTime:(NSInteger)time {
    NSInteger intTime = time;
    NSString * hour = [NSString aboveDoubledigitWithInteger:intTime / 3600];
    NSString * min = [NSString aboveDoubledigitWithInteger: (intTime % 3600) / 60];
    NSString * sec = [NSString aboveDoubledigitWithInteger: (intTime % 3600) % 60];
    return [NSString stringWithFormat:@"%@:%@:%@", hour, min, sec];
}

+ (NSString *)aboveDoubledigitWithInteger:(NSInteger)integer {
    if (integer < 10) {
        return [NSString stringWithFormat:@"0%zd",integer];
    } else {
        return [NSString stringWithFormat:@"%zd",integer];
    }
}

#pragma  mark - 返回日期 格式(例：今天17:30)
+ (NSString *)tjm_setDateFormatterWithTimestamp:(NSInteger)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000];
    NSString *whatDay = [self tjm_compareDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@ %@",whatDay,dateString];
    
}
#pragma  mark 返回 今天 昨天 前天 等
+ (NSString *)tjm_compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *beforeYesterday, *yesterday;
    
    beforeYesterday = [today dateByAddingTimeInterval: - 2 * secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * beforeYesterdayString = [[beforeYesterday description] substringToIndex:10];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatterDateString = [formatter stringFromDate:date];
    NSString * dateString = [[date description] substringToIndex:10];
    if ([dateString isEqualToString:todayString]) {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString]) {
        return @"昨天";
    } else if ([dateString isEqualToString:beforeYesterdayString]) {
        return @"前天";
    } else {
        return formatterDateString;
    }
}

#pragma  mark 转换开工时间
+ (NSString *)tjm_getTimeStringWithTimestamp:(NSInteger)timestamp {
    NSTimeInterval timeInterval = timestamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    // 3.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:[[NSDate alloc]initWithTimeIntervalSince1970:0] toDate:date options:0];
    // 5.返回结果
    NSString *hour = cmps.hour < 10 ? [NSString stringWithFormat:@"0%zd",cmps.hour] : [NSString stringWithFormat:@"%zd",cmps.hour];
    NSString *minute = cmps.minute < 10 ? [NSString stringWithFormat:@"0%zd",cmps.minute] : [NSString stringWithFormat:@"%zd",cmps.minute];
    NSString *second = cmps.second < 10 ? [NSString stringWithFormat:@"0%zd",cmps.second] : [NSString stringWithFormat:@"%zd",cmps.second];
    
    return [NSString stringWithFormat:@"%@:%@:%@",hour,minute,second];
}


@end
