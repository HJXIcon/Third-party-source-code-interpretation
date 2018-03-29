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
#import "JXPhotoPreView.h"
#import "JXPhotoBrowser.h"
#import "JXProgressView.h"

@interface JXPhotoPreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <JXPhotoModel *>* photos;

@property (nonatomic, weak) JXPhotoPreView *maskPreView;
@property (nonatomic, weak) UIView *sourceImageContainerView;


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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showImageOriginFrameAction:) name:JXShowPhotoBrowserOriginFrameNoti object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNotiAcion) name:JXHidePhotoBrowserNoti object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view addSubview:self.collectionView];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:JXShowPhotoBrowserOriginFrameNoti object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:JXHidePhotoBrowserNoti object:nil];
}

- (void)showImageOriginFrameAction:(NSNotification *)noti{
    
    self.collectionView.alpha = 0;
    UIView *sourceImageContainerView = noti.object;
    self.sourceImageContainerView = sourceImageContainerView;
    JXPhotoPreView *preView = [[JXPhotoPreView alloc]init];
    
    JXPhotoModel *photo = self.photos[self.currentImageIndex];
    UIImage *preImage = photo.highImage ? photo.highImage : self.placeholderImages[self.currentImageIndex];
    preView.image = preImage;
    
    // 转移坐标
    preView.frame = [sourceImageContainerView.superview  convertRect:sourceImageContainerView.frame toView:self.photoBrowser];
    
    [self.photoBrowser addSubview:preView];
    self.maskPreView = preView;
    
    [UIView animateWithDuration:JXPhotoBrowserAnimateDuration animations:^{
        // 放大图片
        preView.jx_width = self.collectionView.jx_width - ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).minimumLineSpacing;
        preView.jx_height = JXScreenW * preImage.size.height / preImage.size.width;
        preView.center = CGPointMake(JXScreenW * 0.5, JXScreenH * 0.5);
        
    } completion:^(BOOL finished) {
        preView.hidden = YES;
        self.collectionView.alpha = 1;
    }];
}



- (void)hideNotiAcion{
    JXPhotoPreView *coypPreView = self.maskPreView;
    coypPreView.hidden = NO;
    self.photoBrowser.backgroundColor = [UIColor clearColor];
    CGRect beginFrame = [self.photoBrowser convertRect:self.sourceImageContainerView.frame toView:[self.sourceImageContainerView superview]];
    
    [UIView animateWithDuration:JXPhotoBrowserAnimateDuration animations:^{
        self.collectionView.alpha = 0.0;
        // 恢复矩阵变换
        coypPreView.transform = CGAffineTransformIdentity;
        coypPreView.frame = beginFrame;
        
    }completion:^(BOOL finished) {
        [self.photoBrowser hide];
    }];
}

#pragma mark - *** setter
- (void)setHighQualityImages:(NSArray<NSURL *> *)highQualityImages{
    _highQualityImages = highQualityImages;
    [self _setupPhotos];
}

- (void)setPlaceholderImages:(NSArray<UIImage *> *)placeholderImages{
    _placeholderImages = placeholderImages;
    [self _setupPhotos];
}

- (void)setCurrentImageIndex:(NSInteger)currentImageIndex{
    _currentImageIndex = currentImageIndex;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentImageIndex inSection:0];
    //
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - *** Private Method
- (void)_setupPhotos{
    self.photos = nil;
    for (NSInteger i = 0; i < _placeholderImages.count; i ++) {
        JXPhotoModel *model = [[JXPhotoModel alloc]init];
        if (_highQualityImages.count) {
            model.highImageURL = i >_highQualityImages.count ? nil : _highQualityImages[i];
        }
        model.placeholderImage = _placeholderImages[i];
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
