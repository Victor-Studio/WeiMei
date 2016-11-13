//
//  ZRFMDB.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/27.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRFMDB.h"

@interface ZRFMDB()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ZRFMDB

- (FMDatabase *)db
{
    //创建一个数据库, 返回数据库示例对象
    if(!_db){
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/weimei.sqlite"];
        _db = [FMDatabase databaseWithPath:filename];
    }
    return _db;
}

/* 添加数据 */
- (void)addWithSql:(NSString *)sql
{
    [self.db open];
    [self.db executeUpdate:sql];
    [self.db close];
}

/* 删除数据 */
- (void)minusWithSql:(NSString *)sql
{
    [self.db open];
    [self.db executeUpdate:sql];
    [self.db close];
}

/* 更新数据 */
- (void)updateWithSql:(NSString *)sql
{
    [self.db open];
    [self.db executeUpdate:sql];
    [self.db close];
}

/* 查询数据 书签记录 */
- (NSMutableArray *)queryWithBookmark
{
    [self.db open];
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    NSString *sql = @"select count(*) as count from sqlite_master where type='table' and name='bookmark_page'";
    FMResultSet *resul0 = [self.db executeQuery:sql];
    if(resul0){
        int i = 0;
        while ([resul0 next]) {
            i = [resul0 intForColumn:@"count"];
        }
        if(i > 0){
            [resul0 close];
            
            FMResultSet *result = [self.db executeQuery:@"select id,title,url,createtime from bookmark_page order by id desc; "];
           
            if(result){
                while([result next]){
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[result stringForColumn:@"title"] forKey:@"title"];
                    [dic setObject:[result stringForColumn:@"url"] forKey:@"url"];
                    [dic setObject:[result stringForColumn:@"id"] forKey:@"id"];
                    [dic setObject:[result stringForColumn:@"createtime"] forKey:@"createtime"];
                    [marray addObject:dic];
                }
            }
            [result close];
            [self.db close];
        }
    }
    return marray;
}

/* 查询数据 历史记录 */
- (NSMutableArray *)queryWithHistory
{
    [self.db open];
    NSMutableArray *marray = [[NSMutableArray alloc] init];
    NSString *sql = @"select count(*) as count from sqlite_master where type='table' and name='history_page'";
    FMResultSet *resul0 = [self.db executeQuery:sql];
    if(resul0){
        int i = 0;
        while ([resul0 next]) {
            i = [resul0 intForColumn:@"count"];
        }
        if(i > 0){
            [resul0 close];
            
            FMResultSet *result = [self.db executeQuery:@"select id,title,url,createtime from history_page order by id desc;"]; 
            if(result){
                while ([result next]) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[result stringForColumn:@"title"] forKey:@"title"];
                    [dic setObject:[result stringForColumn:@"url"] forKey:@"url"];
                    [dic setObject:[result stringForColumn:@"id"] forKey:@"id"];
                    [dic setObject:[result stringForColumn:@"createtime"] forKey:@"createtime"];
                    [marray addObject:dic];
                }
            }
            [result close];
            [self.db close];
        }
    }
    return marray;
}

/* 创建数据表 */
- (void)createDatabaseName:(NSString *)createSql
{
    [self.db open];
    [self.db executeUpdate:createSql];
    [self.db close];
}

@end
