//
//  ZRWebViewController.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 15/12/27.
//  Copyright (c) 2015年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRWebViewController.h"
#import "ZROriginalCodeController.h"
#import "ZRNavController.h"
#import "ZRHistoryPage.h"
#import "ZRWebNavigation.h"
#import "ZRWebTabbar.h"
#import "ZRBookmarkController.h"
#import "ZRAlertController.h"
#import "ZRAllMenus.h"
#import "ZRAllMenusModel.h"
#import "ZRAllMenusButton.h"
#import "ZRLoginController.h"
#import "ZRScreenCapture.h"
#import "ZRPageManage.h"
#import "ZRPageManageController.h"
#import "ZRWebView.h"




#define kWebViewWidth  [UIScreen mainScreen].bounds.size.width
#define kWebViewHeight [UIScreen mainScreen].bounds.size.height
#define IOS8x (DeviceVersion >= 8.0)
 
#define WebViewNav_TintColor [UIColor lightGrayColor]

@interface ZRWebViewController ()
<UIWebViewDelegate,
UIScrollViewDelegate,
UIActionSheetDelegate,
WKNavigationDelegate,
UISearchBarDelegate,
ZRWebViewDelegate,
//ZRWebNavigationDelete,
ZRWebTabbarDelegate,
ZRAllMenusDelegate>


@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) ZRWebView *webView;
@property (strong, nonatomic) ZRWKWebView *wkWebView;
@property (nonatomic, copy) NSString *currentTitle;
@property (nonatomic, copy) NSString *currentURL;

/* 导航栏 */
//@property (nonatomic,strong) ZRWebNavigation *zrNavigation;

/* 底部tabbar */
@property (nonatomic,strong) ZRWebTabbar *tabbar;

/* tabbar的菜单 */
@property (nonatomic,strong) UIView *tabbarMenus;

/* 是否已记录 */
@property (nonatomic,assign) BOOL isAddHistory;

/* 滚动记录值 */
@property (nonatomic,assign) CGFloat scrollingValue;

@property (nonatomic, strong) UISearchBar *titleSearchBar;

/* 书签和历史记录控制器 */
@property (nonatomic,strong) ZRBookmarkController *bookmarkController;


/* 圆圈进度条 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

//搜索背景
@property (nonatomic, strong) UIView *searchbarBackgroundView;

@end

/* 单例对象  初始化nil */
static ZRWebViewController *webViewController = nil;

@implementation ZRWebViewController

- (UIActivityIndicatorView *)indicatorView
{
    if(!_indicatorView){
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect rect = self.view.frame;
        CGFloat w = 30;
        CGFloat x = (rect.size.width - w) / 2;
        CGFloat y = (rect.size.height - w) / 2;
        _indicatorView.frame = CGRectMake(x, y, w, w);
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (void)setCurrentURL:(NSString *)currentURL
{
    _currentURL = currentURL;
    
    self.titleSearchBar.text = currentURL;
}

//停止IndicatorView的圆圈
- (void)stopIndicatorView
{
    if([[self indicatorView] isAnimating])
        [[self indicatorView] stopAnimating];
}

/* 单例对象获得统一对象 */
+ (ZRWebViewController *)defaultWebViewController
{
    @synchronized (self){
        if(!webViewController){
            webViewController = [[self alloc] init];
        }
    }
    return webViewController;
}

- (id)copy { return webViewController; }

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self){
        if(!webViewController){
            webViewController = [super allocWithZone:zone];
        }
    }
    return webViewController;
}

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title {
    if(!webViewController){
        [self defaultWebViewController];
     
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        webViewController.homeUrl = [NSURL URLWithString:urlStr];
        webViewController.title = title;

        ZRWebNavigationController *nav = [[ZRWebNavigationController alloc] initWithRootViewController:webViewController];
        nav.modalPresentationStyle = UIModalPresentationPageSheet;
        
        //跳转控制器
        [[[[UIApplication sharedApplication].windows objectAtIndex:0] rootViewController] presentViewController:nav animated:NO completion:nil];
    }
}

