//
//  ZRAlertController.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 
@interface ZRAlertController : NSObject

//标配 一个title  一个message  一个确定 
+ (void)alertView:(UIViewController *)viewController0 title:(NSString *)title message:(NSString *)msg handler:(void (^)(void)) callback;

//标配 一个title  一个message  一个确定 一个取消
+ (void)alertView:(UIViewController *)viewController0 message:(NSString *)msg handler:(void (^)(void)) callback;
@end
