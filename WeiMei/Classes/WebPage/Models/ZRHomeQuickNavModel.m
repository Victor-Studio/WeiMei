//
//  ZRHomeQuickNavModel.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/3.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRHomeQuickNavModel.h"

@implementation ZRHomeQuickNavModel

- (instancetype)initQuickNav:(NSDictionary *)dic
{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

#pragma mark - 返回数组内容
+ (NSArray *)quickNavArray
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeQNav" ofType:@".plist"]];
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (NSDictionary  *dic in array) {
        [marr addObject:[[ZRHomeQuickNavModel alloc] initQuickNav:dic]];
    }
    return marr;
}

@end
