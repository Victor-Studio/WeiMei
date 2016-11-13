//
//  ZRHomeQuickNavModel.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/3.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  快捷菜单的模型

#import <Foundation/Foundation.h>

@interface ZRHomeQuickNavModel : NSObject

//名称
@property (nonatomic,copy) NSString *name;

//图标
@property (nonatomic,copy) NSString *icon;

//URL
@property (nonatomic,copy) NSString *url;

//获取指定文件内容数组
+ (NSArray *)quickNavArray;

@end