/* 通过URL刷新WebView */
- (void)refreshWebViewWithUrl:(NSString *)urlString
{
    if(urlString.length <= 6) return;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if(IOS8x){
        [self.wkWebView loadRequest:request];
    }else{
        [self.webView loadRequest:request];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    [self configBarItems];
    [self configUI];
//    [self configNavigation];
    [self configTabbar];
    [[self indicatorView] startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tabbar.back setEnabled:NO];
    [self.tabbar.go setEnabled:NO];
}

- (void)configBarItems
{
    //左边按钮
    UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 21)];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(removeController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    //中间的view
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kWebViewWidth - 80, 44)];
    searchBar.tintColor = MainColorRed;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    self.titleSearchBar = searchBar;
    
    //右边按钮
    UIImage *menuImage = [UIImage imageNamed:@"cc_webview_menu"];
    menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuBtn setTintColor:[UIColor whiteColor]];
    [menuBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 8)];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchbarBackgroundView removeFromSuperview];
    [self.titleSearchBar resignFirstResponder];
    
    NSString *urlstr = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (urlstr.length <= 0) {
        return;
    }
    
    if (![urlstr hasPrefix:@"http://"] && ![urlstr hasPrefix:@"https://"] && ![urlstr hasPrefix:@"ftp://"]) {
        urlstr = [NSString stringWithFormat:@"http://%@", urlstr];
    }
    
    searchBar.text = urlstr;
    [self refreshWebViewWithUrl:urlstr];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    UIView *translucentView = [[UIView alloc] initWithFrame:rect];
    translucentView.backgroundColor = [UIColor blackColor];
    translucentView.alpha = 0.3;
    [translucentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSearchBackground:)]];
    [self.view addSubview:translucentView];
    self.searchbarBackgroundView = translucentView;
}

- (void)removeSearchBackground:(UIView *)view
{
    [self.searchbarBackgroundView removeFromSuperview];
    [self.titleSearchBar resignFirstResponder];
}

/*
#pragma mark - 添加导航栏
- (void)configNavigation
{
    ZRWebNavigation *nav = [[ZRWebNavigation alloc] init];
    nav.frame = self.view.frame;
    nav.delegate = self;
    [self.view addSubview:nav];
    self.zrNavigation = nav;
}
*/

#pragma mark - 添加tabbar
- (void)configTabbar
{
    ZRWebTabbar *tabbar = [[ZRWebTabbar alloc] init];
    tabbar.frame = CGRectMake(0, kWebViewHeight - ZRWebTabbarHeight - 64, kWebViewWidth, ZRWebTabbarHeight);
    tabbar.delegate = self;
    [self.view addSubview:tabbar];
    self.tabbar = tabbar;
}

