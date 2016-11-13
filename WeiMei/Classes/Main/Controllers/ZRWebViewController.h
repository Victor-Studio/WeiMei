//
//  ZRWebViewController.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 15/12/27.
//  Copyright (c) 2015年 XiaoRuiGeGeStudio. All rights reserved.
//


#import <UIKit/UIKit.h> 

@interface ZRWebViewController : UIViewController
  
@property (strong, nonatomic) NSURL *homeUrl; 

/* 单例模式获得统一对象 */
+ (ZRWebViewController *)defaultWebViewController;

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title;

/* 通过URL刷新WebView */
- (void)refreshWebViewWithUrl:(NSString *)urlString;
@end

