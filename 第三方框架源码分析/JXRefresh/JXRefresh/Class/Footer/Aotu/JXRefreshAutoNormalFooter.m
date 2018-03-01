//
//  JXRefreshAutoNomalFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshAutoNormalFooter.h"
#import "JXRefreshConst.h"
#import "UIView+JXExtension.h"

@interface JXRefreshAutoNormalFooter()
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation JXRefreshAutoNormalFooter
#pragma mark - *** lazy load
- (UIActivityIndicatorView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        _loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

#pragma mark - *** setter
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}


#pragma mark - *** Override Method
- (void)prepare{
    [super prepare];
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    // 圈圈
    [self addLoadingViewConstraint];
    
}

- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    // 根据状态做事情
    if (state == JXRefreshStateNoMoreData || state == JXRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == JXRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}


#pragma mark - *** Private Method
- (void)addLoadingViewConstraint{
    self.stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *stateLabel = self.stateLabel;
    UIActivityIndicatorView *loadingView = self.loadingView;
    NSDictionary *views = NSDictionaryOfVariableBindings(stateLabel,loadingView);
    NSDictionary *metrics = @{@"margin":@(self.labelLeftInset)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[loadingView]-margin-[stateLabel]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:loadingView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
}

@end
