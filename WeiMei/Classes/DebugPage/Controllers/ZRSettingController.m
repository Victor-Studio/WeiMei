//
//  ZRSettingController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/6.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRSettingController.h"
#import "ZRWebViewController.h"  
#import "UIView+Toast.h"

#define kCells @"Cell"
#define kFooters @"footer"
#define kCellAction @"ActionName"

#define kVersionText @"唯美浏览器版本"

@interface ZRSettingController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView * _tableView;
    NSArray * _arrayData;
    unsigned long long _allSizeM;
    unsigned long long _allSizeBytes;
    NSMutableArray * _allFilesPath;
    BOOL isDelete;
}
@end

@implementation ZRSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self iniTableView];
    
    //初始化 是否已经删除过
    isDelete = YES;
    
    [self configBasis];
    
    [self loadCellData];
    
    [self addIcon];
}

//添加一个图标
- (void)addIcon
{
    CGFloat w = 80;
    CGFloat x = (_tableView.frame.size.width - w) / 2;
    UIImageView *iImg = [[UIImageView alloc] initWithFrame:CGRectMake(x, -70, w, w)];
    [iImg setImage:[UIImage imageNamed:@"AppIcon"]];
    [iImg.layer setCornerRadius:15];
    iImg.layer.masksToBounds = YES;
    [_tableView addSubview:iImg];
}

//初始化UITableView
- (void)iniTableView
{
    //添加一个UITableView
    UITableView *tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setContentInset:UIEdgeInsetsMake(90, 0, 0, 0)];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - 配置基本信息
- (void)configBasis
{
    self.title = @"设置";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
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

- (void)loadCellData
{
    [self getAllCacheFiles];
 
    _arrayData = @[
                   @{
                    kCells : @"评论APP",
                    kFooters : @"",
                    kCellAction : @"commentApp"
                    },
                   @{
                    kCells : @"清除浏览器缓存",
                    kFooters : [NSString stringWithFormat:@"一共%lldM缓存内容, 共%lld字节。", _allSizeM, _allSizeBytes],
                    kCellAction : @"clearCache"
                    },
                   @{kCells : kVersionText,
                     kFooters : @"",
                     kCellAction : @"aboutBrowser"
                     }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_arrayData objectAtIndex:indexPath.section];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = dic[kCells];
    
    if([dic[kCells] isEqualToString:kVersionText]){
        NSString *version = [[[NSBundle mainBundle] infoDictionary]  objectForKey:(NSString *)kCFBundleVersionKey];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        [label setText:[NSString stringWithFormat:@"v %@", version]];
        [label setFont:[UIFont systemFontOfSize:13]];
        cell.accessoryView = label;
    }
    return cell;
} 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_arrayData objectAtIndex:indexPath.section];
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@", dic[kCellAction]]);
    SuppressPerformSelectorLeakWarning([self performSelector:sel]);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSDictionary *dict = [_arrayData objectAtIndex:section];
    return dict[kFooters];
}

//跳转评论
- (void)commentApp
{
    if (AboveIOS7) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1067649034"]];
     } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1067649034"]];
     }
}

//获得所有缓存文件
- (void)getAllCacheFiles
{
    NSString *preferPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cachePath = [preferPath stringByAppendingPathComponent:@"Caches"];
    NSString *cookiesPath = [preferPath stringByAppendingPathComponent:@"Cookies"];
    NSString *webkitpath = [preferPath stringByAppendingPathComponent:@"WebKit"];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"weimei.sqlite"];
    
    _allFilesPath = [NSMutableArray array];
    [_allFilesPath addObject:cachePath];
    [_allFilesPath addObject:cookiesPath];
    [_allFilesPath addObject:webkitpath];
    [_allFilesPath addObject:sqlitePath];
    
    NSFileManager *fileMng = [NSFileManager defaultManager];
    NSDictionary *dictSqlSize = [fileMng attributesOfItemAtPath:sqlitePath error:nil];
    NSDictionary *cacheSize = [fileMng attributesOfItemAtPath:cachePath error:nil];
    NSDictionary *cookieSize = [fileMng attributesOfItemAtPath:cookiesPath error:nil];
    NSDictionary *webkitSize = [fileMng attributesOfItemAtPath:webkitpath error:nil];
    int n = 1024;
    _allSizeM = (dictSqlSize.fileSize / n) + (cacheSize.fileSize / n) + (cookieSize.fileSize / n) + (webkitSize.fileSize / n);
    _allSizeBytes = dictSqlSize.fileSize + cacheSize.fileSize + cookieSize.fileSize + webkitSize.fileSize;
}

//清除缓存文件
- (void)clearCache
{
    if(isDelete){
        NSFileManager *fileMng = [NSFileManager defaultManager];
        for(NSString *path in _allFilesPath){
            [fileMng removeItemAtPath:path error:nil];
        }
        isDelete = NO;
        [_tableView makeToast:@"缓存清除成功！" duration:1.5 position:CSToastPositionTop];
        [self loadCellData];
        [_tableView reloadData];
    } else {
        [_tableView makeToast:@"缓存文件已经全部被删除！" duration:1.5 position:CSToastPositionTop];
    }
}

//关于浏览器
- (void)aboutBrowser
{
    
}

@end
