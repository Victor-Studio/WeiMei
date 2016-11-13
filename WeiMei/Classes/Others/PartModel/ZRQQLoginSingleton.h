//
//  ZRQQLoginSingleton.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 3/29/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRQQLoginSingleton : NSObject<NSCoding>

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *openId;

@property (nonatomic, strong) NSDate *expiredDate;

@property (nonatomic, copy) NSString *avatarSmall;

@property (nonatomic, copy) NSString *avatarStandard;

@property (nonatomic, copy) NSString *nickName;

/**
 * 获取对象
 **/
+ (instancetype)defaultQQLoginSingleton;

/** 
 * 写入对象到磁盘
 */
- (void)writeObjectToFile;

/**
 * 获取文件
 */
- (void)getObjectFromFile;

/**
 * 释放对象
 */
- (void)dispose;

@end
