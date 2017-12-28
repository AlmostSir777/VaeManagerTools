//
//  Tool.h
//  AnXin
//
//  Created by wt on 14-2-28.
//  Copyright (c) 2014年 wt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <CoreFoundation/CoreFoundation.h>

// In bytes
#define FileHashDefaultChunkSizeForReadingData 4096


// Extern
#if defined(__cplusplus)
#define FILEMD5HASH_EXTERN extern "C"
#else
#define FILEMD5HASH_EXTERN extern
#endif

//---------------------------------------------------------
// Function declaration
//---------------------------------------------------------

FILEMD5HASH_EXTERN CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                                         size_t chunkSizeForReadingData);


@interface Tool : NSObject


+(UIColor*)colorConvertFromString:(NSString*)value;//通过这个类把颜色转化成16进制


/**
 *  MD5加密
 */
+ (NSString *)md5:(NSString *)srcString;



/**
 *  MD5文件加密
 */
+(NSString *)computeMD5HashOfFileInPath:(NSString *) filePath;

/**
 * 文件大小
 */
+ (long long)fileSizeAtPath:(NSString*) filePath;

/**
 *  判断字符串是否为空
 */
+ (NSString*)strOrEmpty:(NSString*)str;

/**
 *  数据文件路径
 */
+ (NSString *)dataFilePath:(NSString *)_str;

/**
 *  判断电话号码
 */
+ (BOOL)validatePhone:(NSString *)phone;

/**
 *  判断email
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  判断是否是汉字
 */
+ (BOOL)isOrChinese:(NSString *)chinese;


/**
 *  时间格式
 */
+ (NSDate*)getShortDateFormString:(NSString*)str;
+ (NSDate*)getDateFormString:(NSString*)str;

+ (NSDate*)getDateAndTimeFormString:(NSString*)str;
+ (NSDate*)getTimeFormString:(NSString*)str;

+ (NSString*)getStringFormDate:(NSDate*)date;
+ (NSString*)getStringFormDateAndTime:(NSDate*)date;
+ (NSString*)getStringTimeAndWeekFormDate:(NSDate*)date;

+ (NSString*)getStringMonthAndDayFormDate:(NSDate*)date;
+ (NSString*)getShortStringTimeAndWeekFormDate:(NSDate*)date;

// 数组格式化成字符串
+ (NSString*)arrayChangeToString:(NSArray*)array withSplit:(NSString*)split;

+ (NSArray*)changeStringToArray:(NSString*)string;

+ (NSString *)displayCache;

+ (BOOL)showGuideView;

//code适配
+ (void)codeAutoWithLeft:(CGFloat)left andRight:(CGFloat)right andTop:(CGFloat)top andBottom:(CGFloat)bottom andWidth:(CGFloat)width andHeight:(CGFloat)height;
@end
