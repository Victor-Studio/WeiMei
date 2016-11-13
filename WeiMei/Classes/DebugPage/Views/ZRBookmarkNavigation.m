//
//  ZRBookmarkNavigation.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRBookmarkNavigation.h"

@interface ZRBookmarkNavigation()
@property (nonatomic,assign) CGFloat statusHeight;

@property (nonatomic,strong) UIButton *clearHistoryButton; 
@end

@implementation ZRBookmarkNavigation

- (CGFloat)statusHeight{
    if(_statusHeight == 0){
        _statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 5;
    }
    return _statusHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
 
        CGFloat frameHeight = ZRBookmarkNavigationHeight - 1;
        frame.size.height = frameHeight;
        frame.origin.x = 0;
        frame.origin.y = 0;
        [super setFrame:frame];
        
        if(frame.size.width > 0 && frame.size.height > 0){
            //底部的线条
            UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, frameHeight, frame.size.width, 1)];
            [bottomLine setBackgroundColor:NavigationBottomColor];
            [self addSubview:bottomLine];
            
            //导航栏的返回按钮
            UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
            backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.statusHeight, 25, 21)];
            [backBtn setTintColor:MainColorRed];
            [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(removeContr) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:backBtn];
            
            //右上角清空按钮
            UIButton *rightClear = [UIButton buttonWithType:UIButtonTypeSystem];
            [rightClear setTitle:@"清空" forState:UIControlStateNormal];
            [rightClear setTitleColor:MainColorRed forState:UIControlStateNormal];
            [rightClear setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            CGFloat rcX = self.frame.size.width - 30;
            CGFloat rcY = self.statusHeight - 1;
            rightClear.frame = CGRectMake(rcX, rcY, 35, 30);
            [rightClear addTarget:self action:@selector(clearAllHistory) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rightClear];
            self.clearHistoryButton = rightClear;
            
            //中间的UISegment
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"历史记录",@"书签"]];
            segment.selectedSegmentIndex = 0;
            segment.tintColor = MainColorRed;
            [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
            CGFloat y = self.statusHeight - 4;
            CGFloat w = self.frame.size.width - backBtn.frame.size.width - rightClear.frame.size.width - 50;
            CGFloat x = (self.frame.size.width - w) * 0.5;
            CGFloat h = 33;
            segment.frame = CGRectMake(x, y, w, h);
            [self addSubview:segment];
        }
    }
    return self;
}

- (void)setClearButton:(BOOL)isDisable
{
    [self.clearHistoryButton setHidden:isDisable];
} 

- (void)removeContr
{
    if([self.delegate respondsToSelector:@selector(bookmarkBackLastController)]){
        [self.delegate bookmarkBackLastController];
    }
}

- (void)clearAllHistory
{
    if([self.delegate respondsToSelector:@selector(bookmarkClearButton)]){
        [self.delegate bookmarkClearButton];
    }
}

- (void)segmentChange:(UISegmentedControl *)segment
{
    if([self.delegate respondsToSelector:@selector(bookmarkSegmentChange:)]){
        [self.delegate bookmarkSegmentChange:segment];
    }
}

@end
