/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Category)

- (NSString *)timeIntervalDescription;//距离当前的时间间隔描述
- (NSString *)minuteDescription;/*精确到分钟的日期描述*/
- (NSString *)formattedTime;
- (NSString *)formattedDateDescription;//格式化日期描述
/** 毫秒*/
- (double)timeIntervalSince1970InMilliSecond;
+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;
+ (NSString *)formattedTimeFromTimeInterval:(long long)time;
// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;


// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
/**
 * 周一、二.....
 */
@property (readonly) NSString *chineaseWeekDay;
@property (readonly) NSInteger year;
/** 当月的第几周  0对应第一周*/
@property (readonly) NSInteger weekLevel;

/** 时间戳*/
@property (nonatomic, readonly) NSTimeInterval timeStemp;
/** 时间戳字符串*/
@property (nonatomic, readonly) NSString *timeStempString;

/** 某一天 的00:00点*/
@property (nonatomic, readonly) NSDate *zeroTime;
/** 某一天 的23:59*/
@property (nonatomic, readonly) NSDate *dayEndTime;
/** 前一月 */
@property (nonatomic, readonly) NSDate *formerMonth;
/** 后一月*/
@property (nonatomic, readonly) NSDate *followMonth;

#pragma mark -Alvin add
- (NSUInteger)numberOfDaysInCurrentMonth;
- (NSDate *)firstDayOfCurrentMonth;
- (NSDate *)lastDayOfCurrentMonth;
- (NSUInteger)weeklyOrdinality;
- (NSUInteger)numberOfWeeksInCurrentMonth;
/** 字符串转时间 yyyy-MM-dd HH:mm*/
+ (NSDate *)dateFromString:(NSString *)dateString;
/** 字符串转时间  年月日*/
+ (NSDate*)convertDateFromString:(NSString*)uiDate;
+ (NSDate *)dateFromString:(NSString *)dateString Format:(NSString *)format;
/** 字符串转时间  yyyy-MM-dd*/
+ (NSDate *)dateFromStringYYMMDD:(NSString *)dateString;

- (NSString *)getDateStringByFormat:(NSString *)format;
/**
 * 获取指定日期 对应周的第一天
 */
+ (NSDate *)getWeekFirstDate:(NSDate *)inputDate;
/**
 * 获取指定日期 对应周的最后一天
 */
+(NSDate *)getWeekLastDate:(NSDate *)inputDate;
/**
 * 获取指定日期是周几
 */
+ (int)weekdayFromDate:(NSDate*)inputDate;

/**
 * 是否是同一天
 */
- (BOOL)isTheSameDayWithDate:(NSDate *)date;
/**
 * 根据年、月、日创建日期
 */
+ (NSDate *)dateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day;
/**
 * 日期所在月 指定周 开始日期 第一周传0
 */
- (NSDate *)beginDateByWeekLevel:(NSInteger)level;
/**
 * 日期所在月 指定周 结束日期 第一周传0
 */
- (NSDate *)endDateByWeekLevel:(NSInteger)level;

@end
