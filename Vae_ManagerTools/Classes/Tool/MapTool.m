//
//  MapTool.m
//  xss
//
//  Created by wzh on 2017/8/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "MapTool.h"
#import "LCActionSheet.h"
#define WEAKSELF     typeof(self) __weak weakSelf = self;
@interface MapTool()<LCActionSheetDelegate>
@property (nonatomic,assign) BOOL GD;
@property (nonatomic,assign) BOOL baidu;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString * mapTitle;

@end
@implementation MapTool


+ (MapTool *)sharedMapTool{


  static MapTool *mapTool = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mapTool = [[MapTool alloc] init];
  });
  
  return mapTool;
  
}
/**
 调用三方导航
 
 @param coordinate 经纬度
 @param name 地图上显示的名字
 @param tager 当前控制器
 */
- (void)navigationActionWithCoordinate:(CLLocationCoordinate2D)coordinate WithENDName:(NSString *)name tager:(UIViewController *)tager{
    self.coordinate = coordinate;
    self.mapTitle = name;
  //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    BOOL isGD = NO;
    BOOL isBaiDu = NO;
  if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
      isGD = YES;
  }
  //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
      isBaiDu = YES;
  }
    self.GD = isGD;
    self.baidu = isBaiDu;
    NSString * baidu = @"百度地图";
    NSString * GD = @"高德地图";
    NSString * Normal = @"苹果地图";
    if(isGD&&isBaiDu)
    {
        LCActionSheet * action = [ LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:Normal ,GD,baidu, nil];
        action.buttonColor = KCOLOR(@"#933BFF");
        action.buttonFont = KFONT(18);
        [action show];
        
    }else if (isGD&&(!isBaiDu))
    {
        LCActionSheet * action = [ LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:Normal ,GD, nil];
        action.buttonColor = KCOLOR(@"#933BFF");
        action.buttonFont = KFONT(18);
        [action show];
    }else if(isBaiDu&&(!isGD))
    {
        LCActionSheet * action = [ LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:Normal ,baidu, nil];
        action.buttonColor = KCOLOR(@"#933BFF");
        action.buttonFont = KFONT(18);
        [action show];
    }
}
-(void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
          [self appleNaiWithCoordinate:self.coordinate andWithMapTitle:self.mapTitle];
        }
            break;
        case 2:
        {
          if(self.GD&&self.baidu)
          {
              [self aNaviWithCoordinate:self.coordinate andWithMapTitle:self.mapTitle];
              
          }else if (self.GD&&(!self.baidu))
          {
              [self aNaviWithCoordinate:self.coordinate andWithMapTitle:self.mapTitle];
              
          }else if (self.baidu&&(!self.GD))
          {
              [self baiduNaviWithCoordinate:self.coordinate andWithMapTitle:self.mapTitle];

          }
        }
            break;
        case 3:
        {
            [self baiduNaviWithCoordinate:self.coordinate andWithMapTitle:self.mapTitle];

        }
            break;
        default:
            break;
    }
}
//唤醒苹果自带导航
- (void)appleNaiWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
  
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    tolocation.name = map_title;
    [MKMapItem openMapsWithItems:@[currentLocation,tolocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                               MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    
}


/**
 高德导航
 */
- (void)aNaviWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",coordinate.latitude,coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];

//    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dname=%@&dev=0&t=0",@"我的位置",_model.addr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)baiduNaviWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
  
  
    NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
    
    
  
}


@end
