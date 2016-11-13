
//  ZRHomeNavViewController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 15/12/30.
//  Copyright (c) 2015年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRHomeNavViewController.h"
#import <WebKit/WebKit.h>
#import "ZRWebViewController.h"

#define IOS8x (DeviceVersion >= 8.0)

@interface ZRHomeNavViewController ()< UIWebViewDelegate,WKNavigationDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) WKWebView *wWebView;

@end

@implementation ZRHomeNavViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    [self configShowPage];
}

- (void)configShowPage
{
    CGRect rect = self.view.frame;
    rect.size.height = rect.size.height - HomeScrollViewTopHeight;
    
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"唯美浏览器导航" ofType:@".html"];
    NSString *htmlname = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    NSString *strPath = [[NSBundle mainBundle] bundlePath];

    if(!IOS8x){
        WKWebView *wwebView = [[WKWebView alloc] initWithFrame:rect];
        wwebView.navigationDelegate = self;
        [wwebView loadHTMLString:htmlname baseURL:[NSURL fileURLWithPath:strPath]];
        wwebView.backgroundColor = MainColor;
        [self.view addSubview:wwebView];
        self.wWebView = wwebView;
    }else{
        UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
        webView.delegate = self;
        [webView loadHTMLString:htmlname baseURL:[NSURL fileURLWithPath:strPath]];
        [self.view addSubview:webView];
        webView.backgroundColor = MainColor;
        webView.scrollView.showsVerticalScrollIndicator = false;
        self.webView = webView;
    }
}

#pragma mark - UIWebView的代理事件
#pragma mark 每个WebView的都会被拦截
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *weimeiURL = @"http://www.weimei.studio/";
    NSString *reqURL = request.URL.absoluteString;
    if([reqURL hasPrefix:weimeiURL]){
        NSMutableString *mstr = [[NSMutableString alloc] init];
        [mstr appendString:@"http://m.baidu.com/s?word="];
        NSRange range = [reqURL rangeOfString:@"words="];
        NSString *keywords = [reqURL substringFromIndex:range.location + range.length];
        NSString *decodeStr = [keywords stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [mstr appendString:decodeStr];
        [ZRWebViewController showWithContro:self withUrlStr:mstr withTitle:nil];
        return NO;
    } else if(![reqURL containsString:@".app"]){
        [ZRWebViewController showWithContro:self withUrlStr:[request.URL absoluteString] withTitle:@""];
        return NO;
    } else
        return YES;
}

#pragma mark 网页请求失败时事件
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}


#pragma mark - wkWebView代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
        decisionHandler(WKNavigationActionPolicyAllow);  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!IOS8x){
        
    }else{
        CGRect rect = self.view.frame;
        if(rect.origin.y != HomeScrollViewTopHeight){
            rect.origin.y = HomeScrollViewTopHeight;
            [UIView animateWithDuration:-0.3f animations:^{
                self.view.frame = rect;
            }];
        }
    }
}


@end
