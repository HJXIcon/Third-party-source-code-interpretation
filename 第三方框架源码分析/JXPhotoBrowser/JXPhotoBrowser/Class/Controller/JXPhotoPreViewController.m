//
//  JXPhotoPreViewController.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoPreViewController.h"
#import "JXPhotoPreviewCell.h"
#import "UIView+JXExtension.h"
#import "JXPhotoBrowserConst.h"
#import "JXPhotoModel.h"

@interface JXPhotoPreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <JXPhotoModel *>* photos;
@end

@implementation JXPhotoPreViewController
#pragma mark - *** lazy load
- (NSMutableArray<JXPhotoModel *> *)photos{
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
    
        // 创建流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = PYPreviewPhotoSpacing;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JXPhotoPreviewCell class] forCellWithReuseIdentifier:NSStringFromClass([JXPhotoPreviewCell class])];
        _collectionView.pagingEnabled = YES;
        
        
        // 增加collectionView的宽度，使cell铺满屏幕
        CGFloat lineSpacing = layout.minimumLineSpacing;
        self.collectionView.jx_width += lineSpacing;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, lineSpacing);
        
        // 取消水平滚动条
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

#pragma mark - *** Cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view addSubview:self.collectionView];
}

#pragma mark - *** setter
- (void)setOriginal_pics:(NSArray<NSString *> *)original_pics{
    _original_pics = original_pics;
    [self _setupPhotos];
}

- (void)setThumbnail_pics:(NSArray<NSString *> *)thumbnail_pics{
    _thumbnail_pics = thumbnail_pics;
    [self _setupPhotos];
}

#pragma mark - *** Private Method
- (void)_setupPhotos{
    
    NSInteger max = self.original_pics.count > self.thumbnail_pics.count ? self.original_pics.count : self.thumbnail_pics.count;
    
    for (NSInteger i = 0; i < max; i ++) {
        JXPhotoModel *model = [[JXPhotoModel alloc]init];
        model.original_pic = i < self.original_pics.count ? self.original_pics[i] : nil;
        model.thumbnail_pic = i < self.thumbnail_pics.count ? self.thumbnail_pics[i] : nil;
        model.bigImage = YES;
        [self.photos addObject:model];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JXPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JXPhotoPreviewCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    cell.photoModel = self.photos[indexPath.row];
    return cell;
}

// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CGFloat itemHeight = PYVertical ? JXScreenW : JXScreenH;
    self.collectionView.jx_height = itemHeight;
    return CGSizeMake(collectionView.jx_width - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumLineSpacing, itemHeight);
   
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
