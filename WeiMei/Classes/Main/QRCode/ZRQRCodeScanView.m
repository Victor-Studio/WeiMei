//
//  GDUIQRCodeScanViewController.m
//  GuDong
//
//  Created by Victor Zhang on 7/13/16.
//  Copyright © 2016 comisys. All rights reserved.
//

#import "ZRQRCodeScanView.h"
#import "ZRQRCodeController.h"

#define SCROLL_LINE_SPEED 2.0

@interface ZRQRCodeScanView()<ZRQRCodeViewDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *scanFrame;
@property (nonatomic, strong) UIImageView *imgScanLine;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) CGRect imgScanLineFrame;
 
@property (nonatomic, strong) UIViewController *lastViewController;
@property (nonatomic, copy) NSString *domain;

@property (nonatomic, strong) UISwitch *switchScanButton;
@property (nonatomic, strong) UILabel *switchTipsText;
@end

@implementation ZRQRCodeScanView

- (void)openQRCodeScan:(UIViewController *)viewController completion:(CallbackBlock)callback
{
    self.lastViewController = viewController;
    [self setFrame:[UIScreen mainScreen].bounds];
    self.backgroundColor = [UIColor clearColor];
    
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeContinuation customView:self navigationBarTitle:@"扫一扫"];
    qrCode.VCTintColor = [UIColor whiteColor];
    qrCode.qrcodeDelegate = self;
    qrCode.scanCodeKind = ZRScanCodeKindQRCode;
    [qrCode QRCodeScanningWithViewController:self.lastViewController completion:^(NSString *strValue) {
        NSLog(@"扫一扫结果 = %@ ", strValue);
        callback(strValue, 0);
        
    } failure:^(NSString *message) {
        callback(@"权限问题", -1);
        
        ZRAlertController *alert = [ZRAlertController defaultAlert];
        alert.ownViewController = viewController;
        [alert alertShowWithTitle:nil message:@"请在iPhone的\"设置-隐私-相机\"中允许蓝信访问你的相机" okayButton:@"知道了" completion:nil];
    }];
    [self addSomeView:qrCode.view.frame];

}

- (void)addSomeView:(CGRect)rect
{
    CGFloat bTxtHeight = 50;
    CGFloat bTxtY = rect.size.height - bTxtHeight - 61 * 2;
    UILabel *bottomText = [[UILabel alloc] initWithFrame:CGRectMake(0, bTxtY, rect.size.width, bTxtHeight)];
    [bottomText setText:@"对准二维码，即可自动扫描"];
    [bottomText setTextColor:[UIColor whiteColor]];
    [bottomText setFont:[UIFont systemFontOfSize:19]];
    [bottomText setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:bottomText];
    
    CGFloat sfX = 20;
    CGFloat sfW = rect.size.width - sfX * 2;
    CGFloat sfY = 0;
    if (rect.size.width <= 320) {
        sfY = (rect.size.height - sfW) / 2 + sfX * 1.5;
    } else {
        sfY = (rect.size.height - sfW) / 2 - sfX;
    }
    UIView *scanFrame = [[UIView alloc] initWithFrame:CGRectMake(sfX, sfY, sfW, sfW)];
    scanFrame.layer.borderColor = [UIColor clearColor].CGColor;
    scanFrame.layer.borderWidth = 1;
    [self addSubview:scanFrame];
    self.scanFrame = scanFrame;
    
    CGFloat slX = 3;
    CGFloat slY = 2;
    CGFloat slW = scanFrame.frame.size.width - slX - slY;
    CGFloat slH = 8;
    UIImageView *scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(slX, slY, slW, slH)];
    [scanLine setImage:[UIImage imageNamed:@"QRCodeScanLine"]];
    [scanFrame addSubview:scanLine];
    
    self.imgScanLineFrame = scanLine.frame;
    self.isUp = YES;
    self.imgScanLine = scanLine;
    __weak typeof(self) wself = self;
    self.timer = [NSTimer timerWithTimeInterval:SCROLL_LINE_SPEED target:wself selector:@selector(upAndDownScanLine) userInfo:nil repeats:YES];
    [self.timer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)drawRect:(CGRect)rect
{
    //镂空扫描区域
    [[UIColor colorWithWhite:0 alpha:0.5] setFill];
    CGRect translucentRect = [UIScreen mainScreen].bounds;
    CGRect transparentRect = _scanFrame.frame;
    UIRectFill(translucentRect);
    CGRect holeiInterSection = CGRectIntersection(transparentRect, translucentRect);
    [[UIColor clearColor] setFill];
    UIRectFill(holeiInterSection);
    
    CGFloat length = 27;
    CGRect sfRect = _scanFrame.frame;
    CGFloat blue[4] = { (float)56 / 255, (float)81 / 255, (float)134 / 255, 1 };
    CGFloat white[4] = { (float)255 / 255, (float)255 / 255, (float)255 / 255, 1 };
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound); 
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextSetStrokeColor(ctx, white);
    CGContextSetLineWidth(ctx, 1.5);
    
    //左边线
    CGContextMoveToPoint(ctx, sfRect.origin.x, sfRect.origin.y + length);
    CGContextAddLineToPoint(ctx, sfRect.origin.x, sfRect.origin.y + sfRect.size.height - length);
    CGContextStrokePath(ctx);
    
    //底部边线
    CGContextMoveToPoint(ctx, sfRect.origin.x + length, sfRect.origin.y + sfRect.size.height);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width - length, sfRect.origin.y + sfRect.size.height);
    CGContextStrokePath(ctx);
    
    //右边线
    CGContextMoveToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y + length);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y + sfRect.size.height - length);
    CGContextStrokePath(ctx);
    
    //上边线
    CGContextMoveToPoint(ctx, sfRect.origin.x + sfRect.size.width - length, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + length, sfRect.origin.y);
    CGContextStrokePath(ctx);
    
    CGContextSetStrokeColor(ctx, blue);
    CGContextSetLineWidth(ctx, 6);
    
    //左上角
    CGContextMoveToPoint(ctx, sfRect.origin.x + length, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x, sfRect.origin.y + length);
    CGContextStrokePath(ctx);
    
    //左下角
    CGContextMoveToPoint(ctx, sfRect.origin.x, sfRect.origin.y + sfRect.size.height - length);
    CGContextAddLineToPoint(ctx, sfRect.origin.x, sfRect.origin.y + sfRect.size.height);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + length, sfRect.origin.y + sfRect.size.height);
    CGContextStrokePath(ctx);
    
    //右下角
    CGContextMoveToPoint(ctx, sfRect.origin.x + sfRect.size.width - length, sfRect.origin.y + sfRect.size.height);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y + sfRect.size.height);
    CGContextAddLineToPoint(ctx, sfRect.origin.x +  + sfRect.size.width, sfRect.origin.y + sfRect.size.height - length);
    CGContextStrokePath(ctx);
    
    //右上角
    CGContextMoveToPoint(ctx, sfRect.origin.x + sfRect.size.width - length, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y);
    CGContextAddLineToPoint(ctx, sfRect.origin.x + sfRect.size.width, sfRect.origin.y + length);
    CGContextStrokePath(ctx);
