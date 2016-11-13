
//  Created by Victor Zhang on 16/1/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  二维码扫描

#import "ZRQRCodeScanController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZRWebViewController.h"
#import "ZRAlertController.h" 

#define ScanMenuHeight 45

@interface ZRQRCodeScanController ()<AVCaptureMetadataOutputObjectsDelegate>//用于处理采集信息的代理
{
    AVCaptureSession * session;   //输入输出的中间桥梁
    UIButton * torchBtn;          //开灯关灯
    UIImageView *scanLine;        //扫描图片
}

@property (nonatomic,strong) NSTimer *scanTimer;
@property (nonatomic,assign) CGFloat scanLineTop;
@property (nonatomic,assign) CGFloat scanLineBottom;
@end

@implementation ZRQRCodeScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.配置头部和底部
    [self configMenus];
    
    //2.配置摄像头
    [self configDevice];
    
    //3.配置扫描图片
    [self configScanPic];
}

#pragma mark - 1.配置头部和底部
- (void)configMenus
{
    //头部
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScanMenuHeight + 10)];
    [topView setBackgroundColor:[UIColor blackColor]];
    topView.alpha = 0.5;
    [self.view addSubview:topView];
    
    CGFloat titleW = 80;
    CGFloat titleH = 30;
    CGFloat titleY = 20;
    CGFloat titleX = (self.view.frame.size.width - titleW) / 2;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.text = @"扫一扫";
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title]; 
    
    
    //关闭按钮
    CGFloat btnW = 25;
    CGFloat btnH = 20;
    CGFloat btnX = 10;
    CGFloat btnY = 23;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"cc_webview_back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeQRCodeScan) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.imageView setTintColor:[UIColor whiteColor]];
    [backBtn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:backBtn];
    
    //底部
    CGFloat bottomY = self.view.frame.size.height - ScanMenuHeight;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, self.view.frame.size.width, ScanMenuHeight)];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    bottomView.alpha = 0.5;
    [self.view addSubview:bottomView];
    
    //开灯
    CGFloat openW = 28;
    CGFloat openH = 28;
    CGFloat openX = 11;
    CGFloat openY = 8;
    UIButton *openlight = [[UIButton alloc] initWithFrame:CGRectMake(openX, openY, openW, openH)];
    [openlight setBackgroundImage:[UIImage imageNamed:@"qrcode_torch_btn"] forState:UIControlStateNormal];
    [openlight setBackgroundImage:[UIImage imageNamed:@"qrcode_torch_btn_selected"] forState:UIControlStateSelected];
    [openlight addTarget:self action:@selector(torchOnOrOff) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:openlight];
    torchBtn = openlight;
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    [tipsLabel setText:@"任意位置对准二维码即可"];
    [tipsLabel setTextColor:[UIColor whiteColor]];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel];
    tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //宽度    给自己添加
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 50];
    [tipsLabel addConstraint:width];
    
    //高度    给自己添加
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100];
    [tipsLabel addConstraint:height];
    
    //X值     添加到父容器
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.view addConstraint:centerX];
    
    //Y值     添加到父容器
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.view addConstraint:centerY];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - 2.配置摄像头
- (void)configDevice
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(device){
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [session addInput:input];
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获
        [session startRunning];
        
        //开始动画扫描
        [self scanningTimer];
    }
}

#pragma mark - 3.配置扫描图片
- (void)configScanPic
{
    //添加扫描图片
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage stretchImage:@"ScanFrame"]];
    CGFloat margin = 10;
    CGFloat imgW = self.view.frame.size.width - margin * 2;
    CGFloat imgH = self.view.frame.size.height - ScanMenuHeight * 2 - margin;
    CGFloat imgY = ScanMenuHeight + margin;
    imgView.frame = CGRectMake(margin, imgY, imgW, imgH);
    [self.view addSubview:imgView];
    
    //添加扫描的扫描条
    CGFloat lineY = imgY + 3;
    CGFloat lineW = imgW - margin - 6;
    CGFloat lineX = margin + 8;
    UIImageView *scanImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanLine"]];
    scanImg.frame = CGRectMake(lineX, lineY, lineW, margin * 2);
    [self.view addSubview:scanImg];
    scanLine = scanImg;
    
    self.scanLineTop = lineY;
    self.scanLineBottom = imgH + 30;
}
 
#pragma mark - 扫描定时器
- (void)scanningTimer
{
    if(!self.scanTimer){
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scanning) userInfo:nil repeats:YES];
    }
}
- (void)scanning
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = scanLine.frame;
        rect.origin.y = self.scanLineBottom;
        scanLine.frame = rect;
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = scanLine.frame;
                rect.origin.y = self.scanLineTop;
                scanLine.frame = rect;
            }];
        }
    }];
}

#pragma mark 停止扫描
- (void)stopScanning
{
    [self.scanTimer invalidate];
    self.scanTimer = nil;
}

#pragma mark 关闭扫描
- (void)closeQRCodeScan
{
    [session stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 开灯与关灯
- (void)torchOnOrOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchMode: AVCaptureTorchModeOn];
        [torchBtn setSelected:YES];
    }else{
        [device setTorchMode: AVCaptureTorchModeOff];
        [torchBtn setSelected:NO];
    }
    [device unlockForConfiguration];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!session.isRunning){
        [self closeQRCodeScan];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        
        //停止扫描
        [session stopRunning];
        [self stopScanning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        NSString *svalue = metadataObject.stringValue; 
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:svalue]]){
            [ZRWebViewController showWithContro:self withUrlStr:svalue withTitle:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            [ZRAlertController alertView:self title:@"扫描结果" message:svalue handler:^{
                [session startRunning];
                //开始动画扫描
                [self scanningTimer];
            }];
        }
    }
}

- (void)dealloc{
    [self stopScanning];
}


@end
