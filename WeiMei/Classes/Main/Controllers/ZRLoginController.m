//
//  ZRLoginController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 3/30/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRLoginController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "ZRQQLoginSingleton.h"
#import "ZRAlertController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZRWebViewController.h"


#define kCells @"cells"
#define kFooter @"footers"

#define kCellLogin @"使用QQ登录"
#define kCellExitLogin @"退出"


@interface ZRLoginController()<UITableViewDataSource, UITableViewDelegate,TencentSessionDelegate>
{
    TencentOAuth * _tencentOAuth;
    NSMutableArray *_allCells;
    UITableView *_tableView;
}
@end

@implementation ZRLoginController
- (void)viewDidLoad
{
    [super viewDidLoad] ;
  
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    [self configBackItem];
    [self loadArrayData];
}

- (void)loadArrayData
{
    ZRQQLoginSingleton *qqlogin = [ZRQQLoginSingleton defaultQQLoginSingleton];
    NSString *cell1Name = @"", *cell2Name = @"";
    if(qqlogin.nickName){
        cell1Name = qqlogin.nickName;
        cell2Name = kCellExitLogin;
    }else{
        cell1Name = kCellLogin;
    }
    
    _allCells = [[NSMutableArray alloc] init];
    [_allCells addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          cell1Name,kCells,
                          @"唯美浏览器，使用QQ登录的方式，本应用不会获取用户的QQ的任何私密信息，仅仅是头像和昵称。",kFooter, nil ]];
    
    if(![cell2Name isEqualToString:@""]){
        [_allCells addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              cell2Name,kCells,
                              @"",kFooter, nil]];
    }
}

- (void)configBackItem
{
    UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 22)];
    [backBtn setTintColor:MainColorRed];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.title = @"个人信息";
}
- (void)backBtnPressed
{
    [UIView animateWithDuration:0.2f animations:^{
        CGRect rect = self.view.frame;
        rect.origin.x = rect.size.width;
        self.view.frame = rect;
    } completion:^(BOOL finished) {
        if(finished){
            ZRWebViewController *ccweb = [ZRWebViewController defaultWebViewController];
            [[ccweb.view.subviews lastObject] removeFromSuperview];
            [((UIViewController*)[ccweb.childViewControllers lastObject]) removeFromParentViewController];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allCells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_allCells objectAtIndex:indexPath.section];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell.textLabel setText:dic[kCells]];
    
    ZRQQLoginSingleton *qqlogin = [ZRQQLoginSingleton defaultQQLoginSingleton];
    if (qqlogin.avatarStandard && ![dic[kCells] isEqualToString:kCellExitLogin]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:qqlogin.avatarStandard]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_allCells objectAtIndex:indexPath.section];
    if ([dic[kCells] isEqualToString:kCellLogin]) {
        [self qqlogin];
    } else if ([dic[kCells] isEqualToString:kCellExitLogin]){
        [ZRAlertController alertView:self message:@"确定要退出吗？" handler:^{
            [_tencentOAuth logout:self];
            [[ZRQQLoginSingleton defaultQQLoginSingleton] dispose];
            [self loadArrayData];
            [_tableView reloadData]; 
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSDictionary *dic = [_allCells objectAtIndex:section];
    if (dic[kFooter]) {
        return dic[kFooter];
    }else{
        return nil;
    }
}

- (void)qqlogin
{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO, nil];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kTencentAPIKey andDelegate:self];
    [_tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark - TencentSessionDelegate 登录后代理事件
//登录成功
- (void)tencentDidLogin
{
    NSString * accessToken = [_tencentOAuth accessToken];
    NSString * openId = [_tencentOAuth openId];
    NSDate * expiredDate = [_tencentOAuth expirationDate];
    ZRQQLoginSingleton * qqlogin = [ZRQQLoginSingleton defaultQQLoginSingleton];
    qqlogin.accessToken = accessToken;
    qqlogin.openId = openId;
    qqlogin.expiredDate = expiredDate;
    [_tencentOAuth getUserInfo];
}

//获取登录这信息
- (void)getUserInfoResponse:(APIResponse *)response
{
    if(response.detailRetCode == kOpenSDKErrorSuccess)
    {
        NSDictionary *jsonDic = response.jsonResponse;
        NSString *avatarS = jsonDic[@"figureurl_qq_1"];
        NSString *avatarM = jsonDic[@"figureurl_qq_2"];
        NSString *nickname = jsonDic[@"nickname"];
        ZRQQLoginSingleton * qqlogin = [ZRQQLoginSingleton defaultQQLoginSingleton];
        qqlogin.avatarStandard = avatarM;
        qqlogin.avatarSmall = avatarS;
        qqlogin.nickName = nickname;
        [qqlogin writeObjectToFile];
    } else {
        [ZRAlertController alertView:self message:@"登录失败" handler:nil];
    }
    
    [self loadArrayData];
    [_tableView reloadData];
}

//非网络错误导致登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [ZRAlertController alertView:self message:@"非网络错误导致登录失败" handler:nil];
}

//登出
- (void)tencentDidLogout
{
    NSLog(@"QQ已退出登录");
}

//网络错误导致登录失败
- (void)tencentDidNotNetWork
{
    [ZRAlertController alertView:self message:@"网络错误导致登录失败" handler:nil];
}


@end
