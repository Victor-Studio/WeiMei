//
//  ZRQQLoginSingleton.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 3/29/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRQQLoginSingleton.h"

#define QQLoginFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"QQLoginObject.data"]

@implementation ZRQQLoginSingleton

/**
 * 对需要逆归档的属性进行解码
 **/
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
    
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.openId = [decoder decodeObjectForKey:@"openId"];
        self.expiredDate = [decoder decodeObjectForKey:@"expiredDate"];
        self.avatarSmall = [decoder decodeObjectForKey:@"avatarSmall"];
        self.avatarStandard = [decoder decodeObjectForKey:@"avatarStandard"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
    }
    return self;
}

/**
 * 对需要归档的属性编码
 **/
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.openId forKey:@"openId"];
    [encoder encodeObject:self.expiredDate forKey:@"expiredDate"];
    [encoder encodeObject:self.avatarSmall forKey:@"avatarSmall"];
    [encoder encodeObject:self.avatarStandard forKey:@"avatarStandard"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
}
 

+ (instancetype)defaultQQLoginSingleton
{
    static ZRQQLoginSingleton *qqlogin;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        qqlogin = [[ZRQQLoginSingleton alloc] init];
    });
    return qqlogin;
} 

/**
 * 归档该类
 */
- (void)writeObjectToFile
{
    [NSKeyedArchiver archiveRootObject:self toFile:QQLoginFilePath];
}

/**
 * 逆归档该类
 */
- (void)getObjectFromFile
{
    if([[NSFileManager defaultManager] fileExistsAtPath:QQLoginFilePath]){
        ZRQQLoginSingleton *qqlogin = [NSKeyedUnarchiver unarchiveObjectWithFile:QQLoginFilePath];
        self.accessToken = qqlogin.accessToken;
        self.openId = qqlogin.openId;
        self.expiredDate = qqlogin.expiredDate;
        self.avatarSmall = qqlogin.avatarSmall;
        self.avatarStandard = qqlogin.avatarStandard;
        self.nickName = qqlogin.nickName;
    }
}

- (void)dispose
{
    self.accessToken = nil;
    self.openId = nil;
    self.expiredDate = nil;
    self.avatarSmall = nil;
    self.avatarStandard = nil;
    self.nickName = nil;
    [[NSFileManager defaultManager] removeItemAtPath:QQLoginFilePath error:nil];
    NSLog(@"QQ已退出登录");
}

@end
