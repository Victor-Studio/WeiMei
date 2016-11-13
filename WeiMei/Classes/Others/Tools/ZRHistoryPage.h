//
//  ZRHistoryPage.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/28.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  历史记录  从SQLite读取

#import <Foundation/Foundation.h>
#import "ZRFMDB.h"

@interface ZRHistoryPage : NSObject

/* 添加数据 */
- (void)add:(NSString *)title withUrl:(NSString *)url;

/* 查询数据 */
- (NSMutableArray *)query;

/* 清除历史记录 */
- (void)clearAllHistory;

/* 删除一条记录 */
- (void)deleteOneHistory:(NSInteger)index;

@end
