//
//  ZRWeatherController.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/6/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//  首页的左侧滑 天气

#import <UIKit/UIKit.h>


@interface ZRWeatherModel : NSObject
@property (nonatomic, assign) BOOL isFisrtLoad;
+ (instancetype)defaultWeather;
@end

@interface ZRWeatherController : UIViewController

@end
