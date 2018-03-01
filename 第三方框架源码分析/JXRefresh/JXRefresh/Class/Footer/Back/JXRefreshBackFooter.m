//
//  JXRefreshBackFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshBackFooter.h"
#import "UIView+JXExtension.h"
#import "UIScrollView+JXExtension.h"
#import "JXRefreshConst.h"
#import "UIScrollView+JXRefreshExtension.h"

@interface JXRefreshBackFooter()
@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;
@end

@implementation JXRefreshBackFooter

#pragma mark - *** 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self scrollViewContentSizeDidChange:nil];
}

#pragma mark - *** Override Method
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
    // 如果正在刷新，直接返回
    if (self.state == JXRefreshStateRefreshing) return;
    
    // 记录原始
    _scrollViewOriginalInset = self.scrollView.jx_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.jx_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.jx_height;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == JXRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.jx_height;
        
        if (self.state == JXRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = JXRefreshStatePulling;
        } else if (self.state == JXRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = JXRefreshStateIdle;
        }
    } else if (self.state == JXRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的高度
    CGFloat contentHeight = self.scrollView.jx_contentH + self.ignoredScrollViewContentInsetBottom;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.jx_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
    // 设置位置和尺寸
    self.jx_y = MAX(contentHeight, scrollHeight);
}

- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    // 根据状态来设置属性
    if (state == JXRefreshStateNoMoreData || state == JXRefreshStateIdle) {
        // 刷新完毕
        if (JXRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:JXRefreshSlowAnimationDuration animations:^{
                self.scrollView.jx_insetB -= self.lastBottomDelta;
                
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                
                if (self.endRefreshingCompletionBlock) {
                    self.endRefreshingCompletionBlock();
                }
            }];
        }
        
        CGFloat deltaH = [self heightForContentBreakView];
        // 刚刷新完毕
        if (JXRefreshStateRefreshing == oldState && deltaH > 0 && self.scrollView.jx_totalDataCount != self.lastRefreshCount) {
            self.scrollView.jx_offsetY = self.scrollView.jx_offsetY;
        }
    } else if (state == JXRefreshStateRefreshing) {
        // 记录刷新前的数量
        self.lastRefreshCount = self.scrollView.jx_totalDataCount;
        
        [UIView animateWithDuration:JXRefreshFastAnimationDuration animations:^{
            CGFloat bottom = self.jx_height + self.scrollViewOriginalInset.bottom;
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) { // 如果内容高度小于view的高度
                bottom -= deltaH;
            }
            self.lastBottomDelta = bottom - self.scrollView.jx_insetB;
            self.scrollView.jx_insetB = bottom;
            self.scrollView.jx_offsetY = [self happenOffsetY] + self.jx_height;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}


#pragma mark - *** Private Method
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}
@end
