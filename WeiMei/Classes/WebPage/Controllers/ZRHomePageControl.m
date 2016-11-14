//
//  ZRHomePageControl.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 15/12/30.
//  Copyright (c) 2015年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRHomePageControl.h"

@implementation ZRHomePageControl

- (instancetype)init{
    if(self = [super init]){
        self.numberOfPages = 2;
        self.currentPage = 0;
        self.currentPageIndicatorTintColor = MainColorRed;
        self.pageIndicatorTintColor = MainColor;
    }
    return self;
}

@end
