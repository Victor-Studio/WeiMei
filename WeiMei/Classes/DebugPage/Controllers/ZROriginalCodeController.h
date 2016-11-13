//
//  ZROriginalCodeController.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/3.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZROriginalCodeController : UIViewController

//URL地址
@property (nonatomic,copy) NSString *urlString;

- (instancetype)initOriginalCodeView:(NSString *)url;

@end
