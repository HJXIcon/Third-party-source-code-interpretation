//
//  JXPhotoBrowser.m
//  JXPhotosView
//
//  Created by HJXICon on 2018/3/20.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoBrowser.h"
#import "JXPhotoView.h"

// 图片保存成功提示文字
#define JXPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define JXPhotoBrowserSaveImageFailText @" >_< 保存失败 ";

// browser背景颜色
#define JXPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define JXPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define JXPhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define JXPhotoBrowserHideImageAnimationDuration 0.4f
@implementation JXPhotoBrowser
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JXPhotoBrowserBackgrounColor;
    }
    return self;
}

- (void)didMoveToSuperview{
    [self _setupScrollView];
    [self _setupToolbars];
}

- (void)dealloc{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += JXPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - JXPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(JXPhotoView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = JXPhotoBrowserImageViewMargin + idx * (JXPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self _showFirstImage];
    }
    
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 35);
}

- (void)_setupScrollView{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        JXPhotoView *imageView = [[JXPhotoView alloc] init];
        imageView.tag = i;
        
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        // 长按
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesAction:)];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [imageView addGestureRecognizer:longGes];
        [_scrollView addSubview:imageView];
    }
    
    // 加载图片
    [self _setupImageOfImageViewForIndex:self.currentImageIndex];
    
}



- (void)_setupToolbars{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
}

// 加载图片
- (void)_setupImageOfImageViewForIndex:(NSInteger)index
{
    JXPhotoView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([self _highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self _highQualityImageURLForIndex:index] placeholderImage:[self _placeholderImageForIndex:index]];
    } else {
        imageView.image = [self _placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}


- (UIImage *)_placeholderImageForIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)_highQualityImageURLForIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

- (void)_showFirstImage{
    UIView *sourceView = nil;
    
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    }
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self _placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:JXPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

#pragma mark - *** Actions
- (void)longGesAction:(UILongPressGestureRecognizer *)recognizer{
    UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    [alterC addAction:[UIAlertAction actionWithTitle:@"save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf saveImage];
    }]];
    
    [alterC addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alterC animated:YES completion:nil];
}

- (void)saveImage{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = JXPhotoBrowserSaveImageFailText;
    }   else {
        label.text = JXPhotoBrowserSaveImageSuccessText;
    }
    // 异步执行
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer{
    _scrollView.hidden = YES;
    _willDisappear = YES;
    
    JXPhotoView *currentImageView = (JXPhotoView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = nil;
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        NSIndexPath *path = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    }
    
    
    
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    
    [UIView animateWithDuration:JXPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        _indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer{
    JXPhotoView *imageView = (JXPhotoView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    
    JXPhotoView *view = (JXPhotoView *)recognizer.view;
    
    [view doubleTapToZommWithScale:scale];
}

#pragma mark - *** scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        JXPhotoView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    
    if (!_willDisappear) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self _setupImageOfImageViewForIndex:index];
}

#pragma mark - *** Public Method
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

#pragma mark - *** KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        JXPhotoView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[JXPhotoView class]]) {
            [currentImageView clear];
        }
    }
}
@end
