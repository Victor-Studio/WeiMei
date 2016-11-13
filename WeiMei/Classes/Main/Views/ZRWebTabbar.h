//
//  ZRWebTabbar.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/30.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  Web 的 tabbar

#import <UIKit/UIKit.h>

/* 浏览器的前进或者后退控制 */
@protocol ZRWebTabbarDelegate <NSObject>

/* 后退 */
- (void)webTabbarGoBack;

/* 前进 */
- (void)webTabbarGoForward;

/* 显示菜单 */
- (void)webTabbarShowMenus;

/* 显示首页 */
- (void)webTabbarShowHome;

/* tabbar的控制器 */
- (void)webTabbarControllersManagement;

@end




#define ZRWebTabbarHeight 44

@interface ZRWebTabbar : UIView

/* 是否可以后退 */
@property (nonatomic, strong) UIButton *back;

/* 是否可以前进 */
@property (nonatomic, strong) UIButton *go;

@property (nonatomic,weak) id<ZRWebTabbarDelegate> delegate;

@end
