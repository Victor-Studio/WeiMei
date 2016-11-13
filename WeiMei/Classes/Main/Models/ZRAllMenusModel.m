//
//  ZRAllMenusModel.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/5.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRAllMenusModel.h"

@implementation ZRAllMenusModel

- (instancetype)initWithDict:(NSDictionary *)dic{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (NSArray *)allMenusModel
{
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"WebFunctionMenus" ofType:@".plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filename];
    NSMutableArray *marray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        ZRAllMenusModel *model = [[ZRAllMenusModel alloc] initWithDict:dic];
        [marray addObject:model];
    }
    return marray;
}

@end
