//
//  ZRBookmarkNavigation.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  书签 或 历史记录的导航栏

#import <UIKit/UIKit.h>

@protocol ZRBookmarkNavigationDelegate <NSObject>

/* 退回上一控制器 */
- (void)bookmarkBackLastController;

/* UISegment切换 */
- (void)bookmarkSegmentChange:(UISegmentedControl *)segment;

/* 右上角清空按钮 */
- (void)bookmarkClearButton;

@end


/* 高度 */
#define ZRBookmarkNavigationHeight ZRNavigationTopHeight

@interface ZRBookmarkNavigation : UIView
@property (nonatomic,weak) id<ZRBookmarkNavigationDelegate> delegate;

/* 设置清空按钮是否可用 */
- (void)setClearButton:(BOOL)isDisable;
 
@end
