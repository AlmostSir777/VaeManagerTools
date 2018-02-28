//
//  AppInterface.h
//  SmallStuff
//
//  Created by 闵玉辉 on 17/3/30.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TZAssetCellTypePhoto = 0,
    TZAssetCellTypeLivePhoto,
    TZAssetCellTypePhotoGif,
    TZAssetCellTypeVideo,
    TZAssetCellTypeAudio,
} TZAssetCellType;
typedef NS_ENUM(NSUInteger, CESendRedPacketType) {
    CESendSingleType = 0,//单聊红包
    CESendTeamNormalType = 1,//群普通红包
    CESendTeamOtherType = 2,//群拼手气红包
};
typedef NS_ENUM(NSUInteger, CEMoneyPayType) {
    CEMoney_Normal_Type = 0,//余额
    CEMoney_WX_Type = 1,//微信支付
    CEMoney_ZFB_Type = 2,//支付宝支付
};
typedef NS_ENUM(NSUInteger, AudioState) {
    normal_state = 0,//正常
    animation_state,//动
    buffer_state,//缓冲
};
typedef NS_ENUM(NSUInteger, CENetState) {
     CENetNormal_state = 0,//正常网络
    CENetError_state,//网络错误
    CENetLoading_state,//加载数据
};
typedef enum: NSInteger {
    obligationType = 0,//代付款
    toBeUsedType = 1,//待使用
    doneType = 2,//已完成
    refundedType = 3,//已退款
}CellType;

typedef enum:NSInteger{
    normalPay = 0,//正常支付价钱
    OtherPay = 1,//填写价钱支付
}PayType;
typedef enum:NSInteger{
    CEPhotoTextType = 0,//图文
    CEAudioType = 1,//音频
}CEDynamicType;

typedef enum:NSInteger{
    RedPacket_MakeFriend_BPT= 0,//红包会友余额支付
    RedPacket_SingleChat_BPT = 1,//单聊红包余额支付
    RedPacket_TeamChat_BPT = 2,//群聊红包余额支付
    ShopPay_BPT = 3,//商品余额支付
    DirectPay_BPT = 4,//直接买单
    OccScrPay_BPT = 5,//霸屏支付
    BarragePay_BPT = 6,//弹幕支付
    AutoPay_BPT = 7,//座驾支付
    H5_RedPacket_TeamChat_BPT = 8,//现场群聊红包余额支付
}BalancePayType;
typedef enum:NSInteger{
    Share_MS_Type = 0,//分享奖励
    Unit_MS_Type  = 1,//提成奖励
    WithdrawSuccess_MS_Type = 2,//提现成功奖励
    WithdrawFailed_MS_Type = 3,//提现失败
    RedPacketReturn_MS_Type = 4,//红包退还
    InviteFriend_MS_type = 5,//邀请好友
    DisableSendMsg_MS_Type = 6,//用户被禁言
}MessagingSystemType;
@interface AppInterface : NSObject

extern const NSString * MOBILE;    //手机号码,注意为了避免用户隐私泄露，用户id改成了uuid，用户phone另外新增了字段phone表示，请大家注意，这里的userid其实应该是手机号
extern const NSString * CODE; //验证码参数
extern const NSString * QD;//渠道
extern const NSString * TYPE;//验证码类型 1登录注册 3找回密码
extern const NSString * Code_Type;//0:语音 ,1:普通短信
extern const NSString * Nick_name;//用户昵称
extern const NSString * Sex;//性别（0：未知， 1： 男 ， 2：女）
extern const NSString * Avatar;//用户头像
extern const NSString * Birth;//用户出生年代（例：1980）
extern const NSString * City;//用户所在城市
extern const NSString * District;//用户所在的区
extern const NSString * Province;//用户所在省份
extern const NSString * Lon;//纬度,获取不到时传10000
extern const NSString * Lat;//纬度,获取不到时传10000
extern const NSString * RegistCode;//0表示带有注册信息，1表示跳过跳过时，用户昵称、头像、性别、出生年代传空
extern const NSString * Uid;//第三方登录获取的uid




/******************统一常用参数***************************/
extern const NSString *  Authorization; //token
extern const NSString *  Version;//版本号
extern const NSString * Device;//设备
extern const NSString * Timestamp;//时间戳 10位
extern const NSString * Sign;//参数签名
/******************统一常用参数***************************/
/******************其他常用参数***************************/
extern const NSString * Mobile;//手机号
extern const NSString * Type;//型号
/******************其他常用参数***************************/
//其他用户中心操作
UIKIT_EXTERN  NSString * otherMessageNoti;
//我的动态
UIKIT_EXTERN  NSString * mineMessageNoti;

UIKIT_EXTERN NSString * Dynamic_Top_Noti ;

UIKIT_EXTERN NSString * Dynamic_Top_Clear_Noti ;

UIKIT_EXTERN NSString * DynamicRefreshNotifyWithInfo ;
/**  音频暂停 */
UIKIT_EXTERN NSString * Audio_Pause;

UIKIT_EXTERN NSString * Menu_Hidden;

/**
 * 通知名类
 */
/**
 * 登出
 */
UIKIT_EXTERN NSString * LOGIN_OUT ;
/**
 * 登入
 */
UIKIT_EXTERN NSString * LOGIN_IN ;
/**
 * 修改用户资料
 */
UIKIT_EXTERN NSString * REFRESH ;
/**
 * 修改昵称和头像
 **/
UIKIT_EXTERN NSString * RefreshNickOrAvatar;
@end
