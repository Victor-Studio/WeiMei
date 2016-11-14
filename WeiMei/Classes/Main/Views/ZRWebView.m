//
//  ZRUIWebView.m
//  WeiMei
//
//  Created by Victor Zhang on 11/13/16.
//  Copyright © 2016 com.xiaoruigege. All rights reserved.
//

#import "ZRWebView.h"


#define kResultingPlaneAnimationDuration 0.3f

@implementation ZRWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIMenuItem *translation = [[UIMenuItem alloc] initWithTitle:@"翻译"action:@selector(translate:)];
        UIMenuItem *copying = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copying:)];
        UIMenuController *menu =[UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:translation, copying, nil]];
    }
    return self;
}

- (void)translate:(UIMenuItem *)menuItem
{
    NSString *selection = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    printf("title=%s", [selection UTF8String]);
}

- (void)copying:(UIMenuItem *)menuItem
{
    
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(translate:) ||
        action == @selector(copying:)) {
        return YES;
    }
    return NO;
}

@end


@interface ZRWKWebView()

@property (nonatomic, strong) UILabel *originTextLabel;

@property (nonatomic, strong) UILabel *destinationTextLable;

@end

@implementation ZRWKWebView

- (UIView *)translateResultView
{
    if (!_translateResultView) {
        CGFloat w = self.frame.size.width;
        CGFloat h = 100;
        CGFloat y = self.frame.size.height;
        _translateResultView = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, h)];
        _translateResultView.backgroundColor = [UIColor whiteColor];
        _translateResultView.layer.shadowColor = [UIColor blackColor].CGColor;
        _translateResultView.layer.shadowOpacity = 0.3;
        _translateResultView.layer.shadowOffset = CGSizeMake(0, -6);
        _translateResultView.alpha = 0.f;
        [self addSubview:_translateResultView];
        
        [UIView animateWithDuration:kResultingPlaneAnimationDuration animations:^{
            self.translateResultView.alpha = 1.f;
            CGRect rect = self.translateResultView.frame;
            rect.origin.y = self.frame.size.height - h;
            self.translateResultView.frame = rect;
        }];
        
        CGFloat margin = 15;
        
        //原文
        CGFloat otW = w - margin * 2;
        CGFloat otH = 20;
        CGFloat otX = margin;
        CGFloat otY = margin;
        UILabel *originText = [[UILabel alloc] initWithFrame:CGRectMake(otX, otY, otW, otH)];
        originText.textColor = [UIColor blackColor];
        originText.font = [UIFont systemFontOfSize:15];
        [_translateResultView addSubview:originText];
        self.originTextLabel = originText;
        
        //译文
        CGFloat dtW = otW;
        CGFloat dtH = otH * 2;
        CGFloat dtX = margin;
        CGFloat dtY = otH + margin * 2;
        UILabel *destinationText = [[UILabel alloc] initWithFrame:CGRectMake(dtX, dtY, dtW, dtH)];
        destinationText.textColor = [UIColor blackColor];
        destinationText.font = [UIFont systemFontOfSize:15];
        destinationText.numberOfLines = 0;
        [_translateResultView addSubview:destinationText];
        self.destinationTextLable = destinationText;
     
        //操作面板
        CGFloat pcW = otW;
        CGFloat pcH = otH;
        CGFloat pcX = margin;
        CGFloat pcY = h - pcH;
        UIView *planeCtrl = [[UIView alloc] initWithFrame:CGRectMake(pcX, pcY, pcW, pcH)];
        [_translateResultView addSubview:planeCtrl];
        
        //关闭按钮
        CGFloat cbW = 80;
        CGFloat cbX = otW - cbW;
        CGFloat cbH = pcH;
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(cbX, 0, cbW, cbH)];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        closeBtn.backgroundColor = [UIColor redColor];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        closeBtn.titleLabel.textColor = MainColorRed;
        [closeBtn addTarget:self action:@selector(closeResultPlane:) forControlEvents:UIControlEventTouchUpInside];
        [planeCtrl addSubview:closeBtn];
        
        
    }
    return _translateResultView;
}

//关闭翻译面板
- (void)closeResultPlane:(UIButton *)button
{
    [UIView animateWithDuration:kResultingPlaneAnimationDuration animations:^{
        self.translateResultView.alpha = 0.f;
        CGRect rect = self.translateResultView.frame;
        rect.origin.y = self.frame.size.height;
        self.translateResultView.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.translateResultView removeFromSuperview];
            self.translateResultView = nil;
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIMenuItem *translation = [[UIMenuItem alloc] initWithTitle:@"翻译"action:@selector(translate:)];
        UIMenuItem *copying = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copying:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:translation, copying, nil]];
    }
    return self;
}

- (void)translate:(UIMenuItem *)menuItem
{
    [self evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        printf("title=%s", [value UTF8String]);
        
        [self translateResultView];
        self.originTextLabel.text = value;
        self.destinationTextLable.text = value;
    }];

}

- (void)copying:(UIMenuItem *)menuItem
{
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(translate:) ||
        action == @selector(copying:)) {
        return YES;
    }
    return NO;
}
@end






