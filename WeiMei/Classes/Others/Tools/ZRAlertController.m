//
//  ZRAlertController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRAlertController.h"

//only use below iOS8
typedef void (^completeViewBlock)();

static completeViewBlock comBlock;

@interface ZRAlertController()<UIAlertViewDelegate>
{
    
}
@end

@implementation ZRAlertController

#pragma mark - 标配 一个title  一个message  一个确定
+ (void)alertView:(UIViewController *)viewController0 title:(NSString *)title message:(NSString *)msg handler:(void (^)(void))callback
{
    
#ifdef AboveIOS8
    UIAlertController * alertCont = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if(callback)
            callback();
    }];
    [alertCont addAction:action];
    [viewController0 presentViewController:alertCont animated:YES completion:nil];
#else
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
    [alertView show];
#endif
}

#pragma mark - 标配 一个title  一个message  一个确定   一个取消
+ (void)alertView:(UIViewController *)viewController0 message:(NSString *)msg handler:(void (^)(void))callback
{
    
#ifdef AboveIOS8
    UIAlertController * alertContr = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(callback)
            callback();
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertContr addAction:action];
    [alertContr addAction:action2]; 
    [viewController0 presentViewController:alertContr animated:YES completion:nil];
#else
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"取消", nil];
    alertView.tag = 2;
    [alertView  show];
    comBlock = callback;
#endif

}

#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2){
        if(buttonIndex == 0){
            comBlock();
        }
    }
}

@end
