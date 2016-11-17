//
//  ZRBookmarkController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/2/6.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRBookmarkController.h"
#import "ZRHistoryPage.h"
#import "ZRBookmark.h"
#import "ZRWebViewController.h"
#import "ZRRegularExpression.h"
#import "ZRAlertController.h"
#import "ZRToast.h"
//#import "ZRBookmarkNavigation.h"

@interface ZRBookmarkController ()/*<ZRBookmarkNavigationDelegate>*/

/* 临时存储数据集合 */
@property (nonatomic,strong) NSMutableArray *arrayData;

/* 历史记录 */
@property (nonatomic,strong) NSMutableArray *arrayDataHistory;

/* 书签 */
@property (nonatomic,strong) NSMutableArray *arrayDataBookmark;

/* 空数据提示按钮 */
@property (nonatomic,strong) UIButton *tipbutton;

/* 是否是历史记录选项卡选中 */
@property (nonatomic,assign) BOOL isHistorySelected;

/* 当前选中的SegmentIndex */
@property (nonatomic,assign) CGFloat selectedSegmentIndex;

/* 书签或者历史记录的导航栏 */
//@property (nonatomic,strong) ZRBookmarkNavigation *bookmarkNavigation;
@end

@implementation ZRBookmarkController

/* 默认第一个数据是历史记录 */
- (NSMutableArray *)arrayData
{
    if(!_arrayData){
        _arrayData = [[[ZRHistoryPage alloc] init] query];
        self.isHistorySelected = YES;
    }
    return _arrayData;
}

/* 历史记录数据加载 */
- (NSMutableArray *)arrayDataHistory
{
    if(!_arrayDataHistory){
        _arrayDataHistory = [[[ZRHistoryPage alloc] init] query];
    }
    return _arrayDataHistory;
}

/* 书签记录数据 */
- (NSMutableArray *)arrayDataBookmark
{
    if(!_arrayDataBookmark){
        _arrayDataBookmark = [[ZRBookmark alloc] query];
        [_arrayDataBookmark insertObject:[self dictionaryWithBookmark:@"Google" withURL:@"http://www.google.com/"] atIndex:0];
        [_arrayDataBookmark insertObject:[self dictionaryWithBookmark:@"Apple" withURL:@"http://www.apple.com/"] atIndex:0];
        [_arrayDataBookmark insertObject:[self dictionaryWithBookmark:@"好搜" withURL:@"http://www.so.com/"] atIndex:0];
        [_arrayDataBookmark insertObject:[self dictionaryWithBookmark:@"Bing" withURL:@"http://m.bing.com/"] atIndex:0];
        [_arrayDataBookmark insertObject:[self dictionaryWithBookmark:@"百度" withURL:@"http://m.baidu.com/"] atIndex:0];
        
    }
    return _arrayDataBookmark;
}

- (NSMutableDictionary *)dictionaryWithBookmark:(NSString *)title withURL:(NSString *)url
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"title"] = title;
    dic[@"url"] = url;
    return dic;
}

/* 导航栏 */
//- (ZRBookmarkNavigation *)bookmarkNavigation
//{
//    if(!_bookmarkNavigation){
//        CGRect rect = self.view.frame;
//        rect.size.height += rect.origin.y;
//        rect.origin.y = 0;
//        self.view.frame = rect;
//        ZRBookmarkNavigation *bookmarkNav = [[ZRBookmarkNavigation alloc] initWithFrame:rect];
//        bookmarkNav.delegate = self;
//        bookmarkNav.alpha = 0.95;
//        _bookmarkNavigation  = bookmarkNav;
//    }
//    return _bookmarkNavigation;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //右上角清空按钮
    [self addRightButton];
    
    //中间的UISegment
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"历史记录",@"书签"]];
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;

//    [self configAnimationShow];
}

- (void)addRightButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(bookmarkButtonClear)];
}

- (void)removeRightButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

///* 动画展示书签页 */
//- (void)configAnimationShow
//{
//    CGRect rect = self.view.frame;
//    rect.origin.x = rect.size.width;
//    self.view.frame = rect;
//    
//    [UIView animateWithDuration:0.5f animations:^{
//        CGRect rect = self.view.frame;
//        rect.origin.x = 0;
//        self.view.frame = rect;
//    }];
//    
//     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//}

