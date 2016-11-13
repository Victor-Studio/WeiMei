//
//  ZRBookmark.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/7.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  书签 从SQLite读取

#import <Foundation/Foundation.h>

@interface ZRBookmark : NSObject
/* 添加数据 */
- (void)add:(NSString *)title withUrl:(NSString *)url;

/* 查询数据 */
- (NSMutableArray *)query;

/* 清除标签记录 */
- (void)clearAllBookmark;

/* 删除一条标签记录 */
- (void)deleteOneBookmark:(NSInteger)index;
@end
