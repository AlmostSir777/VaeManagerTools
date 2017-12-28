//
//  Config.h
//  T-REX
//
//  Created by 锐问 on 15/11/17.
//  Copyright © 2015年 cxy. All rights reserved.
//

#ifndef Config_h

//---------------------------------Common----------------------------\\

//------------------------------屏幕宽高--------------
#define ScreenWidth           [[UIScreen mainScreen]bounds].size.width
#define ScreenHeight          [[UIScreen mainScreen]bounds].size.height

//------------------------------正则表达---------------
/** 手机正则 */
#define RegextestMobile       @"^1([3|5|7|8|])[0-9]{9}$"
/** 密码正则 */
#define RegextestPassword     @"^[@A-Za-z0-9!#$%^&*.~_(){},?:;]{6,20}$"
/** 验证码 */
#define kRegexVerCode         @"^[0-9]{6}$"
/** 邮箱 */
#define RegexestEmail         @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}"

//----------------------------SDK相关数据-----------
//---------------MYH-------------------

#import "VaeAppDelegate.h"
#define g_App               ((VaeAppDelegate*)[[UIApplication sharedApplication] delegate])
#define SelectVC          (CEBaseNavViewController*)g_App.tabBarVC.selectedViewController
#define NSValueToString(a)  [NSString stringWithFormat:@"%@",a]

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)




/**
 * 新定义
 */
#define MainWindow [UIApplication sharedApplication].keyWindow
#define KFONT(size) [UIFont systemFontOfSize:size]
#define kBLOD_FONT(size) [UIFont boldSystemFontOfSize:size]
#define KCOLOR(str) [Utils colorConvertFromString:str]
#define SSCOLOR(str)  [UIColor colorWithHexString:str]
#define KWIDTH(width) [Helper returnUpWidth:width]
#define KHEIGHT(height) [Helper returnUpWidth:height]
#define KURLSTR(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2]
#define K_IMG(str) [UIImage imageNamed:str]

////用户管理类
//#define IS_LOGIN [[UserManager shareManager]isLogin]
//#define USER_MANAGER [UserManager shareManager]


#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]
#define UIColorRGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

// 适配
#define DevicesScale ([UIScreen mainScreen].bounds.size.height==480?1.00:[UIScreen mainScreen].bounds.size.height==568?1.00:[UIScreen mainScreen].bounds.size.height==667?1.17:1.29)

#define weakify(...) \
ext_keywordify \
metamacro_foreach_cxt(ext_weakify_,, __weak, __VA_ARGS__)

#define strongify(...) \
ext_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(ext_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")


//设备型号
#define MOBILE_TYPE  [[[UIDevice currentDevice] identifierForVendor] UUIDString]

/**
 * 通知名类
 */
/**
 * 登出
 */
#define LOGIN_OUT       @"loginOut"
/**
 * 登入
 */
#define LOGIN_IN           @"loginIn"
//------------------------------------------UtilsMacro-------------------------------------------\\

// 打印

#ifdef DEBUG
# define VaeLog(fmt, ...) NSLog((@"📍[函数名:%s]" "🎈[行号:%d]" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__)
# define SSLog(fmt, ...) NSLog((@"📍[函数名:%s]" "🎈[行号:%d]" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define VaeLog(...)
# define SSLog(...)
#endif

#define WSOther(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/**
 *  设置常用设备型号
 *
 *  @return 设备型号
 */
/** iPad */
#define IS_IPad               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** iPhone */
#define IS_IPhone             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** iPhone4 */
#define IS_IPhone4            ([[UIScreen mainScreen] bounds].size.height == 480)
/** iPhone5 */
#define IS_IPhone5            ([[UIScreen mainScreen] bounds].size.height == 568)
/** iPhone6 */
#define IS_IPhone6            ([[UIScreen mainScreen] bounds].size.width == 375)
/** iPhonePlus */
#define IS_IPhonePlus         ([[UIScreen mainScreen] bounds].size.width == 414)

/** 获取设备ID */
#define DEVICE_ID             [[UIDevice currentDevice].identifierForVendor UUIDString]
/** 获取类名 */
#define ClassString NSStringFromClass([self class])


/** 获取系统版本 */
#define SYSTEM_VERSION        [UIDevice currentDevice].systemVersion.floatValue
/** 判断当前iOS系统是否高于iOS7 */
#define IS_IOS7               (SYSTEM_VERSION >= 7.0)
#define IS_IOS8               (SYSTEM_VERSION >= 8.0)

/** 通知中心 */
#define NOTIFICATION          [NSNotificationCenter defaultCenter]
/** NsUserDefault替换 */
#define USERDEFAULTS          [NSUserDefaults standardUserDefaults]
/** 应用程序 */
#define APPLICATION           [UIApplication sharedApplication]
/** URL */
#define URL(url)              [NSURL URLWithString:url]
/** NSInteger 转 NSString */
#define String_Integer(x)     [NSString stringWithFormat:@"%ld",(long)x]
/** [UIImage imageNamed:Description] */
#define Image_Named(str)      [UIImage imageNamed:str]

/** 常用颜色 */
#define Black_Color           [UIColor blackColor]
#define Blue_Color            [UIColor blueColor]
#define Brown_Color           [UIColor brownColor]
#define Clear_Color           [UIColor clearColor]
#define DarkGray_Color        [UIColor darkGrayColor]
#define DarkText_Color        [UIColor darkTextColor]
#define White_Color           [UIColor whiteColor]
#define Yellow_Color          [UIColor yellowColor]
#define Red_Color             [UIColor redColor]
#define Orange_Color          [UIColor orangeColor]
#define Purple_Color          [UIColor purpleColor]
#define LightText_Color       [UIColor lightTextColor]
#define LightGray_Color       [UIColor lightGrayColor]
#define Green_Color           [UIColor greenColor]
#define Gray_Color            [UIColor grayColor]

/** 动态设定字体大小 */
#define Get_Size(x)           IS_IPhonePlus ? ((x) + 1) : IS_IPhone6 ? (x) : (x) - 1

#define Font_Size(x)          [UIFont systemFontOfSize:Get_Size(x)]
#define Font_Bold(y)          [UIFont boldSystemFontOfSize:Get_Size(y)]
#define Font_Slim(y)          [UIFont fontWithName:@"STHeitiTC-Light" size:Get_Size(y)]
#define Font_Name(x,y)        [UIFont fontWithName:(x) size:(y)];


/** 字号设置字号：36pt 30pt 24pt */
#define TitleFont             [UIFont systemFontOfSize:Get_Size(18.0f)]
#define NormalFont            [UIFont systemFontOfSize:Get_Size(15.0f)]
#define ContentFont           [UIFont systemFontOfSize:Get_Size(12.0f)]
#define WS() typeof(self) __weak weakSelf = self;
#define SS() typeof(weakSelf) __strong storngSelf = weakSelf;



#define MWeakSelf(type)  __weak typeof(type) weak##type = type;
#define MStrongSelf(type)  __strong typeof(type) type = weak##type;

//数据处理码
#define ErrorCode @"errCode"
#define ErrorMsg  @"errMsg"
#define Succeed   @"succeed"

#define FIRST_IN_KEY            @"FIRST_IN_KEY"
//定位失败的通知
#define ErrorPlace              @"ERROR_PLACE"

#define TabBarRefresh  @"tabBarRefresh"

#endif


