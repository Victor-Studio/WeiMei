//
//  ZRScreenCapture.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/5/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//  指定区域截图

#import <Foundation/Foundation.h>

@interface ZRScreenCapture : NSObject 

/**
 * 默认截图整个屏幕，包含UINavigationBar, 但是不包含状态栏
 **/
- (NSString *)screenCaptureNoStatusBar:(UIView *)view;

/**
 * 指定区域大小截图
 **/
- (void)screenCapture:(UIView *)view withWidth:(CGFloat)width withHeight:(CGFloat)height;

@end
