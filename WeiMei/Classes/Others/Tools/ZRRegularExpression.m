//
//  ZRRegularExpression.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/26.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRRegularExpression.h"

@implementation ZRRegularExpression

/* whether or not url */
+ (BOOL)isURL:(NSString *)content
{
    NSMutableString *mregular = [[NSMutableString alloc] init];
    [mregular appendString: @"^((https|http|ftp|rtsp|mms)?://)"];
    //ftp的user@
    [mregular appendString: @"?(([0-9a-zA-Z_!~*'().&=+$%-]+: )?[0-9a-zA-Z_!~*'().&=+$%-]+@)?"];
    // IP形式的URL- 199.194.52.184
    [mregular appendString: @"(([0-9]{1,3}\\.){3}[0-9]{1,3}"];
    // 允许IP和DOMAIN（域名）
    [mregular appendString: @"|"];
    // 域名- www.
    [mregular appendString: @"([0-9a-zA-Z_!~*'()-]+\\.)*"];
    // 二级域名
    [mregular appendString: @"([0-9a-zA-Z][0-9a-zA-Z-]{0,61})?[0-9a-zA-Z]\\."];
    // first level domain- .com or .museum
    [mregular appendString: @"[a-zA-Z]{2,6})"];
    // 端口- :80
    [mregular appendString: @"(:[0-9]{1,4})?"];
    [mregular appendString: @"((/?)|"];
    [mregular appendString: @"(/[0-9a-zA-Z_!~*'().;?:@&=+$,%#-]+)+/?)$"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mregular];
    return [predicate evaluateWithObject:content];
}

@end
