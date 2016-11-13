//
//  ZRWebButton.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/30.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRWebButton : UIButton
+ (ZRWebButton *)createButton:(CGRect)rect image:(NSString *)img highlight:(NSString *)highlight disableImg:(NSString *)disableImage;
@end
