//
//  JXPhotoPreviewCell.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  CoJXright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoPreviewCell.h"
#import "JXPhotoBrowserConst.h"
#import "JXPhotoModel.h"
#import "JXPhotoPreView.h"
#import "UIView+JXExtension.h"

@interface JXPhotoPreviewCell()
@property (nonatomic, assign) CGPoint scrollViewAnchorPoint;
@property (nonatomic, assign) CGPoint preViewCellAnchorPoint;//cell上的触摸点

@property (nonatomic, assign, getter=isDoubleTap) BOOL doubleTap;
/** 手势状态 */
@property (nonatomic, assign) UIGestureRecognizerState state;
@property (nonatomic, assign, getter=isRotationGesture) BOOL rotationGesture;
@end

@implementation JXPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
        [self _setupConfig];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [_photoPreView removeProgressView];
    
    self.doubleTap = NO;
    self.photoPreView.transform = CGAffineTransformIdentity;
}


- (void)dealloc{
    [self removeObserver:self.photoPreView forKeyPath:@"transform"];
}
#pragma mark - *** Private Method
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

- (void)_setupConfig{
    // 设置原始锚点
    self.scrollViewAnchorPoint = self.layer.anchorPoint;
    // 默认放大倍数和旋转角度
    self.scale = 2.0;
    [self.photoPreView addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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

// scrollView的虚拟锚点
/** 根据手势触摸点修改相应的锚点，就是沿着触摸点做相应的手势操作 */
- (CGPoint)_setAnchorPointBaseOnGestureRecognizer:(UIGestureRecognizer *)gr
{
    // 手势为空 直接返回
    if (!gr) return CGPointMake(0.5, 0.5);
    
    // 创建锚点
    CGPoint anchorPoint; // scrollView的虚拟锚点
    CGPoint cellAnchorPoint; // photoCell的虚拟锚点
    UIScrollView *scrollView = self.contentScrollView;
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
            self.photoPreView.transform = CGAffineTransformScale(self.photoPreView.transform, self.scale, self.scale);
        }else{
            self.photoPreView.transform = CGAffineTransformIdentity;
        }
        
    } completion:^(BOOL finished) {
        self.doubleTap = !self.isDoubleTap;
    }];
    
}
- (void)longPressAction:(UILongPressGestureRecognizer *)ges{
    
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch{
    
    
    if (pinch.numberOfTouches < 2) { // 只有一只手指，取消手势
        [pinch setCancelsTouchesInView:YES];
        [pinch setValue:@(UIGestureRecognizerStateEnded) forKeyPath:@"state"];
    }
    
    
    if (pinch.state == UIGestureRecognizerStateChanged) {
        // 1.获取锚点
        self.scrollViewAnchorPoint = [self _setAnchorPointBaseOnGestureRecognizer:pinch];
        
        // 2.当对图片放大到最大最次放大时，缩放因子就会变小
        CGFloat scaleFactor = 1.0;
        if (self.photoPreView.jx_width > JXPreviewCellW * JXPreviewPhotoMaxScale && pinch.scale > 1.0) {
            scaleFactor =  (1 + 0.01 * pinch.scale) /  pinch.scale;
        }
        // 3.记录手势
        self.state = pinch.state;
        self.rotationGesture = NO;
        self.photoPreView.transform = CGAffineTransformScale(self.photoPreView.transform, pinch.scale * scaleFactor, pinch.scale * scaleFactor);
        
        // 4.复位
        pinch.scale = 1;
    }
    
    if (pinch.state == UIGestureRecognizerStateEnded
        || pinch.state == UIGestureRecognizerStateFailed
        || pinch.state == UIGestureRecognizerStateCancelled) { // 手势结束\取消\失败
        
        // 判断是否缩小
        CGFloat scale = 1;
       
        // 复位
        [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.photoPreView.transform = CGAffineTransformScale(self.photoPreView.transform, scale, scale);
        } completion:^(BOOL finished) {
            
        }];
        
        
        
    }
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
    
    self.photoPreView.jx_size = CGSizeMake(JXPreviewCellW,height);
    self.contentScrollView.jx_size = self.photoPreView.jx_size;
    
    if (self.photoPreView.jx_size.height > JXPreviewCellH) { // 长图
        self.contentScrollView.jx_height = JXPreviewCellH;
    }
    if (self.photoPreView.jx_size.width > JXPreviewCellW) {//超过cellW
        self.contentScrollView.jx_width = JXPreviewCellW;
    }
    
    self.contentScrollView.center = self.contentView.center;
    self.photoPreView.jx_origin = CGPointZero;
    self.contentScrollView.contentSize = self.photoPreView.jx_size;
   
    // 刷新
    [self setNeedsLayout];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self _changePhotoViewTransformAction];
}

- (void)_changePhotoViewTransformAction{
    
    // 如果手势没结束、没有放大、旋转手势，返回
    if (self.isRotationGesture) return;
    
    // 调整scrollView
    // 恢复photoView的x/y位置
    self.photoPreView.jx_origin = CGPointZero;
    
    // 修改contentScrollView的属性
    UIScrollView *contentScrollView = self.contentScrollView;
    contentScrollView.jx_height = self.photoPreView.jx_height < JXPreviewCellH ? self.photoPreView.jx_height : JXPreviewCellH;
    contentScrollView.jx_width = self.photoPreView.jx_width < JXPreviewCellW ? self.photoPreView.jx_width : JXPreviewCellW;
    
    contentScrollView.contentSize = self.photoPreView.jx_size;
    
    // 根据模拟锚点调整偏移量
    CGFloat offsetX = contentScrollView.contentSize.width * self.scrollViewAnchorPoint.x - contentScrollView.jx_width * self.preViewCellAnchorPoint.x;
    CGFloat offsetY = contentScrollView.contentSize.height * self.scrollViewAnchorPoint.y - contentScrollView.jx_height * self.preViewCellAnchorPoint.y;
    
    if (ABS(offsetX) + contentScrollView.jx_width > contentScrollView.contentSize.width) { // 偏移量超出范围
        offsetX = offsetX > 0 ? contentScrollView.contentSize.width - contentScrollView.jx_width : contentScrollView.jx_width - contentScrollView.contentSize.width;
    }
    if (ABS(offsetY) + contentScrollView.jx_height > contentScrollView.contentSize.height) {  // 偏移量超出范围
        offsetY = offsetY > 0 ? contentScrollView.contentSize.height - contentScrollView.jx_height :
        contentScrollView.jx_height - contentScrollView.contentSize.height;
    }
    // 最后调整
    offsetX = offsetX < 0 ? 0 : offsetX;
    offsetY = offsetY < 0 ? 0 : offsetY;
    contentScrollView.contentOffset = CGPointMake(offsetX, offsetY);
    contentScrollView.center = CGPointMake(JXPreviewCellW * 0.5, JXPreviewCellH * 0.5);
}

@end
