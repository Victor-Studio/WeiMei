//
//  ZRAllMenus.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 3/28/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>


//底部tabbar菜单的动画速度
#define ZRTabbarMenusAnimationSpeed 0.25



@protocol ZRAllMenusDelegate <NSObject>

//底部菜单的按钮点击事件
- (void)allMenusForButtonClick:(UIButton *)button withMenusModel:(NSArray *)model;

//移除整个底部菜单
- (void)allMenusForRemoveDetails;

//QQ Login
- (void)allMenusForLogin;

@end



@interface ZRAllMenus : UIView

@property (nonatomic, weak) id<ZRAllMenusDelegate> delegate;

- (instancetype)initWithRect:(CGRect)rect withTabbarRect:(CGRect)rect1;

@end
