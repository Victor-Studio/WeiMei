//
//  ZRHistoryPage.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/28.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRHistoryPage.h"

@interface ZRHistoryPage ()

@property (nonatomic,assign) NSString *tableName;

@property (nonatomic,strong) ZRFMDB *zrfmdb;

@end

@implementation ZRHistoryPage

- (ZRFMDB *)zrfmdb
{
    if(!_zrfmdb){
        _zrfmdb = [[ZRFMDB alloc] init];
    }
    return _zrfmdb;
}

- (NSString *)tableName
{
    if(!_tableName){
        _tableName = @"history_page";
    }
    return _tableName;
}

/* 添加数据 */
- (void)add:(NSString *)title withUrl:(NSString *)url
{
    [self createdbname];
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@(title,url) values('%@','%@');", self.tableName, title, url];
    [self.zrfmdb addWithSql:sql];
}

/* 查询数据 */
- (NSMutableArray *)query
{
    return [self.zrfmdb queryWithHistory];
}

- (void)createdbname
{
    [self.zrfmdb createDatabaseName:[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement not null,title text null, url text null,createtime datetime default (datetime('now', 'localtime')) );", self.tableName]];
}

/* 清除所有历史记录 */
- (void)clearAllHistory
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ ;", self.tableName];
    [self.zrfmdb minusWithSql:sql];
}

/* 单条数据删除 */
- (void)deleteOneHistory:(NSInteger)index
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id=%ld", self.tableName, index];
    [self.zrfmdb minusWithSql:sql];
}

@end
