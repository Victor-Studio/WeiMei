//
//  UIImage+ZRExtension.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/24.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "UIImage+ZRExtension.h"

@implementation UIImage (ZRExtension)

+ (instancetype)stretchImage:(NSString *)imgPath
{
    UIImage *img = [UIImage imageNamed:imgPath];
    //leftCapWidth:左边不拉伸区域
    //topCapHeight:上面不拉伸区域
    return [img stretchableImageWithLeftCapWidth:img.size.width * 0.5f topCapHeight:img.size.height * 0.5f];
}

@end
