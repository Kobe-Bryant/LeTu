//
//  DateUtil.h
//  LeTu
//
//  Created by DT on 14-5-26.
//
//

#import <Foundation/Foundation.h>

/**
 *  时间类
 */
@interface DateUtil : NSObject

/**
 *  时间String转Date
 *
 *  @param dateString string类型时间格式
 *
 *  @return
 */
+(NSDate*)dateFromString:(NSString*)dateString;

+(NSString*)timeFormatString:(NSString*)date;
/**
 *  时间转化成String
 *
 *  @param date date类型时间
 *
 *  @return string类型时间
 */
+(NSString*)stringFormatDate:(NSDate*)date;
/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTimeDate:(NSDate*) compareDate;

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTimeString:(NSString*) compareString;

/*
 * 以后到现在的时间
 * return NSString 'dd天hh小时mm分钟ss秒'
 *
 */
+ (NSString *)intervalFutureNow:(NSString *)futureDateStr;

/*
 * 以后到现在的时间
 * return NSString 'dd天hh小时mm分ss秒'
 *
 */
+ (NSString *)intervalFutureIntervalNow:(NSTimeInterval)future;

/*
 * 以前到现在的时间
 * return NSString 'dd天前'、hh小时前、mm分钟前、'dd天hh小时mm分钟'
 *
 */
+ (NSString *)intervalSinceNow:(NSString *)sinceDateStr;

/*
 * 设置时间模式
 * return NSString 早上(晚上等)8:50
 *
 */
+ (NSString *)timeFormatter:(NSString *)dateStr;

/*
 * 当前时间是否在startTime endTime之间
 *
 */
+ (BOOL)isBetween:(NSString *)startTimeStr endTimeStr:(NSString *)endTimeStr;

/*
 * time是否在当前时间之后
 *
 */
+ (BOOL)isNowAfter:(NSString *)timeStr;
@end
