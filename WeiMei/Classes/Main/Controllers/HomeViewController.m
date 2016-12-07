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
#import "BDSSpeechSynthesizer.h"


@interface HomeViewController() <UIScrollViewDelegate>
@property (nonatomic, strong) ZRHomeView *homeView;
@property (nonatomic, strong) ZRFeatures *features;
@property (nonatomic, assign) int i;
@property (nonatomic, assign) int buttonScrollTag;
@end

@implementation HomeViewController

- (void)loadView
{
    [super loadView];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MainColor;

    
    //1.添加控制器到首页
    [self addHomeView];
    
    //2.添加特性
    if(![[[ZRFeaturePreference alloc] init] read])
        [self addFeatures];
 
}

//1.添加控制器到首页
- (void)addHomeView
{
    ZRHomeView *hView = [[ZRHomeView alloc] init];
    [self.navigationController pushViewController:hView animated:NO];
    //    hView.view.frame = self.view.frame;
//    [self.view addSubview:hView.view];
//    [self addChildViewController:hView];
    self.homeView = hView;
}

//2.添加特性
- (void)addFeatures
{
    ZRFeatures *features = [[ZRFeatures alloc] initWithFrame:[UIScreen mainScreen].bounds];
    features.showsHorizontalScrollIndicator = NO;
    features.bounces = NO;
    features.delegate = self;
    [self.navigationController.topViewController.view addSubview:features];
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
    [self.navigationController.topViewController.view addSubview:next];
    self.buttonScrollTag = 1;
    
    [self speakByWord:@"欢迎来到唯美浏览器，我将为您简单介绍下新奇特性！"];
    [self speakByWord:@"唯美浏览器，全国五亿人的选择哦！"];
}
 
- (void)nextFeature:(UIButton *)button
{
    double pointX = self.features.contentOffset.x;
    double width = self.view.frame.size.width;
    __block int tag = self.buttonScrollTag;
    [UIView animateWithDuration:0.6 animations:^{
        if (tag == 1) {
            [self speakByWord:@"任何网页，任何网站，随时随刻查询源代码！"];
        }
        if (pointX == width) {
            tag = 2;
            [self speakByWord:@"看大片，看热剧，吐槽，点赞，随心所欲"];
        }else if (pointX == (width * 2)){
            tag = 3;
            [self speakByWord:@"本浏览器允许用户自定发起控制台请求，post或者get"];
        }else if (pointX == (width * 3)){
            tag = 4;
            [button setTitle:@"开 门" forState:UIControlStateNormal];
            [self speakByWord:@"小说用户的喜爱，即将为您开启唯美浏览的世界！！"];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    CGFloat x = point.x;
    CGFloat xValue = 414;
    if (x == xValue) {
        [self speakByWord:@"任何网页，任何网站，随时随刻查询源代码！"];
        self.buttonScrollTag = 2;
    } else if (x == xValue * 2) {
        [self speakByWord:@"看大片，看热剧，吐槽，点赞，随心所欲"];
        self.buttonScrollTag = 3;
    } else if (x == xValue * 3) {
        [self speakByWord:@"本浏览器允许用户自定发起控制台请求，post或者get"];
        self.buttonScrollTag = 4;
    } else if (x == xValue * 4) {
        [self speakByWord:@"小说用户的喜爱，即将为您开启唯美浏览的世界！！"];
        self.buttonScrollTag = 5;
    } else if (x == xValue * 5) {
        
    }
}

- (void)speakByWord:(NSString *)word
{
    NSError* speakerr;
    NSInteger sentenceID = [[BDSSpeechSynthesizer sharedInstance] speakSentence:word withError:&speakerr];
    if (sentenceID == -1) {
        /*错误*/
        NSLog(@"百度发声错误！ error = %@", speakerr);
    }
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
