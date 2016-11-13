//
//  ZRToast.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRToast.h"

@implementation ZRToast

+ (void)toastSuccess:(UIViewController *)view
{
    [ZRToast showView:@"已成功!" withImage:@"toast_success" withFrame:view];
}

+ (void)toastFailure:(UIViewController *)view
{
    [ZRToast showView:@"已失败!" withImage:@"toast_failure" withFrame:view];
}

+ (void)showView:(NSString *)title withImage:(NSString *)imagePath withFrame:(UIViewController *)view
{
    UIView *v = [[UIView alloc] initWithFrame:view.view.frame];
    
    UILabel *blabel = [[UILabel alloc] initWithFrame:v.frame];
    [blabel setBackgroundColor:[UIColor blackColor]];
    [blabel setAlpha:0.1];
    [v addSubview:blabel];
    
    CGFloat centerW = 130;
    CGFloat centerH = centerW;
    CGFloat centerX = (view.view.frame.size.width - centerW) / 2;
    CGFloat centerY = (view.view.frame.size.height - centerH) / 2 - 34;
    UIView *center = [[UIView alloc] initWithFrame:CGRectMake(centerX, centerY, centerW, centerH)];
    [center setBackgroundColor:[UIColor whiteColor]];
    [center setAlpha:0.9];
    [center.layer setCornerRadius:17];
    [v addSubview:center];
    
    CGFloat imageW = 60;
    CGFloat imageH = imageW;
    CGFloat imageX = (centerW - imageW) / 2;
    CGFloat imageY = 20;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    [image setImage:[UIImage imageNamed:imagePath]];
    image.tintColor = [UIColor greenColor];
    [center addSubview:image];
    
    CGFloat labelH = 30;
    CGFloat labelY = imageH + 25;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageX, labelY, imageW, labelH)];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setTextColor:ZRColor(0, 102.0f, 0)];
    [center addSubview:label];
    
    [view.view addSubview:v];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v removeFromSuperview];
    });
}

@end
