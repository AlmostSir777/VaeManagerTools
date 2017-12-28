//
//  Tool.m
//  AnXin
//
//  Created by wt on 14-2-28.
//  Copyright (c) 2014年 wt. All rights reserved.
//

#import "Tool.h"
#import "CommonCrypto/CommonDigest.h"
#import "Config.h"

// Standard library
#include <stdint.h>
#include <stdio.h>

// Core Foundation
#include <CoreFoundation/CoreFoundation.h>

// Cryptography
#include <CommonCrypto/CommonDigest.h>

//---------------------------------------------------------
// Function definition
//---------------------------------------------------------

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,
                      (const void *)buffer,
                      (CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}


@implementation Tool

+(NSString *)md5:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (NSString *)computeMD5HashOfFileInPath:(NSString *) filePath
{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)filePath, FileHashDefaultChunkSizeForReadingData);
}

+ (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//判空操作的代码
+ (NSString*)strOrEmpty:(NSString*)str{
	return (str==nil?@"":str);
}

// 数据文件路径
+ (NSString *)dataFilePath:(NSString *)str {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:str];
}

//判断电话号码
+ (BOOL)validatePhone:(NSString *)phone {
    NSString *emailRegex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:phone];
}

//判断email
+ (BOOL)validateEmail:(NSString *)email {
//    NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断是否是汉字
+ (BOOL)isOrChinese:(NSString *)chinese{
    
    NSString * textStr=@"^[\u4e00-\u9fa5]+$";//[\u4e00-\u9fa5]+
    NSPredicate * chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textStr];
    return [chineseTest evaluateWithObject:chinese];
}


//判断email
+ (BOOL)validatePasswd:(NSString *)passwd {
    NSString *passwdRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *passwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwdRegex];
    return [passwdTest evaluateWithObject:passwd];
}


+ (NSDate*)getShortDateFormString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:str];
}

+ (NSDate*)getDateFormString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:str];
}

+ (NSDate*)getDateAndTimeFormString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter dateFromString:str];
}

+ (NSDate*)getTimeFormString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    return [formatter dateFromString:str];
}


+ (NSString*)getStringFormDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSString*)getStringFormDateAndTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}
+ (NSString*)getStringMonthAndDayFormDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    return [formatter stringFromDate:date];
}

+ (NSString*)getStringTimeAndWeekFormDate:(NSDate*)date {
    if (!date) {
        return nil;
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps;
    comps = [calendar components:unitFlags fromDate:date];

    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd"];
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:[formatter stringFromDate:date]];
    switch (weekday) {
        case 1:
            [string appendString:@"(周日)"];
            break;
        case 2:
            [string appendString:@"(周一)"];
            break;
        case 3:
            [string appendString:@"(周二)"];
            break;
        case 4:
            [string appendString:@"(周三)"];
            break;
        case 5:
            [string appendString:@"(周四)"];
            break;
        case 6:
            [string appendString:@"(周五)"];
            break;
        case 7:
            [string appendString:@"(周六)"];
            break;

        default:
            break;
    }
    return string;
}

+ (NSString*)getShortStringTimeAndWeekFormDate:(NSDate*)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps;
    comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:[formatter stringFromDate:date]];
    switch (weekday) {
        case 1:
            [string appendString:@"(周日)"];
            break;
        case 2:
            [string appendString:@"(周一)"];
            break;
        case 3:
            [string appendString:@"(周二)"];
            break;
        case 4:
            [string appendString:@"(周三)"];
            break;
        case 5:
            [string appendString:@"(周四)"];
            break;
        case 6:
            [string appendString:@"(周五)"];
            break;
        case 7:
            [string appendString:@"(周六)"];
            break;
            
        default:
            break;
    }
    return string;
}



+ (NSString*)arrayChangeToString:(NSArray*)array withSplit:(NSString*)split {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0 ; i < array.count; i++) {
        [string appendString:[array objectAtIndex:i]];
        if (i != array.count - 1) {
            [string appendString:split];
        }
    }
    return string;
}

+ (NSArray*)changeStringToArray:(NSString*)string {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    return [string componentsSeparatedByCharactersInSet:characterSet];
}

//显示缓存大小
+ (NSString *)displayCache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
    float roomMax=0;
    roomMax=[self  folderSizeAtPath:documentDirectory];
    if (roomMax>1024.0&&roomMax<1024.0*1024.0) {
        return [NSString stringWithFormat:@"%.fKB",roomMax/1024.0];
    }else if (roomMax>1024.0*1024.0){
        return [NSString stringWithFormat:@"%.2fMB",roomMax/(1024.0*1024.0)];
    }else{
        return @"0KB";
    }
}

+ (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (BOOL)showGuideView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id flag = [userDefaults objectForKey:@"userGuide"];
    if (flag) {
        return NO;
    } else {
        [userDefaults setBool:YES forKey:@"userGuide"];
        [userDefaults synchronize];
        return YES;
    }
}

#pragma mark - codeAuto

@end
