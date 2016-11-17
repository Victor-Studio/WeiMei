//
//  ZRSearchHitsViewController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/26.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//

#import "ZRSearchHitsViewController.h"
#import "ZRWebViewController.h"
#import "ZRRegularExpression.h"
#import "ZRHistoryPage.h"
#import "ZRAlertController.h"

@interface ZRSearchHitsViewController()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,weak) UITextField *searchInput;

@property (nonatomic,strong) UITableView *searchHitsTable;

@property (nonatomic, strong) NSArray *arrayData;

@property (nonatomic,assign) CGRect tableHitRect;


@end

@implementation ZRSearchHitsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.基本设置
    [self configBase];
    
    //2.载入数据
    [self loadTableData];
    
    //3.清除历史记录
    [self clearHistory];
} 

#pragma mark - 1.基本设置
- (void)configBase
{ 
    UIView *topSearch = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HomeScrollViewTopHeight)];
    [topSearch setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topSearch];
    
    //创建底部灰色线
    CGFloat blW = topSearch.frame.size.width;
    CGFloat blH = 1;
    CGFloat blY = topSearch.frame.size.height;
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, blY, blW, blH)];
    [bottomLabel setBackgroundColor:NavigationBottomColor];
    [topSearch addSubview:bottomLabel];
    
    //创建搜索框
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height + 6;
    CGRect rect = topSearch.frame;
    CGFloat marginBar = 5;
    rect.origin.x = marginBar;
    rect.origin.y = statusH;
    rect.size.height = 27;
    rect.size.width = topSearch.frame.size.width - marginBar * 2;
    UITextField *searchBar = [[UITextField alloc] initWithFrame:rect];
    [searchBar setPlaceholder:@"搜索或输入网址"];
    [searchBar setBackgroundColor:MainColor];
    searchBar.layer.cornerRadius = marginBar;
    searchBar.font = [UIFont systemFontOfSize:14];
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.delegate = self;
    [topSearch addSubview:searchBar];
    self.searchInput = searchBar;

    //搜索框的长度做动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{        [UIView animateWithDuration:0.2 animations:^{
            CGRect searRect = searchBar.frame;
            searRect.size.width = topSearch.frame.size.width - 50;
            searchBar.frame = searRect;
        }];
    });
    
    //取消按钮
    CGFloat canW = 40;
    CGFloat canH = 40;
    CGFloat canX = topSearch.frame.size.width - canW;
    CGFloat canY = searchBar.frame.size.height * 0.5 + marginBar;
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(canX, canY, canW, canH)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [topSearch addSubview:cancel];
    
    //搜索图标
    UIView *leftView = [[UIView alloc] init];
    leftView.contentMode = UIViewContentModeCenter;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_search"]];
    CGFloat sIconW = rect.size.height - marginBar * 2;
    searchIcon.frame = CGRectMake(marginBar, 0, sIconW, sIconW);
    CGFloat lviewW = 10 + searchIcon.frame.size.width;
    leftView.frame = CGRectMake(0, 0, lviewW, sIconW);
    [leftView addSubview:searchIcon];
    searchBar.leftView = leftView;
    
    [searchBar becomeFirstResponder];
    [searchBar setEnablesReturnKeyAutomatically:YES];
    [searchBar setReturnKeyType:UIReturnKeySearch];
    [self.view setBackgroundColor:ZRColor(234.0f, 235.0f, 237.0f)];
}
- (void)cancelSearch
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - 2.载入数据
- (void)loadTableData
{
    [self searchHitsTable];
}

//UITableView的创建
- (UITableView *)searchHitsTable
{
    if(!_searchHitsTable){
        CGRect rect = self.view.frame;
        rect.origin.y = HomeScrollViewTopHeight + 1;
        rect.size.height = rect.size.height - HomeScrollViewTopHeight * 1.5;
        _searchHitsTable = [[UITableView alloc] initWithFrame:rect];
        _searchHitsTable.delegate = self;
        _searchHitsTable.dataSource = self;
        _searchHitsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchHitsTable setBackgroundColor:ZRColor(234.0f, 235.0f, 237.0f)]; 
        [self.view addSubview:_searchHitsTable];
    }
    return _searchHitsTable;
}

//搜索历史记录查询
- (NSArray *)arrayData
{
    if(!_arrayData){
        _arrayData = [[[ZRHistoryPage alloc] init] query];
    }
    return _arrayData;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.arrayData objectAtIndex:indexPath.row];
    
    NSString *ID = @"static_searchhits_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = dic[@"url"];
    
    CGFloat x = 15;
    CGFloat h = 1;
    CGFloat y = cell.frame.size.height - h;
    CGFloat w = self.searchHitsTable.frame.size.width - x * 2;
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(x,y,w,h)];
    [bottomLine setBackgroundColor:ZRColor(234.0f, 235.0f, 237.0f)];
    [cell addSubview:bottomLine];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.arrayData objectAtIndex:indexPath.row];
    [ZRWebViewController showWithContro:self withUrlStr:dic[@"url"] withTitle:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([self.searchInput resignFirstResponder])
       [self.searchInput resignFirstResponder];
}

#pragma mark - 3.清除历史记录
- (void)clearHistory
{
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat w = 100;
    CGFloat h = 30;
    CGFloat x = (self.view.frame.size.width - w ) / 2;
    CGFloat y = self.view.frame.size.height - h ;
    clearBtn.frame = CGRectMake(x, y, w, h);
    clearBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clearHistoryData) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clearHistoryData
{
    [[[ZRHistoryPage alloc] init] clearAllHistory];
    ZRAlertController *alert = [ZRAlertController defaultAlert];
    [alert alertShowWithTitle:@"提示" message:@"全部清除成功！" okayButton:@"好的" completion:^{
        self.arrayData = nil;
        [self.searchHitsTable reloadData];
    }];
}

#pragma mark - UITextField代理事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *content = textField.text;
    if([ZRRegularExpression isURL:content]){
        content = [NSString stringWithFormat:@"http://%@", content];
        [ZRWebViewController showWithContro:self withUrlStr:content withTitle:nil];
    }else{
        NSMutableString *mstr = [[NSMutableString alloc] init];
        [mstr appendString:@"http://m.baidu.com/s?word="];
        [mstr appendString:content]; 
        [ZRWebViewController showWithContro:self withUrlStr:mstr withTitle:nil];
    }
    
    return YES;
}
@end
