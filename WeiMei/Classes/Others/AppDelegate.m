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
#import "BDSSpeechSynthesizer.h"

@interface AppDelegate ()
 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self configBDSSpeech];
    
    //配置推送功能
    [self configPushNotifications:launchOptions];
    
    return YES;
}

//百度语音合成
- (void)configBDSSpeech
{
    // 在线相关设置
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:@"2YVELTHw6TVYlPoYwQYs7EzZ" withSecretKey:@"f70b4d485a1bf050ea4c71e2e08dcdb3"];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithFloat:10.0] forKey:BDS_SYNTHESIZER_PARAM_ONLINE_REQUEST_TIMEOUT];
    
    // 离线相关设置
    NSError* ret=[[BDSSpeechSynthesizer sharedInstance] loadOfflineEngine:@"English_Text.dat"
                                                           speechDataPath:@"English_Speech_Female.dat"
                                                          licenseFilePath:@ "offline_engine_tmp_license.dat"
                                                              withAppCode: @"8906336"
                  ];
    if( ret != nil) {
        /*错误*/
        NSLog(@"百度语音合成相关数据错误！ error = %@", ret);
    }

    
    //女生
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:BDS_SYNTHESIZER_SPEAKER_FEMALE] forKey:BDS_SYNTHESIZER_PARAM_SPEAKER];
    
    //中级音量
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5] forKey:BDS_SYNTHESIZER_PARAM_VOLUME];
    
    //中速
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5] forKey:BDS_SYNTHESIZER_PARAM_SPEED];

    //中调
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5] forKey:BDS_SYNTHESIZER_PARAM_PITCH];
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
