//
//  JXRefreshNormalHeader.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshNormalHeader.h"
#import "JXRefreshConst.h"
#import "UIView+JXExtension.h"
#import "UIScrollView+JXExtension.h"
#import "NSBundle+JXRefresh.h"

@interface JXRefreshNormalHeader (){
    __unsafe_unretained UIImageView *_arrowImageView;
}
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation JXRefreshNormalHeader
#pragma mark - *** lazy load
- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[NSBundle jx_arrowImage]];
        [self addSubview:_arrowImageView = arrowView];
    }
    return _arrowImageView;
}

- (UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc]init];
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark - *** Public Method
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    self.indicatorView.activityIndicatorViewStyle = activityIndicatorViewStyle;
}

- (void)prepare{
    [super prepare];
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews{
    [super placeSubviews];
    
    self.indicatorView.activityIndicatorViewStyle = self.activityIndicatorViewStyle;
    self.indicatorView.tintColor = self.stateLabel.textColor;
    self.arrowImageView.image = [NSBundle jx_arrowImage];

    [self addConstraints];
}



- (void)addConstraints{
    self.arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    /// arrowImageV
    UIImageView *arrowImageV = self.arrowImageView;
    UILabel *stateLabel = self.stateLabel;
    NSDictionary *views = NSDictionaryOfVariableBindings(stateLabel,arrowImageV);
    NSDictionary *metrics = @{@"margin":@(self.labelLeftInset)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[arrowImageV]-margin-[stateLabel]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:arrowImageV
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
    
    
    
    /// loadingView
    UIView *loadingView = self.indicatorView;
    // 与箭头一致
    [self addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageV
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:loadingView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageV
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:loadingView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    
}



- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    // 根据状态做事情
    if (state == JXRefreshStateIdle) {
        if (oldState == JXRefreshStateRefreshing) {
            self.arrowImageView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:JXRefreshSlowAnimationDuration animations:^{
                self.indicatorView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != JXRefreshStateIdle) return;
                
                self.indicatorView.alpha = 1.0;
                [self.indicatorView stopAnimating];
                self.arrowImageView.hidden = NO;
            }];
        } else {
            [self.indicatorView stopAnimating];
            self.arrowImageView.hidden = NO;
            [UIView animateWithDuration:JXRefreshFastAnimationDuration animations:^{
                self.arrowImageView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == JXRefreshStatePulling) {
        [self.indicatorView stopAnimating];
        self.arrowImageView.hidden = NO;
        [UIView animateWithDuration:JXRefreshFastAnimationDuration animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == JXRefreshStateRefreshing) {
        self.indicatorView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.indicatorView startAnimating];
        self.arrowImageView.hidden = YES;
    }
}


@end
