//
//  ZRFeaturePreference.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/9/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRFeaturePreference.h"

static NSString *IsViewedFeatures = @"isViewedZRFeatures";

@implementation ZRFeaturePreference

- (BOOL)read
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:IsViewedFeatures] intValue]){
        return TRUE;
    }else{
        return FALSE;
    }
}

- (void)write
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:IsViewedFeatures];
    [defaults synchronize];
}

@end
