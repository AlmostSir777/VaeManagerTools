//
//  AppInterface.m
//  SmallStuff
//
//  Created by 闵玉辉 on 17/3/30.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "AppInterface.h"
@implementation AppInterface
const NSString * MOBILE = @"mobile";    //手机参数string
const NSString * CODE = @"verifycode"; //验证码参数
const NSString * QD = @"qd";//渠道
const NSString * TYPE = @"type";//验证码类型 1登录注册 3找回密码
const NSString * Code_Type = @"dxtype";//0:语音 ,1:普通短信
const NSString * Nick_name = @"nickname";//用户昵称
const NSString * Sex = @"sex";//性别（0：未知， 1： 男 ， 2：女）
const NSString * Avatar = @"headimg";//用户头像
const NSString * Birth = @"birth";//用户出生年代（例：1980）
const NSString * City = @"city";//用户所在城市
const NSString * District = @"district";//用户所在的区
const NSString * Province = @"province";//用户所在省份
const NSString * Lon = @"lon";//纬度,获取不到时传10000
const NSString * Lat = @"lat";//纬度,获取不到时传10000
const NSString * RegistCode = @"code";//0表示带有注册信息，1表示跳过跳过时，用户昵称、头像、性别、出生年代传空
const NSString * Uid = @"uid";//第三方登录获取的uid




/******************统一常用参数***************************/
const NSString *  Authorization = @"Authorization"; //token
const NSString *  Version = @"Version";//版本号
const NSString * Device = @"Device";//设备
const NSString * Timestamp = @"Timestamp";//时间戳 10位
const NSString * Sign = @"Sign";//参数签名
/******************统一常用参数***************************/
/******************其他常用参数***************************/
const NSString * Mobile = @"mobile";//手机号
const NSString * Type = @"type";//型号
/******************其他常用参数***************************/

/**
 * 通知名类
 */
NSString * otherMessageNoti = @"otherMessageNoti";
NSString * mineMessageNoti = @"mineMessageNoti";
NSString * Dynamic_Top_Noti = @"Dynamic_Top_Noti";
NSString * Dynamic_Top_Clear_Noti  = @"Dynamic_Top_Clear_Noti";

//动态详情页点赞, 评论, 删除等操作的通知 用于通知刷新相关页面
/*
 actionType  1 赞   2 评论   3 删除动态
 showId    动态id
 isLike   是否点赞
 likeNum 赞个数
 comStr     如果是一级评论 这个返回一级评论内容
 comNum 评论个数
 */
NSString * DynamicRefreshNotifyWithInfo  = @"DynamicRefreshNotifyWithInfoDetail";

NSString * Audio_Pause = @"audioPause";

NSString * Menu_Hidden = @"Menu_Hidden";
/**
 * 登出
 */
NSString * LOGIN_OUT    =   @"loginOut";
/**
 * 登入
 */
NSString * LOGIN_IN     =      @"loginIn";
/**
 * 修改用户资料
 */
NSString * REFRESH        =      @"refresh";
/**
 * 修改昵称和头像
 **/
NSString * RefreshNickOrAvatar = @"nickOrAvatarChange";
@end
