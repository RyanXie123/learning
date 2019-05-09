//
//  NSDate+Extension.m
//  XR_Douyin
//
//  Created by 谢汝 on 2018/9/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)formatTime:(NSTimeInterval)timeInerval {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeInerval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    if ([date isToday]) {
        if ([date isJustNow]) {
            return @"刚刚";
        }else {
            formatter.dateFormat = @"HH:mm";
            return [formatter stringFromDate:date];
        }
    }else {
        if ([date isYesterDay]) {
            formatter.dateFormat = @"昨天HH:mm";
            return [formatter stringFromDate:date];
        }else if ([date isCurrentWeek]){
            formatter.dateFormat = [NSString stringWithFormat:@"%@%@",[date dateToWeekday],@"HH:mm"];
            return [formatter stringFromDate:date];
        }else {
            if ([date isCurrentYear]) {
                formatter.dateFormat = @"MM-dd HH:mm";
            }else {
                formatter.dateFormat = @"yy-MM-dd  HH:mm";
            }
            return [formatter stringFromDate:date];
        }
        
        
        
        
    }
    

    
}


- (NSString *)dateToWeekday {
    NSArray *weekdays = [NSArray arrayWithObjects: @"", @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


- (BOOL)isJustNow {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return (fabs(now - self.timeIntervalSince1970 ) < 60 * 2);
}

- (BOOL)isCurrentYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    return nowComponents.year == selfComponents.year;
}

- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.day == nowComponents.day);

}

- (BOOL)isCurrentWeek {
    NSDate *nowDate = [[NSDate date]dateFormatYMD];
    NSDate *selfDate = [self dateFormatYMD];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day < 7;
    
//    NSDateComponents *cmps = []
    
}
- (BOOL)isYesterDay {
    NSDate *nowDate = [[NSDate date]dateFormatYMD];
    NSDate *selfDate = [self dateFormatYMD];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
    
    
}




- (NSDate *)dateFormatYMD {
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}


@end
