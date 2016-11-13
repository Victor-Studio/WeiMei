//
//  ZRWebTabbar.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/30.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRWebTabbar.h"
#import "ZRWebButton.h"

@implementation ZRWebTabbar

- (instancetype)init{
    if(self = [super init]){
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAlpha:0.9];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if(frame.size.width > 0){
//        frame.origin.x = 0;
//        frame.origin.y = frame.size.height - ZRWebTabbarHeight;
//        frame.size.height = ZRWebTabbarHeight;
    
        //设置上面的横线
        UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        [topLine setBackgroundColor:NavigationBottomColor];
        [self addSubview:topLine];
    }
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat count = 5;
    CGFloat line = 1;
    CGFloat w = self.frame.size.width / count;
    CGFloat y = line;
    CGFloat h = ZRWebTabbarHeight - line;

    [self createButton:CGRectMake(0, y, w, h) image:@"toolbar-btn-backword-normal" highlight:@"toolbar-btn-backword-press" disableImg:@"toolbar-btn-backword-disabled" withTag:1];
    [self createButton:CGRectMake(w, y, w, h) image:@"toolbar-btn-forward-normal" highlight:@"toolbar-btn-forward-press" disableImg:@"toolbar-btn-forward-disabled" withTag:2];
    [self createButton:CGRectMake(w * 2, y, w, h) image:@"toolbar-btn-menu-normal" highlight:@"toolbar-btn-menu-selected" disableImg:@"" withTag:3];
    [self createButton:CGRectMake(w * 3, y, w, h) image:@"toolbar-btn-home-normal" highlight:@"toolbar-btn-home-press" disableImg:@"" withTag:4];
    [self createButton:CGRectMake(w * 4, y, w, h) image:@"toolbar-btn-tabs-normal" highlight:@"toolbar-btn-tabs-press" disableImg:@"" withTag:5];
}

- (void)createButton:(CGRect)rect image:(NSString *)img highlight:(NSString *)highlight disableImg:(NSString *)disableImage withTag:(CGFloat)tag{
    ZRWebButton *button = [ZRWebButton createButton:rect image:img highlight:highlight disableImg:disableImage];
    if([disableImage containsString:@"backword"]){
        self.back  = button;
    } else if([disableImage containsString:@"forward"]){
        self.go = button;
    }
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 1:
            if([self.delegate respondsToSelector:@selector(webTabbarGoBack)]){
                [self.delegate webTabbarGoBack];
            }
            break;
        case 2:
            if([self.delegate respondsToSelector:@selector(webTabbarGoForward)]){
                [self.delegate webTabbarGoForward];
            }
            break;
        case 3:
            if([self.delegate respondsToSelector:@selector(webTabbarShowMenus)]){
                [self.delegate webTabbarShowMenus];
            }
            break;
        case 4:
            if([self.delegate respondsToSelector:@selector(webTabbarShowHome)]){
                [self.delegate webTabbarShowHome];
            }
            break;
        case 5:
            if([self.delegate respondsToSelector:@selector(webTabbarControllersManagement)]){
                [self.delegate webTabbarControllersManagement];
            }
            break;
        default:
            break;
    }
}

@end
