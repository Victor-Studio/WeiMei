//
//  ZRQuickButton.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/3.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  快捷导航的菜单按钮

#import <UIKit/UIKit.h>

@interface ZRQuickButton : UIButton

//顶级父控制器的frame
@property (nonatomic,assign) CGRect viewFrame;

- (instancetype)initWithTitle:(NSString *)title imagePath:(NSString *)imgPath andFrame:(CGRect)frame;
@end
