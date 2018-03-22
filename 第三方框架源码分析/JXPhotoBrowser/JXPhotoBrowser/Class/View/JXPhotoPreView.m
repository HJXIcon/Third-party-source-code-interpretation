//
//  JXPhotoPreView.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/22.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoPreView.h"
#import "UIImageView+WebCache.h"
#import "JXPhotoModel.h"
#import "UIView+JXExtension.h"
#import "JXPhotoBrowserConst.h"
#import "JXPhotoPreviewCell.h"


@interface JXPhotoPreView()

/** contentScrollView的模拟锚点 */
@property (nonatomic, assign) CGPoint scrollViewAnchorPoint;
/** PYPhotoCell的模拟锚点 */
@property (nonatomic, assign) CGPoint preViewCellAnchorPoint;
@end
@implementation JXPhotoPreView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupConfig];
    }
    return self;
}
#pragma mark - *** setter
- (void)setPhoto:(JXPhotoModel *)photo{
    _photo = photo;
    
    NSURL *url = [NSURL URLWithString:photo.isBigImage ? photo.original_pic : photo.thumbnail_pic];

    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:self.placeholderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [weakSelf _dealPhotos:image];
        [weakSelf _addGestureRecognizers];
    }];
    
    
}

#pragma mark - *** Private Method
- (void)_setupConfig{
    // 设置原始锚点
    self.scrollViewAnchorPoint = self.layer.anchorPoint;
    // 默认放大倍数和旋转角度
    self.scale = 1.0;
}
- (void)_dealPhotos:(UIImage *)image{
    if (self.photo.isBigImage) {
        self.photo.original_image = image;
    }else{
        self.photo.thumbnail_image = image;
    }
    self.image = image;
}

- (void)_addGestureRecognizers{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.previewCell addGestureRecognizer:tap];
    
    // 双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.previewCell addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
    
    // 长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.previewCell addGestureRecognizer:longPress];
    
    // 捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self.previewCell addGestureRecognizer:pinch];
    
    // 旋转手势
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
    [self.previewCell addGestureRecognizer:rotation];
    
    
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
    
}
- (void)doubleTapAction:(UITapGestureRecognizer *)ges{
    
}
- (void)longPressAction:(UILongPressGestureRecognizer *)ges{
    
}
- (void)pinchAction:(UIPinchGestureRecognizer *)ges{
    
}
- (void)rotationAction:(UIRotationGestureRecognizer *)ges{
    
}
#pragma mark - *** Overried Method
- (void)setImage:(UIImage *)image{
    [super setImage:image];
    
    if (!image) return;
    CGFloat height = JXPreviewCellW * image.size.height / image.size.width;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    if (height > JXPreviewCellH) { // 长图
        self.jx_size = CGSizeMake(JXPreviewCellW, JXPreviewCellW * image.size.height / image.size.width);
        
    }else{
        if (image.size.width > JXPreviewCellW) {//超过cellW
            self.jx_size = CGSizeMake(JXPreviewCellW,JXPreviewCellW * image.size.height / image.size.width);
            
        }else{
             self.jx_size = image.size;
        }
    }
    
    // 设置scrollView的大小
    self.previewCell.contentScrollView.jx_height = self.jx_height < JXPreviewCellH ? self.jx_height : JXPreviewCellH;
    self.previewCell.contentScrollView.jx_width = self.jx_width < JXPreviewCellW ? self.jx_width : JXPreviewCellW;
    self.previewCell.contentScrollView.center = CGPointMake(JXPreviewCellW * 0.5, JXPreviewCellH * 0.5);
    self.previewCell.contentScrollView.contentSize = self.jx_size;
    
    // 刷新
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
