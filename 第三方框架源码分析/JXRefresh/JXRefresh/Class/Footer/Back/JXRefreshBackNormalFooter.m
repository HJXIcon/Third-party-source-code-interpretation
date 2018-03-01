//
//  JXRefreshBackNormalFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshBackNormalFooter.h"
#import "NSBundle+JXRefresh.h"
#import "JXRefreshConst.h"
#import "UIView+JXExtension.h"

@interface JXRefreshBackNormalFooter (){
    __unsafe_unretained UIImageView *_arrowImageView;
}
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;

@end
@implementation JXRefreshBackNormalFooter

#pragma mark - *** lazy load
- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[NSBundle jx_arrowImage]];
        [self addSubview:_arrowImageView = arrowImageView];
    }
    return _arrowImageView;
}
- (UIActivityIndicatorView *)loadingView{
    if (_loadingView == nil) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma mark - *** setter
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
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
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.jx_width * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= self.labelLeftInset + self.stateLabel.jx_textWith * 0.5;
    }
    CGFloat arrowCenterY = self.jx_height * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowImageView.constraints.count == 0) {
        self.arrowImageView.jx_size = self.arrowImageView.image.size;
        self.arrowImageView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    
    self.arrowImageView.tintColor = self.stateLabel.textColor;
}

- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    // 根据状态做事情
    if (state == JXRefreshStateIdle) {
        if (oldState == JXRefreshStateRefreshing) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            [UIView animateWithDuration:JXRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                
                self.arrowImageView.hidden = NO;
            }];
        } else {
            self.arrowImageView.hidden = NO;
            [self.loadingView stopAnimating];
            [UIView animateWithDuration:JXRefreshFastAnimationDuration animations:^{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    } else if (state == JXRefreshStatePulling) {
        self.arrowImageView.hidden = NO;
        [self.loadingView stopAnimating];
        [UIView animateWithDuration:JXRefreshFastAnimationDuration animations:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }];
    } else if (state == JXRefreshStateRefreshing) {
        self.arrowImageView.hidden = YES;
        [self.loadingView startAnimating];
    } else if (state == JXRefreshStateNoMoreData) {
        self.arrowImageView.hidden = YES;
        [self.loadingView stopAnimating];
    }
}

@end
