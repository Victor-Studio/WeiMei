//
//  ZRToast.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  类似安卓的土司效果

#import <Foundation/Foundation.h>


@interface ZRToast : NSObject

+ (void)toastSuccess:(UIViewController *)view;

+ (void)toastFailure:(UIViewController *)view;

@end
