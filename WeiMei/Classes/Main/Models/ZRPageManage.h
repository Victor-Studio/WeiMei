//
//  ZRPageManage.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/5/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//  多个页面管理的截图类

#import <Foundation/Foundation.h>

/**
 * 页面管理的截图路径
 **/
#define ZRPageManageScreenShotsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ZRPageManageScreenShot"]

/**
 * 页面管理的截图文件名
 **/
#define ZRPageManageScreenShotsFilename(datetime) [NSString stringWithFormat:@"%@/ZRPageScreen_%@.png", ZRPageManageScreenShotsPath, datetime]

@class ZRPageManageModel;
@interface ZRPageManage : NSObject

@property (nonatomic, strong) NSMutableArray *allPageModels;

+ (instancetype)defaultPageManage;

- (void)getDirectory;

- (NSArray *)getFiles;

- (void)writeToFilePath:(ZRPageManageModel *)model;

@end




/**
 * 页面管理的模型类
 **/
@interface ZRPageManageModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *filepath;

@property (nonatomic, copy) NSString *pageUrl;

@property (nonatomic, copy) NSString *pageTitle;

@end
