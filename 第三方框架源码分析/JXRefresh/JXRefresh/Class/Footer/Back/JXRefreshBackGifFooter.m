//
//  JXRefreshBackGifFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshBackGifFooter.h"
#import "JXRefreshConst.h"
#import "UIView+JXExtension.h"

@interface JXRefreshBackGifFooter()
{
    __unsafe_unretained UIImageView *_gifView;
}
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@end

@implementation JXRefreshBackGifFooter

#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(JXRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
}

- (void)setImages:(NSArray *)images forState:(JXRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = 20;
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(JXRefreshStateIdle)];
    if (self.state != JXRefreshStateIdle || images.count == 0) return;
    [self.gifView stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    self.gifView.backgroundColor = [UIColor redColor];
    // 约束
    [self addGifViewConstraints:self.stateLabel.hidden];
}

- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    // 根据状态做事情
    if (state == JXRefreshStatePulling || state == JXRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        self.gifView.hidden = NO;
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == JXRefreshStateIdle) {
        self.gifView.hidden = NO;
    } else if (state == JXRefreshStateNoMoreData) {
        self.gifView.hidden = YES;
    }
}

#pragma mark - *** Private Method
- (void)addGifViewConstraints:(BOOL)isCenter{
    self.gifView.translatesAutoresizingMaskIntoConstraints = NO;
    if (CGSizeEqualToSize(CGSizeZero, self.gifViewSize)) {
        self.gifViewSize = CGSizeMake(self.jx_height, self.jx_height);
    }
    if(self.gifViewSize.height > self.jx_height){
        CGSize tmp = self.gifViewSize;
        tmp.height = self.jx_height;
        self.gifViewSize = tmp;
    }
    NSDictionary *metrics = @{
                              @"width":@(self.gifViewSize.width),
                              @"height":@(self.gifViewSize.height),
                              @"margin":@(self.labelLeftInset)
                              
                              };
    UILabel *stateLabel = self.stateLabel;
    NSDictionary *views = NSDictionaryOfVariableBindings(_gifView,stateLabel);
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_gifView(height)]" options:0 metrics:metrics views:views]];
    
    if (isCenter) {
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_gifView(width)]" options:0 metrics:metrics views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_gifView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    }
    else{
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_gifView(width)]-margin-[stateLabel]" options:0 metrics:metrics views:views]];
        
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_gifView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}
@end
