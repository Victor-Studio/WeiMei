//
//  ZRNavigation.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/29.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRWebNavigation.h"

#define WebViewNav_TintColor MainColorRed

@interface ZRWebNavigationController()

@end

@implementation ZRWebNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = MainColorRed;
    self.navigationBar.tintColor = [UIColor whiteColor];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end


//@interface ZRWebNavigation()
//@property (nonatomic,assign) CGFloat statusHeight;
//
//@property (nonatomic,strong) UILabel *titleLabel;
//
//@end
//
//@implementation ZRWebNavigation
//
//- (CGFloat)statusHeight{
//    if(_statusHeight == 0){
//        _statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 8;
//    }
//    return _statusHeight;
//}
//
//- (instancetype)init{
//    if (self = [super init]) {
//        [self setBackgroundColor:[UIColor whiteColor]]; 
//    }
//    return self;
//}
//
//- (void)setFrame:(CGRect)frame
//{
//    CGFloat frameHeight = ZRNavigationHeight - 1;
//    frame.size.height = frameHeight;
//    frame.origin.x = 0;
//    frame.origin.y = 0;
//    [super setFrame:frame];
//    
//    if(frame.size.width > 0 && frame.size.height > 0){
//        //底部的线条
//        UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, frameHeight, frame.size.width, 1)];
//        [bottomLine setBackgroundColor:NavigationBottomColor];
//        [self addSubview:bottomLine];
//        
//        //导航栏的返回按钮
//        UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
//        backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 21)];
//        [backBtn setTintColor:WebViewNav_TintColor];
//        [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(removeContr) forControlEvents:UIControlEventTouchUpInside];
//        self.leftButton = backBtn;
//        [self addSubview:self.leftButton];
//        
//        //右上角菜单
//        UIImage *menuImage = [UIImage imageNamed:@"cc_webview_menu"];
//        menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        [menuBtn setTintColor:WebViewNav_TintColor];
//        [menuBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 8)];
//        [menuBtn setImage:menuImage forState:UIControlStateNormal];
//        [menuBtn addTarget:self action:@selector(menuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//        self.rightButton = menuBtn;
//        [self addSubview:self.rightButton];
//        
//        //中间的title
//        UILabel *title = [[UILabel alloc] init];
//        [title setText:self.titleLabelText];
//        [title setTextColor:[UIColor blackColor]];
//        [title setTextAlignment:NSTextAlignmentCenter];
//        self.titleLabel = title;
//        [self addSubview:self.titleLabel];
//        
//    }
//}
//
//#pragma mark - 移除控制器
//- (void)removeContr
//{
//    if([self.delegate respondsToSelector:@selector(removeController)]){
//        [self.delegate removeController];
//    }
//}
//
//#pragma mark - 菜单显示
//- (void)menuBtnPressed
//{
//    if([self.delegate respondsToSelector:@selector(showMenu)]){
//        [self.delegate showMenu];
//    }
//}
//
//- (void)setLeftButton:(UIButton *)leftButton
//{
//    _leftButton = leftButton;
//    
//    CGFloat lW = leftButton.frame.size.width;
//    CGFloat lH = leftButton.frame.size.height;
//    CGFloat lX = 10;
//    CGFloat lY = self.statusHeight;
//    _leftButton.frame = CGRectMake(lX, lY, lW, lH);
//}
//
//- (void)setTitleLabel:(UILabel *)titleLabel
//{
//    _titleLabel = titleLabel;
//    
//    CGFloat y = self.statusHeight;
//    CGFloat w = self.frame.size.width - 80;
//    CGFloat x = (self.frame.size.width - w) * 0.5;
//    CGFloat h = 18;
//    [_titleLabel setFrame:CGRectMake(x, y, w, h)];
//}
//
//- (void)setRightButton:(UIButton *)rightButton
//{
//    _rightButton = rightButton;
//    
//    CGRect rect = rightButton.frame;
//    rect.origin.x = self.frame.size.width - rect.size.width - 15;
//    rect.origin.y = self.statusHeight;
//    [_rightButton setFrame:rect];
//}
//
//- (void)setTitleLabelText:(NSString *)titleLabelText
//{
//    [self.titleLabel setText:titleLabelText];
//}
//
//@end

