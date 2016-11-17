//
//  ZRHomeView.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 15/12/30.
//  Copyright (c) 2015年 XiaoRuiGeGeStudio. All rights reserved.
//  顶部导航搜索框，语音搜索，二维码扫描

#import "ZRHomeView.h"
#import "ZRHomeScrollView.h"
#import "ZRHomePageControl.h"
#import "ZRQRCodeScanView.h"
#import "ZRSearchHitsViewController.h"
#import "ZRRegularExpression.h"
#import "ZRWebViewController.h"
#import "ZRWebNavigation.h"
//#import "ZRWeatherController.h"

@interface ZRHomeView ()

@property (nonatomic,strong) ZRHomeScrollView *homeScrollView;

//@property (nonatomic,strong) ZRHomePageControl *homePageControl;

@property (nonatomic, strong) UIView *topSearchBan;

@end


@implementation ZRHomeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MainColor;
    
    //1.添加控制器
    [self addHomeScroll];
    
    //2.添加页码
//    [self addPageControl];

    //3.设置基本配置
//    [self configBasic];
    
    
    //4.添加一个顶部搜索框
    [self configTopSearch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIApplication *shared = [UIApplication sharedApplication];
    if (shared.statusBarHidden) {
        [shared setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
    
    if (shared.statusBarStyle == UIStatusBarStyleLightContent) {
        [shared setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

#pragma mark - 1.添加控制器
- (void)addHomeScroll{
    ZRHomeScrollView *scroll = [[ZRHomeScrollView alloc] init];
    [scroll homeScrollView:self.view.frame];
    [self.view addSubview:scroll];
    self.homeScrollView = scroll;
}
 
#pragma mark - 2.添加页码
//- (void)addPageControl{
//    ZRHomePageControl *page = [[ZRHomePageControl alloc]  init];
//    CGFloat h = 10;
//    CGFloat y = self.view.frame.size.height - h;
//    CGFloat w = self.view.frame.size.width;
//    page.frame = CGRectMake(0, y, w, h);
//    [self.view addSubview:page];
//    self.homePageControl = page;
//}

#pragma mark - 3.设置基本配置
//- (void)configBasic
//{
//    self.homeScrollView.delegate = self;
//    self.homeScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
//}

#pragma mark - UIScrollViewDelegate的代理事件
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat x = scrollView.contentOffset.x; 
//    CGFloat width = self.view.frame.size.width;
//    CGFloat width2 = width * 0.5;
//    CGFloat width3 = width * 1.5;
//    if (x <= width2) {
//        self.homePageControl.currentPage = 0;
//        
//        //表示已经加载了一次
////        [[ZRWeatherModel defaultWeather] setIsFisrtLoad:YES];
//        
//        //让顶部搜索框隐藏
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        
//        [UIView animateWithDuration:1.0 animations:^{
//            [self.topSearchBan setAlpha:0];
//        } completion:^(BOOL finished) {
//            if (finished) {
//                self.topSearchBan.hidden = YES;
//            }
//        }];
//    } else if (x > width2 && x <= width3){
//        self.homePageControl.currentPage = 1;
//        
//        //让顶部搜索框显示
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        [UIView animateWithDuration:1.0 animations:^{
//            [self.topSearchBan setAlpha:1];
//        } completion:^(BOOL finished) {
//            if (finished) {
//                self.topSearchBan.hidden = NO;
//            }
//        }];
//    } else {
//        self.homePageControl.currentPage = 0;
//    }
//}

#pragma mark - 4.添加一个顶部搜索框
- (void)configTopSearch
{
    UIView *topSearch = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HomeScrollViewTopHeight)];
    [topSearch setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topSearch];
    self.topSearchBan = topSearch;
    
    //创建底部灰色线
    CGFloat blW = topSearch.frame.size.width;
    CGFloat blH = 1;
    CGFloat blY = topSearch.frame.size.height;
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, blY, blW, blH)];
    [bottomLabel setBackgroundColor:ZRColor(234.0f, 235.0f, 237.0f)];
    [topSearch addSubview:bottomLabel];
    
    //创建搜索框 UITextField遮挡物
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height + 4;
    CGRect rect = topSearch.frame;
    CGFloat marginBar = 5;
    rect.origin.x = marginBar;
    rect.origin.y = statusH;
    rect.size.height = 35;
    rect.size.width = topSearch.frame.size.width - marginBar * 2;
    UIView *searView = [[UIView alloc] initWithFrame:rect];
    [searView setBackgroundColor:MainColor];
    [topSearch addSubview:searView];

    //搜索图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_search"]];
    CGFloat sIconW = rect.size.height - marginBar * 2;
    searchIcon.frame = CGRectMake(marginBar, marginBar, sIconW, sIconW);
    [searView addSubview:searchIcon];
    
    //创建语音按钮
    CGFloat imgW = searchIcon.frame.size.width;
    CGFloat imgH = searchIcon.frame.size.height;
    CGFloat imgX = searView.frame.size.width - imgW - marginBar ;
    CGFloat imgY = marginBar;
    CGRect qrRect = CGRectMake(imgX,imgY,imgW, imgH);
//    UIButton *voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
//    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"voicerecord_icon_btn"] forState:UIControlStateNormal];
//    [voiceBtn addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchUpInside];
//    [searView addSubview:voiceBtn];
//    
//    //分割线
//    CGFloat lineH = searView.frame.size.height - marginBar * 3;
//    CGFloat lineX = imgX - marginBar * 2;
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(lineX, marginBar * 1.5, 1, lineH)];
//    [line setBackgroundColor:[UIColor lightGrayColor]];
//    [searView addSubview:line];
    
    //创建二维码按钮
//    CGFloat qrW = searchIcon.frame.size.width;
//    CGFloat qrH = searchIcon.frame.size.height;
//    CGFloat qrX = lineX - qrW - marginBar * 1.5 ;
//    CGFloat qrY = marginBar;
//    CGRect qrr = CGRectMake(qrX, qrY, qrW, qrH)

    
//    UIButton *qrcodeBtn = [[UIButton alloc] initWithFrame:qrRect];
//    [qrcodeBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_entry_btn"] forState:UIControlStateNormal];
//    [qrcodeBtn addTarget:self action:@selector(qrSwip:) forControlEvents:UIControlEventTouchUpInside];
//    [searView addSubview:qrcodeBtn];

    //提示文字
    CGFloat searLX = searchIcon.frame.size.width + marginBar * 2;
    CGFloat searLY = marginBar * 1.5;
    CGFloat searLW = searView.frame.size.width - qrRect.size.width - imgW - sIconW;
    CGFloat searLH = searchIcon.frame.size.height - marginBar;
    UILabel *searLabel = [[UILabel alloc] initWithFrame:CGRectMake(searLX, searLY, searLW, searLH)];
    [searLabel setUserInteractionEnabled:YES];
    [searLabel setText:@"搜索或输入网址"];
    [searLabel setTextColor:[UIColor lightGrayColor]];
    [searLabel setFont:[UIFont systemFontOfSize:13]];
    [searLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusSearch)]];
    [searView addSubview:searLabel]; 
}

#pragma mark 聚集搜索焦点
- (void)focusSearch
{
    ZRSearchHitsViewController *searchHit = [[ZRSearchHitsViewController alloc] init]; 
    [self addChildViewController:searchHit];
    [self.view addSubview:searchHit.view];
}

#pragma mark - 二维码扫描
- (void)qrSwip:(UIButton *)button
{
    self.navigationController.navigationBar.hidden = NO;
    ZRAlertController *alert = [ZRAlertController defaultAlert];
    ZRQRCodeScanView *qrcode = [[ZRQRCodeScanView alloc] init];
    [qrcode openQRCodeScan:self completion:^(NSString *responseData, int statusCode) {
        if([ZRRegularExpression isURL:responseData]){
            [[ZRWebViewController defaultWebViewController] refreshWebViewWithUrl:responseData];
        } else {
            [alert alertShowWithTitle:@"" message:[NSString stringWithFormat:@"结果是:%@", responseData] okayButton:@"Okay" completion:nil];
        }
    }];
}

//#pragma mark - 语音搜索
//- (void)voiceClick
//{
//    NSLog(@"voiceClick");
//}
@end
