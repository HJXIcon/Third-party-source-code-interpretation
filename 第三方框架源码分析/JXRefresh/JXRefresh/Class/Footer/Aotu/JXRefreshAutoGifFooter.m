//
//  JXRefreshAutoGifFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshAutoGifFooter.h"
#import "UIView+JXExtension.h"
#import "JXRefreshConst.h"

@interface JXRefreshAutoGifFooter()
{
    __unsafe_unretained UIImageView *_gifView;
}
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@end
@implementation JXRefreshAutoGifFooter
#pragma mark - *** lazy load
- (UIImageView *)gifView{
    if (_gifView == nil) {
        UIImageView *gifView = [[UIImageView alloc]init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages{
    if (_stateImages == nil) {
        _stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations{
    if (_stateDurations == nil) {
        _stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - *** Public Method
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


#pragma mark - *** Override Method
- (void)prepare{
    [super prepare];
    // 初始化间距
    self.labelLeftInset = 20;
    
}

- (void)placeSubviews{
    [super placeSubviews];
    if (self.gifView.constraints.count) return;
    self.gifView.backgroundColor = [UIColor redColor];
    // 约束
    [self addGifViewConstraints:self.isRefreshingTitleHidden];
}


- (void)setState:(JXRefreshState)state{
    JXRefreshCheckState
    
    // 根据状态做事情
    if (state == JXRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        [self.gifView stopAnimating];
        
        self.gifView.hidden = NO;
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == JXRefreshStateNoMoreData || state == JXRefreshStateIdle) {
        [self.gifView stopAnimating];
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