#pragma mark - ZRWebNavigationDelegate的代理事件
#pragma mark 移除控制器
- (void)removeController{
    self.wkWebView.scrollView.delegate = nil;
    webViewController = nil;
   [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark 显示菜单
- (void)showMenu{
    [self menuBtnPressed];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if([UIApplication sharedApplication].networkActivityIndicatorVisible){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)configUI
{
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.progressTintColor = [UIColor redColor];//ZRColor(229.0f, 57.0f, 225.0f);
    progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    CGRect newRect = self.view.frame;
    newRect.origin.y = 0;
    newRect.size.height = newRect.size.height - ZRWebTabbarHeight;
    
    // 网页
    __weak typeof(self) weakSelf = self;
    if (IOS8x) {
        ZRWKWebView *wkWebView = [[ZRWKWebView alloc] init];
        wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        wkWebView.backgroundColor = MainColor;
        wkWebView.frame = newRect;
        wkWebView.navigationDelegate = weakSelf;
        wkWebView.scrollView.delegate = weakSelf;
        wkWebView.translationDelegate = self;
        wkWebView.webViewSuperView = self.view;
        [self.view insertSubview:wkWebView belowSubview:progressView];
        
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [wkWebView loadRequest:request];
        self.wkWebView = wkWebView;
    }else {
        ZRWebView *webView = [[ZRWebView alloc] init];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = MainColor;
        webView.frame = newRect;
        webView.delegate = weakSelf;
        webView.scrollView.delegate = weakSelf;
        [self.view insertSubview:webView belowSubview:progressView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [webView loadRequest:request];
        self.webView = webView;
    } 
}

/*
#pragma mark - UIWebView和WKWebView的代理事件 滚动时控制 导航栏的显示与否
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scroll = scrollView.contentOffset.y;
    
    if(scroll > 0 && scroll > self.scrollingValue){
    //从下往上滚
        
        //将UIProgressView提高到最顶部
        CGRect progressRect = self.progressView.frame;
        progressRect.origin.y = 0;
        self.progressView.frame = progressRect;
        
//        if(![UIApplication sharedApplication].statusBarHidden)
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
        //隐藏导航栏，增加WebView的高度
        [UIView animateWithDuration:1 animations:^{
            [self.zrNavigation setHidden:YES];
            
            if(IOS8x){
                CGRect rect = self.wkWebView.frame;
                if(rect.origin.y != 0){
                    rect.size.height += ZRNavigationHeight;
                    rect.origin.y = 0;
                    self.wkWebView.frame = rect;
                }
            }else{
                CGRect rect = self.webView.frame;
                if(rect.origin.y != 0){
                    rect.size.height += ZRNavigationHeight;
                    rect.origin.y = 0;
                    self.webView.frame = rect;
                }
            }
            
        }];
    }else if(scroll < (ZRNavigationHeight + 20)){
    //从上往下滚 当导航栏高度+20小于滚动高度时，即显示导航栏
        
        //将UIProgressView恢复到原始位置
        CGRect progressRect = self.progressView.frame;
        progressRect.origin.y = ZRNavigationHeight;
        self.progressView.frame = progressRect;
        
//        if([UIApplication sharedApplication].statusBarHidden)
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
        //显示导航栏，减少WebView的高度
        [UIView animateWithDuration:1 animations:^{
            [self.zrNavigation setHidden:NO];
            
            if(IOS8x){
                CGRect rect = self.wkWebView.frame;
                if(rect.origin.y == 0){
                    rect.size.height -= ZRNavigationHeight;
                    rect.origin.y = ZRNavigationHeight;
                    self.wkWebView.frame = rect;
                }
            }else{
                CGRect rect = self.webView.frame;
                if(rect.origin.y == 0){
                    rect.size.height -= ZRNavigationHeight;
                    rect.origin.y = ZRNavigationHeight;
                    self.webView.frame = rect;
                }
            }
            
        }];
    }else{
//        if([UIApplication sharedApplication].statusBarHidden)
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
    self.scrollingValue = scroll; 
}
*/

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView){
        if([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            }else {
                self.progressView.hidden = NO;
                [self setProgressColorBy:newprogress];
                [self.progressView setProgress:newprogress animated:YES];
            }
        }
    }
}

- (void)dealloc
{
    if (IOS8x) {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    webViewController = nil;
}

#pragma mark - 菜单按钮事件
- (void)menuBtnPressed {
    [self activityShareComponents];
}


#pragma mark - wkWebView代理
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self startNetworkActivity];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self endNetworkActivity];
    
    self.currentURL = webView.URL.absoluteString;
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id i, NSError *error) {
        //记录历史记录
        [self addHistory:i withURLString:webView.URL.absoluteString];
        self.currentTitle = i;
    }];
    [self backOrGoButton];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self endNetworkActivity];
    NSLog(@"WKWebView加载网页失败");
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
     
    // 如果不添加这个，那么wkwebview跳转不了AppStore
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    //是否可以后退或者前进
    if(![self.wkWebView canGoForward]){
        [self.tabbar.go setEnabled:NO];
    }
    if(![self.wkWebView canGoBack]){
        [self.tabbar.back setEnabled:NO];
    }
}


