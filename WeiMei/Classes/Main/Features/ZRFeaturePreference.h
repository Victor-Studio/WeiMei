//
//  ZRFeaturePreference.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/9/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//  特性偏好，是否已经浏览过偏好

#import <Foundation/Foundation.h>

@interface ZRFeaturePreference : NSObject

- (BOOL)read;

- (void)write;

@end
