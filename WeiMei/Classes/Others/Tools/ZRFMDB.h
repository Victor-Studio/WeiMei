//
//  ZRFMDB.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/27.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
 
@interface ZRFMDB : NSObject

/* 添加数据 */
- (void)addWithSql:(NSString *)sql;

/* 删除数据 */
- (void)minusWithSql:(NSString *)sql;

/* 更新数据 */
- (void)updateWithSql:(NSString *)sql;

/* 查询数据 书签记录 */
- (NSMutableArray *)queryWithBookmark;

/* 查询数据 历史记录 */
- (NSMutableArray *)queryWithHistory;

/* 创建数据表 */
- (void)createDatabaseName:(NSString *)createSql;

@end
