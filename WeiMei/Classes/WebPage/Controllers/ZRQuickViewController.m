//
//  ZRQuickViewController.m
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 16/1/3.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//  快捷导航控制器

#import "ZRQuickViewController.h"
#import "ZRHomeQuickNavModel.h"
#import "ZRQuickButton.h"
#import "ZRWebViewController.h"

@interface ZRQuickViewController ()
//取单元格数据
@property (nonatomic,strong) NSArray *homeQuickNavModel;
@end

@implementation ZRQuickViewController

- (NSArray *)homeQuickNavModel
{
    if(!_homeQuickNavModel){
        _homeQuickNavModel = [ZRHomeQuickNavModel quickNavArray];
    }
    return _homeQuickNavModel;
}

static NSString * const reuseIdentifier = @"rectangleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.contentInset = UIEdgeInsetsMake(30,self.margin, 70, self.margin);
    self.collectionView.backgroundColor = MainColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.contentInset = UIEdgeInsetsMake(30,self.margin, 70, self.margin);
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.homeQuickNavModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ZRHomeQuickNavModel *model = [self.homeQuickNavModel objectAtIndex:indexPath.row];
    ZRQuickButton *quickBtn = [[ZRQuickButton alloc] initWithTitle:model.name imagePath:model.icon andFrame:cell.frame];
    quickBtn.viewFrame = self.view.frame;
    cell.backgroundView = quickBtn;
    return cell;
}

#pragma mark - <UICollectionViewDelegate>代理事件
#pragma mark UICollectionViewCell的选中时调用方式
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZRHomeQuickNavModel *model = [self.homeQuickNavModel objectAtIndex:indexPath.row];
    [ZRWebViewController showWithContro:self withUrlStr:model.url withTitle:model.name];
}

#pragma mark 返回UICollectionView是否可以被选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect rect = self.view.frame;
    if(rect.origin.y != HomeScrollViewTopHeight){
        rect.origin.y = HomeScrollViewTopHeight;
        [UIView animateWithDuration:-0.3f animations:^{
            self.view.frame = rect;
        }];
    }
}
@end
