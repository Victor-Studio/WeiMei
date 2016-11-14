//
//  ZRPageManageController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/5/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRPageManageController.h"
#import "ZRPageManage.h"
#import "ZRWebViewController.h"


@interface ZRPageManageController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, strong) NSMutableArray *allPages;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *tableView;



@end

@implementation ZRPageManageController

//整个显示用TableView显示
- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect rect = self.view.frame;
        CGFloat scroW = rect.size.width;
        CGFloat scroH = rect.size.height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, scroW, scroH - 64)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//从沙盒中取出所有的文件
- (NSMutableArray *)allPages
{
    if (!_allPages) {
        _allPages = [NSMutableArray array];
        
        //取出所有的文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *filepathes = [fileManager contentsOfDirectoryAtPath:ZRPageManageScreenShotsPath error:nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSString *fname in filepathes) {
            if (![fname hasSuffix:@".png"]) continue;
            
            NSString *name = [NSString stringWithFormat:@"%@/%@", ZRPageManageScreenShotsPath, fname];
            NSDate *date = [fileManager attributesOfItemAtPath:name error:nil][NSFileCreationDate];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:date, @"time",name, @"filepath",  nil];
            [tempArr addObject:dic];
        }
        
        //根据时间排序
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
        NSMutableArray *sortArray = [[NSMutableArray alloc] initWithObjects:&descriptor count:1];
        NSArray *array = [tempArr sortedArrayUsingDescriptors:sortArray];
        for (id element in array) {
            [_allPages addObject:element];
        }
    }
    return _allPages;
}

- (UIImage *)bgImage
{
    if (!_bgImage) {
        _bgImage = [UIImage imageWithContentsOfFile:[self.allPages firstObject][@"filepath"]];
    }
    return _bgImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBasis];
//    [self addBottomToolBar];
    [self tableView];
    
}

#pragma mark - 配置基本信息
- (void)configBasis
{
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [btnTitle setTitle:@"页面管理" forState:UIControlStateNormal];
    btnTitle.titleLabel.textColor = [UIColor whiteColor];
    btnTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = btnTitle;
    
    if (AboveIOS8) {
        //添加一个背景图片
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:self.bgImage];
        [bgImage setFrame:self.view.frame];
        [self.view addSubview:bgImage];
        
        //做模糊效果，支持iOS8，及以上
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
        view.frame = self.view.frame;
        [self.view addSubview:view];
    }
    [self allPages];
}



//添加底部的ToolBar
//- (void)addBottomToolBar
//{
//    CGRect rect = self.view.frame;
//    CGFloat height = 37;
//    rect.origin.y = rect.size.height - height;
//    rect.size.height = height;
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:rect];
//    [toolbar setTintColor:[UIColor grayColor]];
//    [toolbar setBarTintColor:MainColor];
//    
////    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPage)];
//    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissCurrentController)];
//   
//    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    
//      toolbar.items = @[flexible, done,flexible2];
//    
//    [self.view addSubview:toolbar];
//  
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//}

//- (void)addPage
//{
////    [ZRWebViewController showWithContro:self withUrlStr:dic[@"filepath"] withTitle:@""];
//}
//
//- (void)dismissCurrentController
//{
//    [self dismissViewControllerAnimated:NO completion:nil];
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allPages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reused_id = @"reused_id_allpages";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reused_id];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reused_id];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSInteger index = indexPath.row;
    NSDictionary *dic = [self.allPages objectAtIndex:index];
    UIImage *timg = [UIImage imageWithContentsOfFile:dic[@"filepath"]];
    
    CGFloat margin = 20;
    CGFloat x = margin;
    CGFloat y = margin * 2;
    //显示的截图
    CGFloat w = timg.size.width - y;
    CGFloat h = timg.size.height - y - 20;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, x, w, h)];
    [imgView setImage:timg];
    imgView.layer.borderColor = kRGB(0xdedede).CGColor;
    imgView.layer.borderWidth = 0.5;
    imgView.userInteractionEnabled = YES;
    
    //上面的navBar
    UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 36)];
    [topLab setBackgroundColor:[UIColor whiteColor]];
    [imgView addSubview:topLab];
    
    //关闭按钮
    CGFloat cW = 20;
    CGFloat cX = 7;
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(cX, cX, cW, cW)];
    [close setImage:[UIImage imageNamed:@"toolbar_icon_stop_btn"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(removePage:) forControlEvents:UIControlEventTouchDown];
    close.tag = index;
    [imgView addSubview:close];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:imgView];
    cell.userInteractionEnabled = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bgImage.size.height - 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.allPages objectAtIndex:indexPath.row];
    NSArray *array = [[[ZRPageManage alloc] init] getFiles];
    if (array) {
        for (ZRPageManageModel *model in array) {
            if ([dic[@"filepath"] containsString:model.filepath]) {
                [[ZRWebViewController defaultWebViewController] refreshWebViewWithUrl:model.pageUrl];
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
    }
}

#pragma mark 删除页面
- (void)removePage:(UIButton *)button
{
    NSError *err;
    NSDictionary *dic = [self.allPages objectAtIndex:button.tag];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager isDeletableFileAtPath:dic[@"filepath"]]) {
        [fileManager removeItemAtPath:dic[@"filepath"] error:&err];
    }
    [self.allPages removeObjectAtIndex:button.tag];
    
    NSIndexPath *idx = [NSIndexPath indexPathForRow:button.tag inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:idx];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect = cell.frame;
        rect.origin.x = -rect.size.width;
        cell.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tableView reloadData];
        }
    }];
    
//    [self.tableView beginUpdates];
//    NSIndexPath *idx = [NSIndexPath indexPathForRow:button.tag inSection:0];
//    [self.tableView deleteRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationLeft];
//    [self.tableView endUpdates];
}
@end







