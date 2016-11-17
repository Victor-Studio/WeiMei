//
//  ZRFeaturesController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/9/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRFeatures.h"
#import "ZRCommonUtils.h"


@interface ZRFeatures ()

@end

@implementation ZRFeatures

- (void)setNeedsDisplay
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    NSString *iphone = nil, *ipad = nil;
    CGFloat x = 0, y = 0, w = rect.size.width, h = rect.size.height;
    int count = 5;
    for (int i = 1; i <= count; i ++) {
        
        x = (i - 1) * w;
        UIImageView *img = [[UIImageView alloc] initWithFrame:rect];
        if([ZRCommonUtils iPadProWithWidth:rect.size.width heigh:rect.size.height]){
            ipad = [NSString stringWithFormat:@"Launch%diPadPro", i];
            [img setImage:[UIImage imageNamed:ipad]];
        }else{
            iphone = [NSString stringWithFormat:@"Launch%diPhone6p", i];
            [img setImage:[UIImage imageNamed:iphone]];
        }
        [img setFrame:CGRectMake(x, y, w, h)];
        [img setUserInteractionEnabled:YES];
        [self addSubview:img];
    }
     
    [self setFrame:rect];
    [self setContentSize:CGSizeMake(count * w, h)];
    self.pagingEnabled = YES;
}

@end
