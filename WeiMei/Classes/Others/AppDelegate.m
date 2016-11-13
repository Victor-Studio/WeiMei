//
//  AppDelegate.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 15/12/27.
//  Copyright (c) 2015年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "AppDelegate.h" 
#import "ZRAlertController.h"
#import <TencentOpenAPI/TencentOAuth.h>


@interface AppDelegate ()
 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    
    //友盟社会化分享组件
    [self configUMShare];
     
    //配置推送功能
    [self configPushNotifications:launchOptions];
    
    return YES;
}

/**
 * 配置友盟分享组件
 */
- (void)configUMShare
{
//    [UMSocialData setAppKey:@"56e6368ce0f55a7ad10008f4"];
//    [UMSocialQQHandler setQQWithAppId:@"1105252918" appKey:@"5P04OpVhQxwQWWdF" url:@"https://itunes.apple.com/cn/app/wei-mei-liu-lan-qi/id1067649034?l=en&mt=8"];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"629936339" secret:@"" RedirectURL:@"https://itunes.apple.com/cn/app/wei-mei-liu-lan-qi/id1067649034?l=en&mt=8"]; 
}

/**
 * 推送功能都在这里
 */
- (void)configPushNotifications:(NSDictionary *)launchOptions
{  
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
    
    //如果等于FALSE, 就是其他SDK, 而非友盟
//    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        
        //处理QQ的返回
        if([sourceApplication isEqualToString:@"com.tencent.mqq"] &&
           [[url absoluteString] hasPrefix:@"tencent1105252918://"]){
            return [TencentOAuth HandleOpenURL:url];
        }
//    }
    return NO;
}



@end
