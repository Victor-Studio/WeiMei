//
//  ZRWebButton.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/30.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRWebButton.h"

@implementation ZRWebButton

+ (ZRWebButton *)createButton:(CGRect)rect image:(NSString *)img highlight:(NSString *)highlight disableImg:(NSString *)disableImage{
    ZRWebButton *button = [[ZRWebButton alloc] initWithFrame:rect];
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];
    if(![disableImage isEqualToString:@""]){
        [button setImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
    }
    return button;
}
 
@end
