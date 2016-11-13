//
//  CommonUtils.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/2.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZRCommonUtils : NSObject

//是否是iPhone4
+ (BOOL)iPhone4:(CGFloat)width heigh:(CGFloat)height;

//是否是iPhone5
+ (BOOL)iPhone5:(CGFloat)width heigh:(CGFloat)height;

//是否是iPhone6
+ (BOOL)iPhone6:(CGFloat)width heigh:(CGFloat)height;

//是否是iPhone6plus
+ (BOOL)iPhone6plus:(CGFloat)width heigh:(CGFloat)height;

//是否是iPad Mini
+ (BOOL)iPadMiniWithWidth:(CGFloat)width heigh:(CGFloat)height;

//是否是iPad Retina
+ (BOOL)iPadRetinaWithWidth:(CGFloat)width heigh:(CGFloat)height;

//是否是iPad Pro
+ (BOOL)iPadProWithWidth:(CGFloat)width heigh:(CGFloat)height;

//HTML转义
- (NSString *)htmlEntityDecode:(NSString *)string;

@end
