//
//  ZRAllMenusButton.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/5.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRAllMenusButton.h"

@implementation ZRAllMenusButton

- (ZRAllMenusButton *)allMenusButtonWithFrame:(CGRect)rect withTitle:(NSString *)title withImage:(NSString *)image withFont:(CGFloat)fontSize
{
    ZRAllMenusButton *button = [[ZRAllMenusButton alloc] initWithFrame:rect];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button.imageView setContentMode:UIViewContentModeCenter];
    return button;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    contentRect.size.height = contentRect.size.height * 0.75;
    return contentRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.y = contentRect.size.height * 0.75;
    contentRect.size.height = contentRect.size.height * 0.25; 
    return contentRect;
}


@end
