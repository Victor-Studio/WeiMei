//
//  ZRHomeScrollView.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 15/12/30.
//  Copyright (c) 2015年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRHomeScrollView.h"
#import "ZRHomeNavViewController.h"
#import "ZRQuickViewController.h"
#import "ZRHomePageControl.h"
#import "ZRWeatherController.h"
#import "Reachability.h"

@interface ZRHomeScrollView()

//@property (nonatomic, assign) BOOL networkAccessibility; //是否可以访问网络

@property (nonatomic, strong) ZRQuickViewController *quickNav;
@property (nonatomic, strong) ZRHomeNavViewController *homeNav;

//@property (nonatomic, strong) ZRWeatherController *weather;

@end

@implementation ZRHomeScrollView

- (instancetype)init
{
    if(self = [super init]) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        
//        // 监测网络情况
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(reachabilityChanged:)
//                                                     name: kReachabilityChangedNotification
//                                                   object: nil];
//        [[Reachability reachabilityWithHostName:@"www.baidu.com"] startNotifier];
    }
    return self;
}

//- (void)reachabilityChanged:(NSNotification *)note
//{
//    Reachability* curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//    NetworkStatus status = [curReach currentReachabilityStatus];
//    
//    //如果没有网络，加载本地的资源
//    if (status == NotReachable) {
//        self.networkAccessibility = NO;
//    } else {
//        self.networkAccessibility = YES;
//    }
//}


//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark - 添加两个基本的控制器
- (void)homeScrollView:(CGRect)frame
{
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    CGFloat y = 44;//HomeScrollViewTopHeight;
    
    self.contentSize = CGSizeMake(w * 2, 0);
    self.frame = frame;
    
    CGFloat columns = 4;
    CGFloat margin = 28;
    CGFloat cellW = (w - margin * (columns + 1)) / columns;
    
    
//    //天气
//    if (self.networkAccessibility) {
//        ZRWeatherController *weather = [[ZRWeatherController alloc] init];
//        weather.view.frame = CGRectMake(0, 0, w, h);
//        self.weather = weather;
//        [self addSubview:weather.view];
//    }
    
    //细分导航
    ZRHomeNavViewController *nav = [[ZRHomeNavViewController alloc] init];
    nav.view.frame = CGRectMake(0, y, w, h);
    self.homeNav = nav;
    [self addSubview:nav.view];
    
    //1. 流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2. 每个cell的尺寸
    layout.itemSize = CGSizeMake(cellW, cellW + 20);
    //3. 设置cell水平间距
    layout.minimumInteritemSpacing = margin;
    //4. 设置垂直间距
    layout.minimumLineSpacing = margin;
    //5. 设置cell的内边距
    //layout.sectionInset =UIEdgeInsetsMake(10, 10, 10, 10);
    
    //快捷导航
    ZRQuickViewController *quick = [[ZRQuickViewController alloc] initWithCollectionViewLayout:layout];
    quick.margin = margin;
    quick.view.frame = CGRectMake(w, y, w, h);
    self.quickNav = quick;
    [self addSubview:quick.view];
}

@end
