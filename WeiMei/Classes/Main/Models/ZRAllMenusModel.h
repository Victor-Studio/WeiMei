//
//  ZRAllMenusModel.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/5.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  所有的菜单模型类

#import <UIKit/UIKit.h>

@interface ZRAllMenusModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *controller;


- (instancetype)initWithDict:(NSDictionary *)dic;

+ (NSArray *)allMenusModel;

@end
