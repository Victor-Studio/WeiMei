//
//  ZROriginalNavController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/7.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRNavController.h"

@interface ZRNavController ()

@end

@implementation ZRNavController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end
