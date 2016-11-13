//
//  ZRDebugConsoleController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/6.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRDebugConsoleController.h"
#import "ZRWebViewController.h"
#import "UIView+Toast.h"

#define kHttpMethod @"kHttpMethod"

#define kColorWhite [UIColor whiteColor]
#define kColorBlack [UIColor blackColor]

@interface ZRDebugConsoleController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *requestURL;

@property (weak, nonatomic) IBOutlet UITextView *requestParams;

@property (weak, nonatomic) IBOutlet UIPickerView *requestType;

@property (weak, nonatomic) IBOutlet UITextView *responseResult;

@property (weak, nonatomic) IBOutlet UIButton *sendRequesterButton;
- (IBAction)sendRequester:(id)sender;

@property (nonatomic, strong) NSArray *httpRequestMethods;

@property (nonatomic, assign) NSString *reqType;

@end

@implementation ZRDebugConsoleController

- (NSString *)reqType
{
    if (!_reqType) {
        _reqType = @"GET";
    }
    return _reqType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBasis];
    
    [self loadData];
}

#pragma mark - 配置基本信息
- (void)configBasis
{
    //1.返回按钮
    UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 25, 22)];
    [backBtn setTintColor:MainColorRed];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    //2.title
    self.navigationItem.title = @"控制台";
    
    [self.view setBackgroundColor:kColorBlack];
}

- (void)backBtnPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    [self.requestType setDelegate:self];
    [self.requestType setDataSource:self];
    self.httpRequestMethods = @[
                                @{
                                    kHttpMethod : @"GET"
                                    },
                                @{
                                    kHttpMethod : @"POST"
                                    }
                                ];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewResignEdit)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewResignEdit
{
    [self.view endEditing:YES];
}

#pragma mark - UIPickerView's delegate events
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.httpRequestMethods.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSDictionary *dic = [self.httpRequestMethods objectAtIndex:row];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [lable setText:dic[kHttpMethod]];
    return lable;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dic = [self.httpRequestMethods objectAtIndex:row];
    self.reqType = dic[kHttpMethod];
}


- (IBAction)sendRequester:(id)sender {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *url = [self.requestURL.text stringByTrimmingCharactersInSet:set];
    NSString *params = [self.requestParams.text stringByTrimmingCharactersInSet:set];
    NSString *type = self.reqType;
    
    if (url.length <= 10 || (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])) {
        [self.view makeToast2:@"请填写正确的请求地址！" duration:1.5f position:CSToastPositionBottom];
        return;
    }
    
    [self.sendRequesterButton setTitle:@"正在发送请求......" forState:UIControlStateNormal];
    [self.sendRequesterButton setEnabled:NO];
    
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120];
    [request setHTTPMethod:type];
    if(params.length > 0){
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        [self.sendRequesterButton setEnabled:YES];
        [self.sendRequesterButton setTitle:@"发送请求" forState:UIControlStateNormal];
        
        if (connectionError) {
            [self.responseResult setText:[NSString stringWithFormat:@"%@", connectionError]];
            return;
        }
        
        //成功的返回信息和header
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        NSString *header = [[NSString alloc] initWithFormat:@"%@", resp.allHeaderFields];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.responseResult setText:[NSString stringWithFormat:@"响应体信息:\n %@; \n\n响应码:%ld \n\n响应头部信息: \n %@", str, resp.statusCode, header]];
    }];
    
}
@end
