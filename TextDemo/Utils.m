//
//  Utils.m
//  Library
//
//  Created by fanty on 13-3-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <sys/utsname.h>
#import <zlib.h>
#import <objc/runtime.h>
#import "AppDelegate.h"         //新增的

@implementation Utils

+(UIColor*)colorConvertFromString:(NSString*)value{
    if([value length]<7)return [UIColor whiteColor];
    
    SEL blackSel = NSSelectorFromString(value);
    if ([UIColor respondsToSelector: blackSel]){
        UIColor* color  = [UIColor performSelector:blackSel];
        if(color!=nil)
            return color;
    }
    
    NSRange range;
    range.location=1;
    range.length=2;
    NSString* r=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    range.location=3;
    NSString* g=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    range.location=5;
    NSString* b=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    
    
    float rColor=0;
    float gColor=0;
    float bColor=0;
    float alpha=1;
    
    [[NSScanner scannerWithString:r] scanHexFloat:&rColor];
    [[NSScanner scannerWithString:g] scanHexFloat:&gColor];
    [[NSScanner scannerWithString:b] scanHexFloat:&bColor];
    
    
    rColor=rColor / 255;
    gColor=gColor / 255;
    bColor=bColor / 255;
    
    
    if([value length]==9){
        range.location=7;
        NSString* a=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
        
        [[NSScanner scannerWithString:a] scanHexFloat:&alpha];
        
        alpha=alpha / 255;
    }
    
    return [UIColor colorWithRed:rColor green:gColor blue:bColor alpha:alpha];
}

#pragma mark 新增的方法
+ (BOOL)isLogin{

//    if (g_App.access_token.length==0) {
//        return NO;
//    }else{
//        return YES;
//    }
    return NO;
}

+ (CGFloat)FontandimageImageFromxiangshu:(NSInteger)px{
    CGFloat font =(px*72)/96;
    return font;
}

+(NSString*)trim:(NSString*)value{
    return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ];
}

+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//+(BOOL)isMobileNumber:(NSString *)mobileNum
//{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,134,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+(UIImage*)imageWithThumbnail:(UIImage *)image size:(CGSize)thumbSize{
    
    CGSize imageSize = image.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    
    CGFloat scaleFactor = 0.0;
    
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    
    else {
        
        scaleFactor = heightFactor;
        
    }
    
    CGFloat scaledWidth  = width * scaleFactor;
    
    CGFloat scaledHeight = height * scaleFactor;
    
    if (widthFactor > heightFactor){
        
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    
    else if (widthFactor < heightFactor){
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    
    CGRect thumbRect = CGRectZero;
    
    thumbRect.origin = thumbPoint;
    
    thumbRect.size.width  = scaledWidth;
    
    thumbRect.size.height = scaledHeight;
    
    [image drawInRect:thumbRect];
    
    
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return thumbImage;
}


+(UIImage*)imageWithShadow:(UIImage *)initialImage shadowOffset:(CGSize)shadowOffset
             shadowOpacity:(float) shadowOpacity{
    
    UIColor* color=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:shadowOpacity];
    
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, initialImage.size.width + 10, initialImage.size.height + 10, CGImageGetBitsPerComponent(initialImage.CGImage), 0, colourSpace, 1);//kCGImageAlphaPremultipliedLast
    
    
    
    
    CGColorSpaceRelease(colourSpace);
    
    CGContextSetShadowWithColor(shadowContext, shadowOffset, 7, [color CGColor]);

    
    
    CGContextDrawImage(shadowContext, CGRectMake(5, 5, initialImage.size.width, initialImage.size.height), initialImage.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    
    return shadowedImage;
}

+(BOOL)isIOS7{
    return ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0f);
}

+(BOOL)isIOS8{
    return ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0f);
}


+(NSString *)md5:(NSString*)str{
    
    if([str length]<1)
        return nil;
    
    const char *value = [str UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}


//+(NSString*)TripleDES:(NSString*)plainText desKey:(NSString*)desKey{
//    
//    CCOperation encryptOrDecrypt=kCCEncrypt;
//    
//    const void *vplainText;
//    size_t plainTextBufferSize;
//    
//    if (encryptOrDecrypt == kCCDecrypt)//解密
//    {
//        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
//        plainTextBufferSize = [EncryptData length];
//        vplainText = [EncryptData bytes];
//    }
//    else //加密
//    {
//        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//        plainTextBufferSize = [data length];
//        vplainText = (const void *)[data bytes];
//    }
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
//    
//    const void *vkey = (const void *)[desKey UTF8String];
//    // NSString *initVec = @"init Vec";
//    //const void *vinitVec = (const void *) [initVec UTF8String];
//    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
//    CCCrypt(encryptOrDecrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       vkey,
//                       kCCKeySize3DES,
//                       nil,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    
//    NSString *result;
//    
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
//                                                                length:(NSUInteger)movedBytes]
//                                        encoding:NSUTF8StringEncoding];
//    }
//    else
//    {
//        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//        result = [GTMBase64 stringByEncodingData:myData];
//    }
//    
//    free(bufferPtr);
//    
//    return result;
//}

+(UIImage*)antialiasedImageOfSize:(UIImage*)image size:(CGSize)size scale:(CGFloat)scale{
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [image drawInRect:CGRectMake(1, 1, size.width-2, size.height-2)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSString *)nameWithInstance:(id)instance target:(id)target
{
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([target class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ((object_getIvar(target, thisIvar) == instance)) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
}



///获得设备型号
+(NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}


//添加新的方法
+(BOOL)isNSStringLength:(NSString *)string
{
    if (string.length>0) {
        return YES;
    }else{
        return NO;
    }
}



@end
