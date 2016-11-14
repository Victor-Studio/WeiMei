//
//  HomeViewController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 15/12/27.
//  Copyright (c) 2015年 XiaoRuiGeGeStudio. All rights reserved.
//


#import "HomeViewController.h"
#import "ZRHomeView.h"
#import "ZRFeatures.h"
#import "ZRFeaturePreference.h"


@interface HomeViewController() 
@property (nonatomic, strong) ZRHomeView *homeView;
@property (nonatomic, strong) ZRFeatures *features;
@property (nonatomic, assign) int i; 
@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.添加控制器到首页
    [self addHomeView];
    
    //2.添加特性
    if(![[[ZRFeaturePreference alloc] init] read])
        [self addFeatures];
    
    //3.设置背景色
    self.view.backgroundColor = MainColor;
}

//1.添加控制器到首页
- (void)addHomeView
{
    ZRHomeView *hView = [[ZRHomeView alloc] init];
    hView.view.frame = self.view.frame;
    [self.view addSubview:hView.view];
    self.homeView = hView;
}

//2.添加特性
- (void)addFeatures
{
    ZRFeatures *features = [[ZRFeatures alloc] init];
    features.showsHorizontalScrollIndicator = NO;
    features.bounces = NO;
    [self.view addSubview:features];
    self.features = features;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    //下一步
    CGFloat nW = 50;
    CGFloat nH = 25;
    CGFloat nX = rect.size.width - nW;
    CGFloat nY = rect.size.height - nH - 8;
    UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setFrame:CGRectMake(nX, nY, nW, nH)];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [next setBackgroundColor:[UIColor orangeColor]];
    [next.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [next addTarget:self action:@selector(nextFeature:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
}
 
- (void)nextFeature:(UIButton *)button
{
    double pointX = self.features.contentOffset.x;
    double width = self.view.frame.size.width;
    __block int tag = 1;
    [UIView animateWithDuration:0.6 animations:^{
        if (pointX == width) {
            tag = 2;
        }else if (pointX == (width * 2)){
            tag = 3;
        }else if (pointX == (width * 3)){
            tag = 4;
            [button setTitle:@"开 门" forState:UIControlStateNormal];
        }else if (pointX == (width * 4)){
            tag = 5;
        }
        if (tag == 5) {
            [self.features setAlpha:0.0];
            [button setAlpha:0.0];
        }else{
            self.features.contentOffset = CGPointMake(tag * self.view.frame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        if (finished && tag == 5) {
            [[[ZRFeaturePreference alloc] init] write];
            [self.features removeFromSuperview];
            [button removeFromSuperview];
        }
    }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations 
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
