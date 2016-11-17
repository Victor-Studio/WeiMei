//
//  GDUIQRCodeScanViewController.h
//  GuDong
//
//  Created by Victor Zhang on 7/13/16.
//  Copyright © 2016 comisys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRAlertController.h"

typedef void (^CallbackBlock)(NSString *responseData, int statusCode);

@interface ZRQRCodeScanView : UIView

- (void)openQRCodeScan:(UIViewController *)viewController completion:(CallbackBlock)callback;

@end
