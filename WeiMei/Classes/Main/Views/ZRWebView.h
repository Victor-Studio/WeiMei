//
//  ZRUIWebView.h
//  WeiMei
//
//  Created by Victor Zhang on 11/13/16.
//  Copyright © 2016 com.xiaoruigege. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#define kResultingPlaneAnimationDuration 0.3f

@protocol ZRWebViewDelegate <NSObject>

- (void)showTranslationPlane;

- (void)hideTranslationPlane;

@end


@interface ZRWebView : UIWebView

@end



@interface ZRWKWebView : WKWebView

@property (nonatomic, strong) UIView *webViewSuperView;

@property (nonatomic, weak) id<ZRWebViewDelegate> translationDelegate;

@property (nonatomic, strong) UIView *translateResultView;

@end
