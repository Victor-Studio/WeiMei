//
//  ZRScreenCapture.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/5/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRScreenCapture.h"
#import "ZRPageManage.h"
#import "ZRDate.h"


@implementation ZRScreenCapture

/**
 * 默认截图整个屏幕，包含UINavigationBar, 但是不包含状态栏
 **/
- (NSString *)screenCaptureNoStatusBar:(UIView *)view
{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.y = 20;
    rect.size.height -= ((rect.origin.y + 40));
    rect.size.height /= 2;
    return [self capture:view withWidth:rect.size.width withHeight:rect.size.height withX:0 withY:rect.origin.y];
}

/**
 * 指定区域大小截图
 **/
- (void)screenCapture:(UIView *)view withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    [self capture:view withWidth:width withHeight:height withX:0 withY:0];
}

- (NSString *)capture:(UIView *)view withWidth:(CGFloat)width withHeight:(CGFloat)height withX:(CGFloat)x withY:(CGFloat)y
{ 
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, 1.0f);     //设置截屏大小
//    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = [self convertViewToImage:view].CGImage;
    
    CGRect rect = CGRectMake(x, y, width, height);//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
//    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    
    [[ZRPageManage defaultPageManage] getDirectory];
    NSString *filename = ZRPageManageScreenShotsFilename([[[ZRDate alloc] init] currentDate:@"yyMMddHHmmss"]);
    [imageViewData writeToFile:filename atomically:YES];//保存照片到沙盒目录
    CGImageRelease(imageRefRect);
    return filename;
}

-(UIImage *)convertViewToImage:(UIView *)view;
{
    UIGraphicsBeginImageContext(view.frame.size);
    [view drawViewHierarchyInRect:view.frame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
@end
