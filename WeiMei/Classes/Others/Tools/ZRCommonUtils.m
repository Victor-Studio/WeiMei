//
//  CommonUtils.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/2.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRCommonUtils.h"

@implementation ZRCommonUtils

#pragma mark 是否是iPhone4
+ (BOOL)iPhone4:(CGFloat)width heigh:(CGFloat)height
{
    if((width == 320 && height == 480) || (width == 480 && height == 320))
        return YES;
    else
        return NO;
}

#pragma mark 是否是iPhone5
+ (BOOL)iPhone5:(CGFloat)width heigh:(CGFloat)height
{
    if((width == 320 && height == 568) || (width == 568 && height == 320))
        return YES;
    else
        return NO;
}

#pragma mark 是否是iPhone6
+ (BOOL)iPhone6:(CGFloat)width heigh:(CGFloat)height
{
    if((width == 375 && height == 667) || (width == 667 && height == 375))
        return YES;
    else
        return NO;
}

#pragma mark 是否是iPhone6plus
+ (BOOL)iPhone6plus:(CGFloat)width heigh:(CGFloat)height
{
    if((width == 414 && height == 736) || (width == 736 && height == 414))
        return YES;
    else
        return NO;
}

#pragma mark 是否是iPad Mini
+ (BOOL)iPadMiniWithWidth:(CGFloat)width heigh:(CGFloat)height
{
    if((width == 768 && height == 1024) || (width == 1024 && height == 768))
        return YES;
    else
        return NO;
}

#pragma mark 是否是iPad Retina
+ (BOOL)iPadRetinaWithWidth:(CGFloat)width heigh:(CGFloat)height
{
    if((width == 1536 && height == 2048) || (width == 2048 && height == 1536))
        return YES;
    else
        return NO;
}

#pragma mark 是否是iPad Pro
+ (BOOL)iPadProWithWidth:(CGFloat)width heigh:(CGFloat)height
{
    if((width == 2732 && height == 2048) || (width == 2048 && height == 2732))
        return YES;
    else
        return NO;
}

#pragma mark - HTML转义
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"&qqqq;"];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"&qooo;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return string;
}

@end
