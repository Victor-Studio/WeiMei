//
//  ZRPageManage.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/5/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRPageManage.h"

//写入到沙盒的文件路径
#define ZRPageManageFilePathForArray [ZRPageManageScreenShotsPath stringByAppendingPathComponent:@"/ZRPageManage.data"]

@implementation ZRPageManage

+ (instancetype)defaultPageManage
{
    static ZRPageManage *manage;
    static dispatch_once_t manage_t;
    dispatch_once(&manage_t, ^{
        manage = [[ZRPageManage alloc] init];
    });
    return manage;
}

- (NSMutableArray *)allPageModels
{
    if (!_allPageModels) {
        _allPageModels = [[NSMutableArray alloc] init];
    }
    return _allPageModels;
}

- (void)getDirectory
{
    NSFileManager *mng = [NSFileManager defaultManager];
    BOOL isDir;
    [mng fileExistsAtPath:ZRPageManageScreenShotsPath isDirectory:&isDir];
    if (!isDir) {
        [mng createDirectoryAtPath:ZRPageManageScreenShotsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSArray *)getFiles
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:ZRPageManageFilePathForArray];
}

- (void)writeToFilePath:(ZRPageManageModel *)model
{
    if (model) {
        NSArray *arr = [self getFiles];
        if (arr) {
            self.allPageModels = (NSMutableArray *)arr;
        }
        [self.allPageModels addObject:model];
        [NSKeyedArchiver archiveRootObject:self.allPageModels toFile:ZRPageManageFilePathForArray];
    }
}

@end


#define PageTitle @"PageTitle"
#define PageUrl @"PageUrl"
#define FileName @"FileName"

@implementation ZRPageManageModel

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.pageTitle = [decoder decodeObjectForKey:PageTitle];
        self.pageUrl = [decoder decodeObjectForKey:PageUrl];
        self.filepath = [decoder decodeObjectForKey:FileName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.pageTitle forKey:PageTitle];
    [encoder encodeObject:self.pageUrl forKey:PageUrl];
    [encoder encodeObject:self.filepath forKey:FileName];
}

@end




