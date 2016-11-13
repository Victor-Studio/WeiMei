//
//  ZROriginalCodeController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/3.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZROriginalCodeController.h" 

#define ViewNav_TintColor [UIColor lightGrayColor]

//导航工具条高度
#define ViewToolbarHeight 25

@interface ZROriginalCodeController ()<UITextFieldDelegate, UIScrollViewDelegate>

//显示源代码的控件
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation ZROriginalCodeController

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

- (instancetype)initOriginalCodeView:(NSString *)url
{
    if(self = [super init])
    {
        self.urlString = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.创建UIWebView
    [self createWebView];
    
    //2.添加搜索框
//    [self configNavItem];
    
    //3.导航返回按钮
    [self configBackItem];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(0, 0, 10, self.navigationController.view.frame.size.height)];
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"源代码:%@", self.urlString];
    self.navigationItem.titleView = label;
    
    
    [[self indicatorView] startAnimating];
}

#pragma mark - 1.创建UIWebView
- (void)createWebView
{
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    UIWebView *wview = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,w,h)];
    wview.scrollView.delegate = self;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"showOriginalCode" ofType:@".html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    [wview loadHTMLString:htmlString baseURL:[NSURL URLWithString:filepath]];
    self.webView = wview;
    [self.view addSubview:wview];
}

#pragma mark - 2.添加搜索框
- (void)configNavItem
{
    CGFloat searchWith = 200.0;
    CGFloat searchX = 2;
    UITextField *searchInput = [[UITextField alloc]
                                initWithFrame:CGRectMake(searchX, 0, searchWith, ViewToolbarHeight)];
    searchInput.font = [UIFont systemFontOfSize:12];
    searchInput.placeholder = @"  请输入要查询的字符";
    searchInput.layer.borderColor = ViewNav_TintColor.CGColor;
    searchInput.layer.borderWidth = 1.0f;
    searchInput.layer.cornerRadius = 5.0f;
    searchInput.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchInput];
}

#pragma mark - 3.导航返回按钮
- (void)configBackItem
{
    UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 22)];
    [backBtn setTintColor:MainColorRed];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
- (void)backBtnPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *htmlCode = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.urlString] encoding:NSUTF8StringEncoding error:nil];
        htmlCode = [htmlCode stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
        htmlCode = [htmlCode stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        htmlCode = [htmlCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableString *mstr = [[NSMutableString alloc] init];
        [mstr appendString:@"<pre id=\"myhtmlcode\"></pre>"]; 
        [mstr appendString:@"<script src=\"jquery.snippet.js\"></script>"];
        [mstr appendString:@"<script type=\"text/javascript\" src=\"textSearch.js\"></script>"];
        [mstr appendString:@"<link rel='stylesheet' href='jquery.snippet.css' />"];
        NSString *str = [mstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.webView stringByEvaluatingJavaScriptFromString:
        [NSString stringWithFormat:@"$(decodeURI(\"%@\")).insertBefore(\"#div\"); $(\"#myhtmlcode\").html(decodeURI(\"%@\"));$(\"#myhtmlcode\").css({\"width\":%f,\"minHeight\":%f}); $(\"#myhtmlcode\").snippet(\"html\", { style: \"neon\"});",
          str,
          htmlCode,
          self.view.frame.size.width,
          self.view.frame.size.height]];
        
        [[self indicatorView] stopAnimating];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if(y <= 100){
       [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
}


#pragma mark - UITextFieldDelegate代理
#pragma mark 文本框被编辑时触发
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{ 
    [self.webView stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:@"searchKeywords('%@')",textField.text]];
    return YES;
} 

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
     return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

@end