#pragma mark - ZRBookmarkNavigationDelegate代理事件
/* 以前当前控制器 */
//- (void)bookmarkBackLastController
//{
//    [UIView animateWithDuration:0.3f animations:^{
//        CGRect rect = self.view.frame;
//        rect.origin.x = rect.size.width;
//        self.view.frame = rect;
//    } completion:^(BOOL finished) {
//        if(finished){
//            [self.view removeFromSuperview];
//        }
//    }];
//}

/* 历史记录清空 */
- (void)bookmarkButtonClear
{
    if(self.isHistorySelected && self.arrayDataHistory.count > 0){
        typeof(self) weakSelf = self;
        ZRAlertController *alert = [ZRAlertController defaultAlert];
        [alert alertShowWithTitle:@"" message:@"是否清空全部记录？" okayButton:@"好的" completion:^{
            [[[ZRHistoryPage alloc] init] clearAllHistory];
            [ZRToast toastSuccess:weakSelf.navigationController];
            weakSelf.arrayData = nil;
            weakSelf.arrayDataHistory = nil;
            [weakSelf.tableView reloadData];
            
            CGFloat w = weakSelf.view.frame.size.width;
            CGFloat h = 20;
            CGFloat y = (weakSelf.view.frame.size.height - 100) / 2;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, w, h)];
            [button setTitle:@"暂时没有记录哦~~" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitleColor:MainColorRed forState:UIControlStateNormal];
            [weakSelf.view addSubview:button];
            weakSelf.tipbutton = button;
            
            //            [weakSelf.bookmarkNavigation setClearButton:YES];
        }];
    }
}

/* 中间的UISegment切换 */
- (void)segmentChanged:(UISegmentedControl *)segment
{
    self.selectedSegmentIndex = segment.selectedSegmentIndex;
    if(segment.selectedSegmentIndex == 0){
        self.isHistorySelected = YES;
        if(self.arrayDataHistory.count > 0){
//            [self.bookmarkNavigation setClearButton:NO];
            [self addRightButton];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        self.arrayData = self.arrayDataHistory;
        [self.tableView reloadData];
    } else {
        self.isHistorySelected = NO;
//         [self.bookmarkNavigation setClearButton:YES];
        [self removeRightButton];
        
        self.arrayData = self.arrayDataBookmark;
        [self.tableView reloadData];
    }

    if(self.arrayData.count == 0){
        CGFloat w = self.view.frame.size.width;
        CGFloat h = 20;
        CGFloat y = (self.view.frame.size.height - 100) / 2;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, w, h)];
        [button setTitle:@"暂时没有记录哦~~" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:MainColorRed forState:UIControlStateNormal];
        [self.view addSubview:button];
        self.tipbutton = button;
    } else {
        [self.tipbutton removeFromSuperview];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.arrayData objectAtIndex:indexPath.row];
    
    static NSString *ID = @"static_bookmark_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = dic[@"url"];
    
    CGFloat x = 15;
    CGFloat h = 1;
    CGFloat y = cell.frame.size.height - h;
    CGFloat w = self.view.frame.size.width - x * 2;
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(x,y,w,h)];
    [bottomLine setBackgroundColor:ZRColor(234.0f, 235.0f, 237.0f)];
    [cell addSubview:bottomLine];
    return cell;
}       

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.arrayData objectAtIndex:indexPath.row];
    NSString *content = dic[@"url"];
    if([ZRRegularExpression isURL:content]){
        [[ZRWebViewController defaultWebViewController] refreshWebViewWithUrl:content];
    }else{
        NSMutableString *mstr = [[NSMutableString alloc] init];
        [mstr appendString:@"http://m.baidu.com/ssid=79648453/s?word="];
        [mstr appendString:content];
        [[ZRWebViewController defaultWebViewController] refreshWebViewWithUrl:mstr];
    }
//    [self.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.arrayData removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        NSDictionary *dic = [self.arrayData objectAtIndex:indexPath.row];
        if(self.selectedSegmentIndex == 1){
            [[[ZRBookmark alloc] init] deleteOneBookmark:[dic[@"id"] integerValue]];
        } else { 
            [[[ZRHistoryPage alloc] init] deleteOneHistory:[dic[@"id"] integerValue]];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return ZRBookmarkNavigationHeight;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.bookmarkNavigation;
//}

@end