//    [self constructViewWithSwitchButton];
}

////UISwitch切换，二维码或条形码扫描
//- (void)constructViewWithSwitchButton
//{
//    CGRect rect = self.frame;
//    
//    CGFloat vW = 180;
//    CGFloat vH = 35;
//    CGFloat vX = rect.size.width - vW - 15;
//    CGFloat vY = 80;
//    UIView *viewForSwitch = [[UIView alloc] initWithFrame:CGRectMake(vX, vY, vW, vH)];
//    [self addSubview:viewForSwitch];
//    
//    CGFloat lW = vW - 55;
//    CGFloat lH = 31;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, lW, lH)];
//    label.text = @"切换条形码扫描";
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:16];
//    [viewForSwitch addSubview:label];
//    self.switchTipsText = label;
//    
//    UISwitch *switchBtn = [[UISwitch alloc] init];
//    CGFloat sW = switchBtn.frame.size.width;
//    CGFloat sH = switchBtn.frame.size.height;
//    CGFloat sX = vW - sW;
//    switchBtn.frame = CGRectMake(sX, 5, sW, sH);
//    switchBtn.on = YES;
//    [switchBtn addTarget:self action:@selector(switchQRCodeOrBarCode:) forControlEvents:UIControlEventTouchUpInside];
//    [viewForSwitch addSubview:switchBtn];
//    self.switchScanButton = switchBtn;
//}

//扫描滚动条，上上下下持续滚动
- (void)upAndDownScanLine
{
    self.imgScanLine.frame = self.imgScanLineFrame;
    [UIView animateWithDuration:SCROLL_LINE_SPEED animations:^{
        CGRect rect = self.imgScanLine.frame;
        CGRect rect1 = self.scanFrame.frame;
//        if (self.isUp) {
//            self.isUp = NO;
            rect.origin.y = rect1.size.height - rect.origin.y * 2;
            self.imgScanLine.frame = rect;
//        } else {
//            self.isUp = YES;
//            self.imgScanLine.frame = self.imgScanLineFrame;
//        }
    }];
}


- (void)dealloc
{
    [self abolishTimer];
}

- (void)abolishTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - ZRQRCodeViewDelegate
- (void)navigationBarDidClickedBackButton
{
    [self abolishTimer];
    
}

@end
