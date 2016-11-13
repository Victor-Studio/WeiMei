//
//  ZRWeatherController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/6/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//  首页的左侧滑 天气

#import "ZRWeatherController.h"
#import <WebKit/WebKit.h>
#import "Reachability.h"
#import "ZRWebViewController.h"



@implementation ZRWeatherModel
+ (instancetype)defaultWeather
{
    static ZRWeatherModel *weatherMode = nil;
    static dispatch_once_t onceWeather;
    dispatch_once(&onceWeather, ^{
        weatherMode = [[ZRWeatherModel alloc] init];
    });
    return weatherMode;
}
@end





@interface ZRWeatherController()<UIWebViewDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation ZRWeatherController

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        [_webView setDelegate:self];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        [_wkWebView setNavigationDelegate:self];
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [[Reachability reachabilityWithHostName:@"www.baidu.com"] startNotifier];
    
    [self.view setBackgroundColor:MainColor];
    
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    //如果没有网络，加载本地的资源
    if (status == NotReachable) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"weatherindex" ofType:@".html"];
        NSString *htmlCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSURL *url = [NSURL URLWithString:path];
        if (AboveIOS8) {
            [[self wkWebView] loadHTMLString:htmlCode baseURL:url];
        }else{
            [[self webView] loadHTMLString:htmlCode baseURL:url];
        }
    } else {
        
        //如果有网络，加载网络资源
        NSString *url = @"http://weather.html5.qq.com/";
        if (AboveIOS8) {
            [[self wkWebView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }else{
            [[self webView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *reqURL = request.URL.absoluteString;
    if([[ZRWeatherModel defaultWeather] isFisrtLoad]){
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [ZRWebViewController showWithContro:self withUrlStr:reqURL withTitle:@""];
        return NO;
    } else
        return YES;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if([[ZRWeatherModel defaultWeather] isFisrtLoad]){
        NSString *reqURL = webView.URL.absoluteString;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [ZRWebViewController showWithContro:self withUrlStr:reqURL withTitle:@""];
        decisionHandler(WKNavigationActionPolicyCancel);//cancel navigation
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);// continue navigation
    }
}

@end