#pragma mark - UIWebView代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"] ;
    NSString *curUrl = request.URL.absoluteString;
    self.currentTitle = webTitle;
    self.currentURL = curUrl;
    
    //记录历史记录
    [self addHistory:webTitle withURLString:curUrl];
    
    //是否可以后退或者前进
    if(![self.webView canGoForward]){
        [self.tabbar.go setEnabled:NO];
    }
    if(![self.webView canGoBack]){
        [self.tabbar.back setEnabled:NO];
    }
    return YES;
}

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount
{
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }

        [self setProgressColorBy:newP];
        
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)setProgressColorBy:(float)progress
{
//    float portion = 0.1428571;
//    if (progress > portion * 7) {
//        self.progressView.progressTintColor = [UIColor purpleColor];
//    } else if (progress > portion * 6) {
//        self.progressView.progressTintColor = [UIColor blueColor];
//    } else if (progress > portion * 5) {
//        self.progressView.progressTintColor = [UIColor cyanColor];
//    } else if (progress > portion * 4) {
//        self.progressView.progressTintColor = [UIColor greenColor];
//    } else if (progress > portion * 3) {
//        self.progressView.progressTintColor = [UIColor yellowColor];
//    } else if (progress > portion * 2) {
        self.progressView.progressTintColor = [UIColor orangeColor];
//    } else if (progress > portion * 1) {
//        self.progressView.progressTintColor = [UIColor redColor];
//    } else {
//        self.progressView.progressTintColor = [UIColor redColor];
//    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loadCount ++;
    [self startNetworkActivity];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadCount --;
    [self endNetworkActivity];
    [self backOrGoButton];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loadCount --;
    NSLog(@"UIWebView加载失败");
}

#pragma mark 开始网络
- (void)startNetworkActivity
{
    if(![UIApplication sharedApplication].networkActivityIndicatorVisible)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark 停止网络
- (void)endNetworkActivity
{
    if([UIApplication sharedApplication].networkActivityIndicatorVisible)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self stopIndicatorView];
}

#pragma mark - ZRWebTabbarDelegate代理事件
/* 后退 */
- (void)webTabbarGoBack{
    if(IOS8x){
        [self.wkWebView goBack];
        if(![self.wkWebView canGoBack]){
            [self.tabbar.back setEnabled:NO];
        }
    }else{
        [self.webView goBack];
        if(![self.webView canGoBack]){
            [self.tabbar.back setEnabled:NO];
        }
    }
}

/* 前进 */
- (void)webTabbarGoForward{
    if(IOS8x){
        [self.wkWebView goForward];
        if(![self.wkWebView canGoForward]){
            [self.tabbar.go setEnabled:NO];
        }
    }else{
        [self.webView goForward];
        if(![self.webView canGoForward]){
            [self.tabbar.go setEnabled:NO];
        }
    }
}

/* 显示菜单 */
- (void)webTabbarShowMenus{
    ZRAllMenus * allMenus = [[ZRAllMenus alloc] initWithRect:self.view.bounds withTabbarRect:self.tabbar.frame];
    allMenus.delegate = self;
    self.tabbarMenus = allMenus;
    [self.view addSubview:allMenus]; 
}

