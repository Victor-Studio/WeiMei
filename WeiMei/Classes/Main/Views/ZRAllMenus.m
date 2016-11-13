//
//  ZRAllMenus.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 3/28/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRAllMenus.h"
#import "ZRCommonUtils.h"
#import "ZRAllMenusButton.h"
#import "ZRAlertController.h"
#import "ZRAllMenusModel.h"
#import "ZRQQLoginSingleton.h" 
#import <SDWebImage/UIButton+WebCache.h>

@interface ZRAllMenus()

/* 功能菜单的所有按钮 */
@property (nonatomic, strong) NSArray *allMenusModel;

@end

@implementation ZRAllMenus

/* 功能菜单的所有按钮 */
- (NSArray *)allMenusModel{
    if(!_allMenusModel){
        _allMenusModel = [ZRAllMenusModel allMenusModel];
    }
    return _allMenusModel;
}

- (instancetype)initWithRect:(CGRect)rect withTabbarRect:(CGRect)rect1
{
    if(self = [super init]){
        
        //上面灰度层
        CGRect detailsRect = rect;
        CGFloat dHeight1 = rect.size.height * 0.62;
        detailsRect.size.height = dHeight1;
        CGFloat dHeight1_start_y = - dHeight1;
        CGFloat dHeight1_end_y = 0;
        detailsRect.origin.y = dHeight1_start_y;
        __block UIButton *topMask = [[UIButton alloc] initWithFrame:detailsRect];
        topMask.tag = 1;
        [topMask setBackgroundColor:[UIColor blackColor]];
        [topMask setAlpha:0.4];
        [topMask addTarget:self action:@selector(removeDetailsMenus) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:topMask];
        
        //动画展示
        [UIView animateWithDuration:ZRTabbarMenusAnimationSpeed animations:^{
            CGRect topMaskRect = topMask.frame;
            topMaskRect.origin.y = dHeight1_end_y;
            topMask.frame = topMaskRect;
        }];
        
        
        //下面菜单UIView层
        CGFloat dHeight2 = rect.size.height * 0.38;
        detailsRect.size.height = dHeight2;
        CGFloat dHeight2_start_y = rect.size.height + dHeight2;
        CGFloat dHeight2_end_y = rect.size.height - dHeight2;
        detailsRect.origin.y = dHeight2_start_y;
        __block UIView *details = [[UIView alloc] initWithFrame:detailsRect];
        details.tag = 2;
        [details setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:details];
        
        //动画展示
        [UIView animateWithDuration:ZRTabbarMenusAnimationSpeed animations:^{
            CGRect detailsRect = details.frame;
            detailsRect.origin.y = dHeight2_end_y;
            details.frame = detailsRect;
        }];
        
        
        //最底部关闭层
        CGFloat cloBtnH = rect1.size.height;
        detailsRect.size.height = cloBtnH;
        CGFloat cloBtnY = details.frame.size.height - cloBtnH;
        detailsRect.origin.y = cloBtnY;
        UIView *closeView = [[UIView alloc] initWithFrame:detailsRect];
        [closeView setBackgroundColor:MainColor];
        [details addSubview:closeView];
        
        //最底部关闭按钮
        CGFloat btnY = 10;
        CGFloat btnW = cloBtnH - btnY * 2;
        CGFloat btnX = (detailsRect.size.width - btnW) / 2;
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnW)];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"toolbar_icon_stop_btn"] forState:UIControlStateNormal];
        closeButton.tag = 10;
        [closeButton addTarget:self action:@selector(removeDetailsMenus) forControlEvents:UIControlEventTouchUpInside];
        [closeView addSubview:closeButton];
        
        //11个按钮菜单
        CGFloat allCount = self.allMenusModel.count;
        int count = 4;
        CGFloat marginAMLeft = 25;
        CGFloat marginAMTop = 12;
        CGFloat detailsButtonFontSize = 9;
        CGFloat amMarginTop = 30;
        CGFloat amW = 37;
        CGFloat amH = 47;
        CGFloat amX = 0;
        CGFloat amY = 0;
        
        CGFloat viewWidth = rect.size.width;
        CGFloat viewHeight = rect.size.height;
        if([ZRCommonUtils iPhone4:viewWidth heigh:viewHeight]){
            detailsButtonFontSize = 8;
            amMarginTop = 10;
            marginAMTop = 2;
            amW = 33;
            amH = 39;
        } else if([ZRCommonUtils iPhone5:viewWidth heigh:viewHeight]){
            amMarginTop = 15;
            marginAMTop = 6;
        } else if([ZRCommonUtils iPhone6:viewWidth heigh:viewHeight]){
            detailsButtonFontSize = 9;
            amW = 37;
            amH = 47;
        } else if([ZRCommonUtils iPhone6plus:viewWidth heigh:viewHeight]){
            detailsButtonFontSize = 11;
            amW = 46;
            amH = 56;
        } else if([ZRCommonUtils iPadMiniWithWidth:viewWidth heigh:viewHeight]
                  || [ZRCommonUtils iPadProWithWidth:viewWidth heigh:viewHeight]
                  || [ZRCommonUtils iPadRetinaWithWidth:viewWidth heigh:viewHeight]){
            detailsButtonFontSize = 17;
            marginAMTop = 10;
            amW = 90;
            amH = 90;
        }
        
        CGFloat amMarginLeft = (details.frame.size.width - (marginAMLeft * 2) - (count * amW)) / (count - 1);
        for (int i = 0; i < allCount; i ++) {
            int colIdx = i % count;
            int rowIdx = i / count;
            
            amX = marginAMLeft + colIdx * (amW + amMarginLeft);
            amY = amMarginTop + rowIdx * (amH + marginAMTop);
            CGRect amRect = CGRectMake(amX, amY, amW, amH);
            
            ZRAllMenusModel *model = [self.allMenusModel objectAtIndex:i];
            ZRAllMenusButton *button = [[ZRAllMenusButton alloc] allMenusButtonWithFrame:amRect withTitle:model.title withImage:model.icon  withFont:detailsButtonFontSize];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [details addSubview:button];
        }
        
        
        
        ZRQQLoginSingleton *qqlogin = [ZRQQLoginSingleton defaultQQLoginSingleton];
        [qqlogin getObjectFromFile];
        
        //添加登录头像
        CGFloat avatarW = amW * 1.8;
        CGFloat avatarH = avatarW;
        CGFloat avatarX = marginAMLeft * 0.5;
        CGFloat avatarY = viewHeight - dHeight2 * 1.32;
        if([ZRCommonUtils iPhone4:viewWidth heigh:viewHeight]){
            avatarY = viewHeight - dHeight2 * 1.28;
        } else if([ZRCommonUtils iPhone5:viewWidth heigh:viewHeight]){
            avatarY = viewHeight - dHeight2 * 1.25;
        } else if([ZRCommonUtils iPhone6:viewWidth heigh:viewHeight]){
            avatarY = viewHeight - dHeight2 * 1.15;
        } else if([ZRCommonUtils iPhone6plus:viewWidth heigh:viewHeight]){
            avatarY = viewHeight - dHeight2 * 1.18;
        }
        UIButton *avatar = [[UIButton alloc] initWithFrame:CGRectMake(avatarX, avatarY, avatarW, avatarH)];
        [avatar.layer setBorderWidth:1.0];
        [avatar.layer setMasksToBounds:YES];
        [avatar.layer setCornerRadius:avatarW * 0.5];
        if(qqlogin.avatarStandard){
            [avatar sd_setBackgroundImageWithURL:[NSURL URLWithString:qqlogin.avatarStandard] forState:UIControlStateNormal];
            [avatar.layer setBorderColor:[UIColor whiteColor].CGColor];
        }else{
            [avatar setBackgroundColor:[UIColor whiteColor]];
            [avatar setTitle:@"请登录" forState:UIControlStateNormal];
            [avatar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [avatar.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [avatar.layer setBorderColor:[UIColor grayColor].CGColor];
        }
        [avatar addTarget:self action:@selector(avatarLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:avatar];

    }
    return self;
}

- (void)avatarLogin
{
    if([self.delegate respondsToSelector:@selector(allMenusForLogin)]){
        [self.delegate allMenusForLogin];
    }
}


- (void)buttonClick:(ZRAllMenusButton *)button
{
    if([self.delegate respondsToSelector:@selector(allMenusForButtonClick:withMenusModel:)]){
        [self.delegate allMenusForButtonClick:button withMenusModel:self.allMenusModel];
    }
}

- (void)removeDetailsMenus
{
    if([self.delegate respondsToSelector:@selector(allMenusForRemoveDetails)]){
        [self.delegate allMenusForRemoveDetails];
    }
}

/**
 * 由于UIView里的点击事件问题，这里需要重写父类的事件传递方法，防止UIView穿透到父类（也就是当前的UIView的下面view）
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    BOOL value = (CGRectContainsPoint(frame, point));
    NSArray *views = [self subviews];
    for (UIView *subview in views) {
        value = (CGRectContainsPoint(subview.frame, point));
        if (value) return value;
    } 
    return NO;
}

@end
