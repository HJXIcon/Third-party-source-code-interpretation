//
//  JXRefreshAutoFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshAutoFooter.h"
#import "UIScrollView+JXExtension.h"
#import "UIView+JXExtension.h"
#import "JXRefreshConst.h"

@interface JXRefreshAutoFooter()
/** 一个新的拖拽 */
@property (assign, nonatomic, getter=isOneNewPan) BOOL oneNewPan;
@end
@implementation JXRefreshAutoFooter
#pragma mark - init
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.jx_insetB += self.jx_height;
        }
        
        // 设置位置
        self.jx_y = _scrollView.jx_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.jx_insetB -= self.jx_height;
        }
    }
}

#pragma mark - Override Method
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
    
    // 默认是当offset达到条件就发送请求（可连续）
    self.onlyRefreshPerDrag = NO;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    // 设置位置
    self.jx_y = self.scrollView.jx_contentH;
}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != JXRefreshStateIdle || !self.automaticallyRefresh || self.jx_y == 0) return;
    
    if (_scrollView.jx_insetT + _scrollView.jx_contentH > _scrollView.jx_height ) {// 内容超过一个屏幕
        // 这里的_scrollView.jx_contentH替换掉self.jx_y更为合理
        if (_scrollView.jx_offsetY >= _scrollView.jx_contentH - _scrollView.jx_height + self.jx_height * self.triggerAutomaticallyRefreshPercent + _scrollView.jx_insetB - self.jx_height) {
            
            // 防止松手开始时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];

        }
        
    }
    
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if (self.state != JXRefreshStateIdle) return;
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    
    if (panState == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.jx_insetT + _scrollView.jx_contentH <= _scrollView.jx_height) {// 不够一个屏幕
            
            if (_scrollView.jx_offsetY >= - _scrollView.jx_insetT) {// 向上拽
                [self beginRefreshing];
            }
        }
        else{// 超出一个屏幕
            if (_scrollView.jx_offsetY >= _scrollView.jx_contentH + _scrollView.jx_insetB - _scrollView.jx_height) {
                [self beginRefreshing];
            }
        }
    }
    else if (panState == UIGestureRecognizerStateBegan) {
        self.oneNewPan = YES;
    }
    
}

- (void)beginRefreshing
{
    if (!self.isOneNewPan && self.isOnlyRefreshPerDrag) return;
    
    [super beginRefreshing];
    
    self.oneNewPan = NO;
}

- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    if (state == JXRefreshStateRefreshing) {
        [self executeRefreshingCallback];
    } else if (state == JXRefreshStateNoMoreData || state == JXRefreshStateIdle) {
        if (JXRefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = JXRefreshStateIdle;
        
        self.scrollView.jx_insetB -= self.jx_height;
    } else if (lastHidden && !hidden) {
        self.scrollView.jx_insetB += self.jx_height;
        
        // 设置位置
        self.jx_y = _scrollView.jx_contentH;
    }
}


@end
