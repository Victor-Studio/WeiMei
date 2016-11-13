//
//  ZRQuickButton.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/3.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRQuickButton.h"
#import "ZRCommonUtils.h"

#define ZRQuickButtonTitleHeight 20

@interface ZRQuickButton ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation ZRQuickButton

- (instancetype)initWithTitle:(NSString *)title imagePath:(NSString *)imgPath andFrame:(CGRect)frame
{
    if(self = [super init]){
        ZRQuickButton *button = [ZRQuickButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.imageView.contentMode = UIViewContentModeCenter;
        self = button;
        self.button = button;
    }
    return self;
}

- (void)setViewFrame:(CGRect)viewFrame
{
    self.button.titleLabel.font = [UIFont systemFontOfSize:[self fontSizeToScreen:viewFrame]];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height - ZRQuickButtonTitleHeight;
    return CGRectMake(0, 0, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = contentRect.size.height - ZRQuickButtonTitleHeight;
    CGFloat w = contentRect.size.width;
    CGFloat h = ZRQuickButtonTitleHeight;
    return CGRectMake(x, y, w, h);
}

- (CGFloat)fontSizeToScreen:(CGRect)rect
{
    if([ZRCommonUtils iPhone4:rect.size.width heigh:rect.size.height]){
        return 10;
    } else if ([ZRCommonUtils iPhone5:rect.size.width heigh:rect.size.height]){
        return 11;
    } else {
        return 13;
    }
}

@end
