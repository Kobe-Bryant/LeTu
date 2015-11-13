//
//  DateUtil.m
//  LeTu
//
//  Created by DT on 14-5-26.
//
//

#import "DateUtil.h"

@implementation DateUtil

+(NSDate*)dateFromString:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

+(NSString*)timeFormatString:(NSString*)date
{
    NSString*str = [date substringWithRange:NSMakeRange(5, 5)];
    
    NSDate *senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    if ([str isEqualToString:locationString]) {
        return [date substringWithRange:NSMakeRange(11, 5)];
    }
    return str;
}

+(NSString *) compareCurrentTimeString:(NSString*) compareString
{
    NSDate *date = [DateUtil dateFromString:compareString];
    return [DateUtil compareCurrentTimeDate:date];
}

+(NSString*)stringFormatDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//+ (NSDate *)dateFromString:(NSString *)dateString
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//    NSDate *destDate= [dateFormatter dateFromString:dateString];
//    
//    return destDate;
//}

+(NSString*)stringFromDate:(NSString*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"YYY-MM-dd";
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([date floatValue] / 1000)]];
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTimeDate:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}







+ (NSString *)intervalFutureNow:(NSString *)futureDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *futureDate = [dateFormatter dateFromString:futureDateStr];
    
    NSTimeInterval future = [futureDate timeIntervalSince1970] * 1;
    
    
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970] * 1;
    
    int minTime = future - now;
    
    NSMutableString *timeStr = [NSMutableString stringWithCapacity:8];
    if (minTime > 0)
    {
        int day = minTime / (24 * 3600);
        int hour = (minTime - 24 * 3600 * day) / 3600;
        int min = (minTime - 24 * 3600 * day - 3600 * hour) / 60;
        [timeStr appendFormat:@"%d天", day];
        [timeStr appendFormat:@"%d小时", hour];
        [timeStr appendFormat:@"%d分", min];
        [timeStr appendFormat:@"%d秒", minTime - 24 * 3600 * day - 3600 * hour - 60 * min];
    }
    
    return timeStr;
}

+ (NSString *)intervalFutureIntervalNow:(NSTimeInterval)future
{
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970] * 1;
    
    int minTime = future - now;
    
    NSMutableString *timeStr = [NSMutableString stringWithCapacity:8];
    if (minTime > 0)
    {
        int day = minTime / (24 * 3600);
        int hour = (minTime - 24 * 3600 * day) / 3600;
        int min = (minTime - 24 * 3600 * day - 3600 * hour) / 60;
        if (day > 0)
            [timeStr appendFormat:@"%d天", day];
        
        if (hour > 0)
            [timeStr appendFormat:@"%d小时", hour];
        
        if (min > 0)
            [timeStr appendFormat:@"%d分", min];
        
        [timeStr appendFormat:@"%d秒", minTime - 24 * 3600 * day - 3600 * hour - 60 * min];
    }
    
    return timeStr;
}

+ (NSString *)intervalSinceNow:(NSString *)sinceDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *sinceDate = [dateFormatter dateFromString:sinceDateStr];
    
    NSTimeInterval since = [sinceDate timeIntervalSince1970] * 1;
    
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970] * 1;
    
    NSTimeInterval cha = now - since;
    
    NSString *timeString = @"";
    if (cha > 864000)
    {
        NSArray *array=[sinceDateStr componentsSeparatedByString:@" "];
        
        return [array objectAtIndex:0];
    }
    else
    {
        if (cha / 3600 < 1)
        {
            if(cha/60<1)
            {
                timeString = @"1";
            }
            else
            {
                timeString = [NSString stringWithFormat:@"%f", cha / 60];
                timeString = [timeString substringToIndex:timeString.length - 7];
            }
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
            
        }
        else if (cha/ 3600 >= 1 && cha / 86400 < 1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha / 3600];
            timeString = [timeString substringToIndex:timeString.length - 7];
            timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        }
        else if (cha / 86400 >= 1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha / 86400];
            timeString = [timeString substringToIndex:timeString.length - 7];
            timeString =[NSString stringWithFormat:@"%@天前", timeString];
            
        }
    }
    
    return timeString;
}

+ (NSString *)timeFormatter:(NSString *)dateStr
{
    //    if (dateStr == nil && [dateStr isEqualToString:@""])
    //    {
    //        return @"";
    //    }
    //
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSMutableString *timeStr = [NSMutableString stringWithCapacity:10];
    //    int hour = [[dateStr substringWithRange:NSMakeRange(11, 2)] intValue];
    NSArray *times = [[[dateStr componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"];
    int hour = [[times objectAtIndex:0] intValue];
    if (hour >= 0 && hour < 6)
    {
        [timeStr appendString:@"凌晨"];
    }
    else if (hour >= 6 && hour < 12)
    {
        [timeStr appendString:@"早上"];
    }
    else if (hour == 12)
    {
        [timeStr appendString:@"中午"];
    }
    else if (hour > 12 && hour < 18)
    {
        [timeStr appendString:@"下午"];
        hour -= 12;
    }
    else if (hour >= 18 && hour < 24)
    {
        [timeStr appendString:@"晚上"];
        hour -= 12;
    }
    //    [dateFormatter setDateFormat:@"h:mm:ss"];
    //    [timeStr appendString:[dateFormatter stringFromDate:date]];
    [timeStr appendFormat:@"%d:%@:%@", hour, [times objectAtIndex:1], [times objectAtIndex:2]];
    
    return timeStr;
}

+ (BOOL)isBetween:(NSString *)startTimeStr endTimeStr:(NSString *)endTimeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:endTimeStr];
    
    NSTimeInterval start = [startDate timeIntervalSince1970] * 1;
    NSTimeInterval end = [endDate timeIntervalSince1970] * 1;
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970] * 1;
    
    if (start <= now && end >= now)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNowAfter:(NSString *)timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    
    NSTimeInterval time = [date timeIntervalSince1970] * 1;
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970] * 1;
    
    if (time > now)
    {
        return YES;
    }
    
    return NO;
}

@end
