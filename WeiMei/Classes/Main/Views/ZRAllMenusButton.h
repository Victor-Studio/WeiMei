//
//  ZRAllMenusButton.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/5.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  Web页面的底部详细菜单的按钮对象

#import <UIKit/UIKit.h>

@interface ZRAllMenusButton : UIButton

- (ZRAllMenusButton *)allMenusButtonWithFrame:(CGRect)rect withTitle:(NSString *)title withImage:(NSString *)image withFont:(CGFloat)fontSize;

@end