#pragma mark - ZRAllMenusDelegate代理事件
- (void)allMenusForButtonClick:(UIButton *)button withMenusModel:(NSArray *)model
{
    [self buttonClick:button withMenusModel:model];
}
- (void)allMenusForRemoveDetails
{
    [self removeDetailsMenus];
}
- (void)allMenusForLogin
{
    ZRLoginController *login = [[ZRLoginController alloc] init];
    ZRNavController *nav = [[ZRNavController alloc ] initWithRootViewController:login];
    [self showControllerByAnimation:nav];
    [self removeDetailsMenus]; 
}
- (void)buttonClick:(UIButton *)button withMenusModel:(NSArray *)allMenusmodel
{
    [self removeDetailsMenus];
    ZRAllMenusModel *model = [allMenusmodel objectAtIndex:button.tag];
    if(![model.controller isEqualToString:@""]){
        if([model.controller isEqualToString:@"refresh page"]){
            if (IOS8x)
                [self.wkWebView reload];
            else
                [self.webView reload];
        } else if([model.controller isEqualToString:@"copy link"]){
            NSString *urlStr = @"";
            if (IOS8x) urlStr = self.wkWebView.URL.absoluteString;
            else urlStr = self.webView.request.URL.absoluteString;
            if (urlStr.length > 0) {
                [[UIPasteboard generalPasteboard] setString:urlStr];
                [ZRAlertController alertView:self title:@"提示" message:[NSString stringWithFormat:@"复制成功！网址：%@", urlStr] handler:nil];
            }
        } else if([model.controller isEqualToString:@"sharing"]){
            [self activityShareComponents];
        } else if([model.controller isEqualToString:@"book mark"]){
            ZRBookmarkController *bookmark = [[ZRBookmarkController alloc] init];
            [self.view addSubview:bookmark.view];
            self.bookmarkController = bookmark;
        }else if([model.controller isEqualToString:@"ZRDebugConsoleController"]){
            ZRNavController *nav = [[ZRNavController alloc ] initWithRootViewController:[[NSClassFromString(model.controller) alloc] init]];;
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            id controller = [[NSClassFromString(model.controller) alloc] init];
            
            ZRNavController *nav = [[ZRNavController alloc ] initWithRootViewController:controller];;

            if([model.controller isEqualToString:@"ZROriginalCodeController"]){
                //查看源代码
                ZROriginalCodeController *original = (ZROriginalCodeController *)controller;
                NSString *urlStr = @"";
                if (IOS8x) urlStr = self.wkWebView.URL.absoluteString;
                else urlStr = self.webView.request.URL.absoluteString;
                original.urlString = urlStr;
                nav = [[ZRNavController alloc ] initWithRootViewController:original];
                [self presentViewController:nav animated:YES completion:nil];
            }else if([model.controller isEqualToString:@"ZRDebugAllRequestController"]){
                //网页所有请求
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                [self showControllerByAnimation:nav];
            }
        }
    }
}

- (void)showControllerByAnimation:(ZRNavController *)nav
{
    //添加前
    CGRect beforeRect = nav.view.frame;
    beforeRect.origin.x = beforeRect.size.width;
    nav.view.frame = beforeRect;
    
    //添加
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    
    //添加后
    [UIView animateWithDuration:0.39f animations:^{
        CGRect afterRect = nav.view.frame;
        afterRect.origin.x = 0;
        nav.view.frame = afterRect;
    }];
}

/* 移除详细菜单 */
- (void)removeDetailsMenus
{
    //动画展示
    for(UIView *view in self.tabbarMenus.subviews){
        if(view.tag == 1){
            [UIView animateWithDuration:ZRTabbarMenusAnimationSpeed animations:^{
                CGRect rect = view.frame;
                rect.origin.y = - (view.frame.size.height * 0.7);
                view.frame = rect;
            } completion:^(BOOL finished) {
                if(finished){ 
                    [self.tabbarMenus removeFromSuperview];
                    self.tabbarMenus = nil;
                }
            }];
            break;
        }else if(view.tag == 2){
            [UIView animateWithDuration:ZRTabbarMenusAnimationSpeed animations:^{
                CGRect rect = view.frame;
                rect.origin.y = self.view.frame.size.height;
                view.frame = rect;
            } completion:^(BOOL finished) {
                if(finished){
                    [self.tabbarMenus removeFromSuperview];
                    self.tabbarMenus = nil;
                }
            }];
            break;
        }
    }
}


