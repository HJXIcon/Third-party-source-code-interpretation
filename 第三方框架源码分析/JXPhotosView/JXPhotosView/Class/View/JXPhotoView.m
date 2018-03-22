//
//  JXPhotoView.m
//  JXPhotosView
//
//  Created by HJXICon on 2018/3/20.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoView.h"
#import "JXProgressView.h"
#import "JXPhoto.h"
#if __has_include(<SDWebImage/UIImageView+WebCache>)
#import <SDWebImage/UIImageView+WebCache>
#else
#import "UIImageView+WebCache.h"
#endif

// browser背景颜色
#define SDPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]


@implementation JXPhotoView{
    __weak JXProgressView *_progressView;
    BOOL _didCheckSize;
    UIScrollView *_scroll;
    UIImageView *_scrollImageView;
    UIScrollView *_zoomingScroolView;
    UIImageView *_zoomingImageView;
    CGFloat _totalScale;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupConig];
    }
    return self;
}

- (void)_setupConig{
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeScaleAspectFit;
    _totalScale = 1.0;
    
    // 捏合手势缩放图片
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
    pinch.delegate = self;
    [self addGestureRecognizer:pinch];
}




- (void)layoutSubviews{
    [super layoutSubviews];
    _progressView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGSize imageSize = self.image.size;
    
    // 图片高度大于屏幕的时候
    if (CGRectGetWidth(self.bounds) * (imageSize.height / imageSize.width) > CGRectGetHeight(self.bounds)) {
        if (!_scroll) {
            UIScrollView *scroll = [[UIScrollView alloc]init];
            scroll.backgroundColor = [UIColor whiteColor];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = self.image;
            _scrollImageView = imageView;
            [scroll addSubview:imageView];
            scroll.backgroundColor = SDPhotoBrowserBackgrounColor;
            _scroll = scroll;
            [self addSubview:scroll];
        }
        _scroll.frame = self.bounds;
        CGFloat imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        _scrollImageView.bounds = CGRectMake(0, 0, _scroll.frame.size.width, imageViewH);
        _scrollImageView.center = CGPointMake(_scroll.frame.size.width * 0.5, _scrollImageView.frame.size.height * 0.5);
        _scroll.contentSize = CGSizeMake(0, _scrollImageView.bounds.size.height);
    }else {
        if (_scroll) [_scroll removeFromSuperview]; // 防止旋转时适配的scrollView的影响
    }
}


#pragma mark - *** getter
- (BOOL)isScaled{
    return  1.0 != _totalScale;
}

#pragma mark - *** setter
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _progressView.progress = progress;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    
    JXProgressView *progressView = [[JXProgressView alloc] init];
    progressView.bounds = CGRectMake(0, 0, 80, 80);
    _progressView = progressView;
    [self addSubview:progressView];
    
    __weak typeof(self) weakSelf = self;
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakSelf.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf _removeProgressView];
        
        if (error) {
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(weakSelf.bounds.size.width * 0.5, weakSelf.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [weakSelf addSubview:label];
        } else {
            _scrollImageView.image = image;
            [_scrollImageView setNeedsDisplay];
        }
        
    }];
}


#pragma mark - *** Actions
- (void)zoomImage:(UIPinchGestureRecognizer *)recognizer{
    [self _prepareForImageViewScaling];
    CGFloat scale = recognizer.scale;
    CGFloat temp = _totalScale + (scale - 1);
    [self _setTotalScale:temp];
    recognizer.scale = 1.0;
}


- (void)_removeProgressView{
    [_progressView removeFromSuperview];
}

- (void)_prepareForImageViewScaling{
    if (!_zoomingScroolView) {
        _zoomingScroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _zoomingScroolView.backgroundColor = SDPhotoBrowserBackgrounColor;
        _zoomingScroolView.contentSize = self.bounds.size;
        UIImageView *zoomingImageView = [[UIImageView alloc] initWithImage:self.image];
        CGSize imageSize = zoomingImageView.image.size;
        CGFloat imageViewH = self.bounds.size.height;
        if (imageSize.width > 0) {
            imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        }
        zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
        zoomingImageView.center = _zoomingScroolView.center;
        zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        _zoomingImageView = zoomingImageView;
        [_zoomingScroolView addSubview:zoomingImageView];
        [self addSubview:_zoomingScroolView];
    }
}


- (void)_scaleImage:(CGFloat)scale{
    [self _prepareForImageViewScaling];
    [self _setTotalScale:scale];
}

- (void)_setTotalScale:(CGFloat)totalScale{
    if ((_totalScale < 0.5 && totalScale < _totalScale) || (_totalScale > 2.0 && totalScale > _totalScale)) return; // 最大缩放 2倍,最小0.5倍
    
    [self _zoomWithScale:totalScale];
}

- (void)_zoomWithScale:(CGFloat)scale{
    _totalScale = scale;
    
    _zoomingImageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    if (scale > 1) {
        CGFloat contentW = _zoomingImageView.frame.size.width;
        CGFloat contentH = MAX(_zoomingImageView.frame.size.height, self.frame.size.height);
        
        _zoomingImageView.center = CGPointMake(contentW * 0.5, contentH * 0.5);
        _zoomingScroolView.contentSize = CGSizeMake(contentW, contentH);
        
        
        CGPoint offset = _zoomingScroolView.contentOffset;
        offset.x = (contentW - _zoomingScroolView.frame.size.width) * 0.5;
        _zoomingScroolView.contentOffset = offset;
        
    } else {
        _zoomingScroolView.contentSize = _zoomingScroolView.frame.size;
        _zoomingScroolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _zoomingImageView.center = _zoomingScroolView.center;
    }
}
#pragma mark - *** Public Method
// 清除缩放
- (void)eliminateScale
{
    [self clear];
    _totalScale = 1.0;
}

- (void)clear{
    [_zoomingScroolView removeFromSuperview];
    _zoomingScroolView = nil;
    _zoomingImageView = nil;
    
}

- (void)doubleTapToZommWithScale:(CGFloat)scale{
    [self _prepareForImageViewScaling];
    [UIView animateWithDuration:0.5 animations:^{
        [self _zoomWithScale:scale];
    } completion:^(BOOL finished) {
        if (scale == 1) {
            [self clear];
        }
    }];
}
@end









