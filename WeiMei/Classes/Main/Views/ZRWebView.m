//
//  ZRUIWebView.m
//  WeiMei
//
//  Created by Victor Zhang on 11/13/16.
//  Copyright © 2016 com.xiaoruigege. All rights reserved.
//

#import "ZRWebView.h"

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



@implementation ZRWKWebView

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