/* 分享API */
- (void)activityShareComponents
{
    //系统自带的分享API
    NSString *textToShare = @"唯美浏览器，为私人定制的浏览器~~~，作为普通用户，如果你有需求，请在App Store留言吧~~ 为开发者，尽情的调试前端利器；还等什么了？动手去下载吧！~ https://itunes.apple.com/cn/app/wei-mei-liu-lan-qi/id1067649034?l=en&mt=8";
    UIImage *imageToShare = [UIImage imageNamed:@"AppIcon60x60"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/wei-mei-liu-lan-qi/id1067649034?l=en&mt=8"];
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityView animated:YES completion:nil];
    
    
    //友盟分享组API
//    注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"56e6368ce0f55a7ad10008f4"
//                                      shareText:@"唯美浏览器，为用户畅想浏览你的人生~~~ 为开发者，尽情的调试前端利器；还等什么了？动手去下载吧！~ https://itunes.apple.com/cn/app/wei-mei-liu-lan-qi/id1067649034?l=en&mt=8"
//                                     shareImage:[UIImage imageNamed:@"AppIcon"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToQzone,UMShareToRenren, UMShareToDouban, UMShareToEmail, UMShareToSms,nil]
//                                       delegate:self];
    
    //tencent41E0D236
}

//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}

/* 显示首页 */
- (void)webTabbarShowHome{
    [self removeController];
}

/* 管理页面控制器 */
- (void)webTabbarControllersManagement{
    //页面管理的模型类
    ZRPageManageModel *model = [[ZRPageManageModel alloc] init];
    [model setPageTitle:self.currentTitle];
    [model setPageUrl:self.currentURL];
    
    ZRScreenCapture *capture = [[ZRScreenCapture alloc] init];
    NSString *filename = [capture screenCaptureNoStatusBar:self.view];
    [model setFilepath:filename];
    
    //写入沙盒
    [[ZRPageManage defaultPageManage] writeToFilePath:model];
    
    //跳转管理控制器
    ZRPageManageController *controller = [[ZRPageManageController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - 记录历史记录
- (void)addHistory:(NSString *)title withURLString:(NSString *)reqUrl
{
    //历史记录
    if(!self.isAddHistory && ![title isEqualToString:@""] && ![reqUrl isEqualToString:@""]){
        [[[ZRHistoryPage alloc] init] add:title withUrl:reqUrl];
        self.isAddHistory = true;
    }
    self.titleSearchBar.text = reqUrl;
//    self.zrNavigation.titleLableUrl = reqUrl;
//    self.zrNavigation.titleLabelText = title;
}

#pragma mark - 启用 前进或者后退
- (void)backOrGoButton
{
    if (IOS8x) {
        if (self.wkWebView.canGoBack)
            [self.tabbar.back setEnabled:YES];
        if (self.wkWebView.canGoForward)
            [self.tabbar.go setEnabled:YES];
    }else {
        if (self.webView.canGoBack)
            [self.tabbar.back setEnabled:YES];
        if(self.webView.canGoForward)
            [self.tabbar.go setEnabled:YES];
    }
}

#pragma mark - ZRWebViewDelegate
- (void)showTranslationPlane
{
    [UIView animateWithDuration:kResultingPlaneAnimationDuration animations:^{
        CGRect rect = self.tabbar.frame;
        rect.origin.y = kWebViewHeight;
        self.tabbar.frame = rect;
    }];
}

- (void)hideTranslationPlane
{
    [UIView animateWithDuration:kResultingPlaneAnimationDuration animations:^{
        CGRect rect = self.tabbar.frame;
        rect.origin.y = kWebViewHeight - rect.size.height - 64;
        self.tabbar.frame = rect;
    }];
}

@end

