//
//  JXPhotoPreviewCell.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoPreviewCell.h"
#import "JXPhotoBrowserConst.h"
#import "JXPhotoModel.h"
#import "JXPhotoPreView.h"
#import "UIView+JXExtension.h"

@interface JXPhotoPreviewCell()
@property (nonatomic, assign) CGPoint scrollViewAnchorPoint;
@property (nonatomic, assign) CGPoint preViewCellAnchorPoint;

@property (nonatomic, assign, getter=isDoubleTap) BOOL doubleTap;
@end

@implementation JXPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [_photoPreView removeProgressView];
    self.doubleTap = NO;
    [self _clearZoom];
}

- (void)_setupUI{
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, JXScreenW, JXScreenH)];
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView = contentScrollView;
    self.contentScrollView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:contentScrollView];
    
    JXPhotoPreView *imageView = [[JXPhotoPreView alloc] init];
    _photoPreView = imageView;
    [self.contentScrollView addSubview:imageView];
}

#pragma mark - *** Private Method
- (void)_setupConfig{
    // 设置原始锚点
    self.scrollViewAnchorPoint = self.layer.anchorPoint;
    // 默认放大倍数和旋转角度
    self.scale = 2.0;
}

- (void)_addGestureRecognizers{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    // 双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
    
    // 长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    
    // 捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinch];
    
    // 旋转手势
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
    [self addGestureRecognizer:rotation];
    
    
}

/** 根据手势触摸点修改相应的锚点，就是沿着触摸点做相应的手势操作 */
- (CGPoint)_setAnchorPointBaseOnGestureRecognizer:(UIGestureRecognizer *)gr
{
    // 手势为空 直接返回
    if (!gr) return CGPointMake(0.5, 0.5);
    
    // 创建锚点
    CGPoint anchorPoint; // scrollView的虚拟锚点
    CGPoint cellAnchorPoint; // photoCell的虚拟锚点
    UIScrollView *scrollView = (UIScrollView *)[self superview];
    if ([gr isKindOfClass:[UIPinchGestureRecognizer class]]) { // 捏合手势
        {
            // 当触摸开始时，获取两个触摸点
            // 获取滚动视图上的触摸点
            CGPoint point1 = [gr locationOfTouch:0 inView:scrollView];
            CGPoint point2 = [gr locationOfTouch:1 inView:scrollView];
            anchorPoint.x = (point1.x + point2.x) / 2.0 / scrollView.contentSize.width;
            anchorPoint.y = (point1.y + point2.y) / 2.0 / scrollView.contentSize.height;
            // 获取cell上的触摸点
            CGPoint screenPoint1 = [gr locationOfTouch:0 inView:gr.view];
            CGPoint screenPoint2 = [gr locationOfTouch:1 inView:gr.view];
            cellAnchorPoint.x = (screenPoint1.x + screenPoint2.x) / 2.0 / gr.view.jx_width;
            cellAnchorPoint.y = (screenPoint1.y + screenPoint2.y) / 2.0 / gr.view.jx_height;
        }
    } else { // 点击手势
        // 获取scrollView触摸点
        CGPoint scrollViewPoint = [gr locationOfTouch:0 inView:scrollView];
        anchorPoint.x = scrollViewPoint.x / scrollView.contentSize.width;
        anchorPoint.y = scrollViewPoint.y / scrollView.contentSize.height;
        // 获取cell上的触摸点
        CGPoint photoCellPoint = [gr locationOfTouch:0 inView:gr.view];
        cellAnchorPoint.x = photoCellPoint.x / gr.view.jx_width;
        cellAnchorPoint.y = photoCellPoint.y / gr.view.jx_height;
    }
    self.preViewCellAnchorPoint = cellAnchorPoint;
    return anchorPoint;
}


#pragma mark - *** Actions
- (void)tapAction:(UITapGestureRecognizer *)ges{
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:JXHidePhotoBrowserNoti object:nil];
}
- (void)doubleTapAction:(UITapGestureRecognizer *)ges{
    // 设置锚点
    self.scrollViewAnchorPoint = [self _setAnchorPointBaseOnGestureRecognizer:ges];
    
    [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (self.isDoubleTap) {
            [self _zoomWithScale:1];
        }else{
            [self _zoomWithScale:2];
        }
        
    } completion:^(BOOL finished) {
        self.doubleTap = !self.isDoubleTap;
    }];
    
}
- (void)longPressAction:(UILongPressGestureRecognizer *)ges{
    
}
- (void)pinchAction:(UIPinchGestureRecognizer *)ges{
    
}
- (void)rotationAction:(UIRotationGestureRecognizer *)ges{
    
}


#pragma mark - *** setter
- (void)setPhotoModel:(JXPhotoModel *)photoModel{
    _photoModel = photoModel;
    __weak typeof(self) weakSelf = self;
    [self _adjustSize:photoModel.highImage ? photoModel.highImage : photoModel.placeholderImage];
    [_photoPreView setImageWithURL:photoModel.highImageURL placeholderImage:photoModel.placeholderImage completed:^(UIImage *image) {
        [weakSelf _adjustSize:image];
        [weakSelf _addGestureRecognizers];
    }];
}


- (void)_adjustSize:(UIImage *)image{
    CGFloat height = JXPreviewCellW * image.size.height / image.size.width;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    if (height > JXPreviewCellH) { // 长图
        self.photoPreView.jx_size = CGSizeMake(JXPreviewCellW, JXPreviewCellW * image.size.height / image.size.width);
        
    }else{
        if (image.size.width > JXPreviewCellW) {//超过cellW
            self.photoPreView.jx_size = CGSizeMake(JXPreviewCellW,JXPreviewCellW * image.size.height / image.size.width);
            
        }else{
            self.photoPreView.jx_size = image.size;
        }
    }
    
    self.contentScrollView.contentSize = self.photoPreView.jx_size;
    self.photoPreView.center = self.contentScrollView.center;
    
    // 刷新
    [self setNeedsLayout];
}

- (void)_zoomWithScale:(CGFloat)scale{
    
    if (scale > 1) {
        self.photoPreView.transform = CGAffineTransformScale(self.photoPreView.transform, scale, scale);
        CGFloat contentW = self.photoPreView.frame.size.width;
        CGFloat contentH = MAX(self.photoPreView.frame.size.height, self.frame.size.height);
        
        self.photoPreView.center = CGPointMake(contentW * 0.5, contentH * 0.5);
        self.contentScrollView.contentSize = CGSizeMake(contentW, contentH);
        
        CGPoint offset = self.contentScrollView.contentOffset;
        offset.x = (contentW - self.contentScrollView.frame.size.width) * 0.5;
        self.contentScrollView.contentOffset = offset;
        
    } else {
        [self _clearZoom];
    }
    
}

- (void)_clearZoom{
    self.photoPreView.transform = CGAffineTransformIdentity;
    self.contentScrollView.contentSize = self.contentScrollView.frame.size;
    self.contentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.photoPreView.center = self.contentScrollView.center;
}

@end
