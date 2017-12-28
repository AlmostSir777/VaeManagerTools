//
//  Utils.h
//  Library
//
//  Created by fanty on 13-3-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
#define colorzhusediao              @"#DF1327"                     //主色调
#define colorfusediao              @"#FE8787"                     //副色调
#define Colorbg                     @"#F2F2F2"                     //背景色调
#define colorzhusebutton            @"#D64857"                     //主色按钮，渐变
#define colorconfigebuttonselect    @"#D61225"                     //主色按钮，点击态

#define colorgraybuttonnomer        @"#DFDFDF"                     //灰色按钮
#define colorgraybuttonslect        @"#BBBBBB"                     //灰色点击态按钮
#define colorfengeshenseLine        @"#CACAD9"                     //分割线浅
#define colorfengeqianLine          @"#DF1327"                     //分割线深
#define Colorhomebg                 @"#FFFFFF"                    //首页背景

//字体大小

#define  fontnavogitionLablepx      32                          //导航栏标题字体大小约24
#define  fonttitlepx                32                          //标题字体大小
#define  fontcontextTitlepx         30                          //正文字体大小22.5
#define  fonttishititlepx           24                         //提示字体大小21
#define  fontnomerButton            50                          //常用按钮大小

#define  NAVIBARWIDE                10                         //ios7以后导航栏按钮调整
//通用方法收集类
@interface Utils : NSObject


//颜色值转换UIColor ，如#ffffff转  whiteColor
+(UIColor*)colorConvertFromString:(NSString*)value;


//通过像素取得label字体大小
+ (CGFloat)FontandimageImageFromxiangshu:(NSInteger)px;

//是否登录
+ (BOOL)isLogin;

//截取字符串
+(NSString*)trim:(NSString*)value;

//生成缩略图
+(UIImage*)imageWithThumbnail:(UIImage *)image size:(CGSize)thumbSize;


//生成带阴影图
+(UIImage*)imageWithShadow:(UIImage *)initialImage 
              shadowOffset:(CGSize)shadowOffset
             shadowOpacity:(float) shadowOpacity;

//是否有效email
+(BOOL)isValidateEmail:(NSString *)email;

//是否有效phone
+(BOOL)isMobileNumber:(NSString *)mobileNum;

//判断是否ios7以上版本
+(BOOL)isIOS7;

//判断是否ios8以上版本
+(BOOL)isIOS8;

//md5编码一个字符串
+(NSString *)md5:(NSString*)str;

//3des加密
+(NSString*)TripleDES:(NSString*)plainText desKey:(NSString*)desKey;

//为图片增加一个边缘透明像素，抗据齿
+(UIImage*)antialiasedImageOfSize:(UIImage*)image size:(CGSize)size scale:(CGFloat)scale;

//根据变量的引用获取变量名
+(NSString *)nameWithInstance:(id)instance target:(id)target;

//获得的当前设备型号
+(NSString *)getCurrentDeviceModel;

+(BOOL)isNSStringLength:(NSString *)string;

@end
