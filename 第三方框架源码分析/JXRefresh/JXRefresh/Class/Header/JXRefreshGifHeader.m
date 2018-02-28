//
//  JXRefreshGifHeader.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshGifHeader.h"
#import "UIView+JXExtension.h"
#import "JXRefreshConst.h"

@interface JXRefreshGifHeader(){
    __unsafe_unretained UIImageView *_gifImageView;
}
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@end
@implementation JXRefreshGifHeader
#pragma mark - lazy load
- (UIImageView *)gifImageView
{
    if (_gifImageView == nil) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifImageView = gifView];
    }
    return _gifImageView;
}

- (NSMutableDictionary *)stateImages
{
    if (_stateImages == nil) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (_stateDurations == nil) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}
#pragma mark - *** Override Method
- (void)prepare{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = 20;
}

- (void)placeSubviews{
    [super placeSubviews];
    
    if(CGSizeEqualToSize(self.gifImageViewSize, CGSizeZero)) self.gifImageViewSize = CGSizeMake(JXRefreshHeaderHeight, JXRefreshHeaderHeight);
    if (self.gifImageViewSize.height > self.jx_height) {
        CGSize cmpSize = self.gifImageViewSize;
        cmpSize.height = self.jx_height;
        self.gifImageViewSize = cmpSize;
    }
    
    if (self.gifImageView.constraints.count) return;
    
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifImageView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifImageView.contentMode = UIViewContentModeRight;
    }
    self.gifImageView.backgroundColor = [UIColor redColor];
    [self addGifConstraints];
}


- (void)addGifConstraints{
    /// gifImageView
    self.gifImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *stateLabel = self.stateLabel;
    NSDictionary *views = NSDictionaryOfVariableBindings(_gifImageView,stateLabel);
    NSDictionary *metrics = @{
                              @"width":@(self.gifImageViewSize.width),
                              @"height":@(self.gifImageViewSize.height),
                              @"margin":@(self.labelLeftInset)
                              
                              };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_gifImageView(width)]-margin-[stateLabel]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_gifImageView(height)]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_gifImageView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
}

#pragma mark - *** setter
- (void)setGifImageViewSize:(CGSize)gifImageViewSize{
    _gifImageViewSize = gifImageViewSize;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}
- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    // 根据状态做事情
    if (state == JXRefreshStatePulling || state == JXRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifImageView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifImageView.image = [images lastObject];
        } else { // 多张图片
            self.gifImageView.animationImages = images;
            self.gifImageView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifImageView startAnimating];
        }
    } else if (state == JXRefreshStateIdle) {
        [self.gifImageView stopAnimating];
    }
}


- (void)setPullingPercent:(CGFloat)pullingPercent{
    
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(JXRefreshStateIdle)];
    if (self.state != JXRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifImageView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifImageView.image = images[index];
}


#pragma mark - *** Public Method
/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images
         duration:(NSTimeInterval)duration
         forState:(JXRefreshState)state{
    
    if (images == nil) return;
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    
}
- (void)setImages:(NSArray *)images
         forState:(JXRefreshState)state{
    
    [self setImages:images duration:images.count * 0.1 forState:state];
}



@end
