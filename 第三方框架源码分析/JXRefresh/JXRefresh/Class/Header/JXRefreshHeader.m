//
//  JXRefreshHeader.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/27.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshHeader.h"
#import "UIView+JXExtension.h"
#import "JXRefreshConst.h"
#import "UIScrollView+JXExtension.h"

@interface JXRefreshHeader()
@property (assign, nonatomic) CGFloat insetTDelta;
@end


@implementation JXRefreshHeader


#pragma mark - *** 创建header
+ (instancetype)headerWithRefreshingBlock:(JXRefreshComponentRefreshingBlock)block{
    JXRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = block;
    return cmp;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    JXRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingTarget = target;
    cmp.refreshingAction = action;
    return cmp;
}


#pragma mark - *** Override Method
- (void)prepare{
    [super prepare];
    
    // 设置key
    self.lastUpdatedTimeKey = JXRefreshHeaderLastUpdatedTimeKey;
    
    // 设置高度
    self.jx_height = JXRefreshHeaderHeight;
   
}

- (void)placeSubviews{
    [super placeSubviews];
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.jx_y = - self.jx_height - _ignoredScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    /// 刷新状态
    if (self.state == JXRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;
        
        // sectionheader 停留解决
        CGFloat insetT = - self.scrollView.jx_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.jx_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.jx_height + _scrollViewOriginalInset.top ? self.jx_height + _scrollViewOriginalInset.top : insetT;
        
        self.scrollView.jx_insetT = insetT;
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.jx_inset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.jx_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.jx_height;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.jx_height;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        /*!
         offsetY < normal2pullingOffsetY
         由于是下拉，都为负数，绝对值是offsetY > normal2pullingOffsetY
         */
        if (self.state == JXRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = JXRefreshStatePulling;
        } else if (self.state == JXRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
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



- (void)setState:(JXRefreshState)state{
    JXRefreshCheckState
    // 根据状态做事情
    if (state == JXRefreshStateIdle) {
        /*!
         闲置->是不是刷新后闲置？
         NO:return
         Yes:保留刷新时间、恢复inset和offset
         */
        if (oldState != JXRefreshStateRefreshing) return;
        
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 恢复inset和offset
        [UIView animateWithDuration:JXRefreshSlowAnimationDuration animations:^{
            self.scrollView.jx_insetT += self.insetTDelta;
            
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
        
    } else if (state == JXRefreshStateRefreshing) {
        
        /*！
         刷新状态：增加滚动区域top、设置滚动位置、执行刷新操作
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:JXRefreshFastAnimationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.jx_height;
                // 增加滚动区域top
                self.scrollView.jx_insetT = top;
                // 设置滚动位置
                CGPoint offset = self.scrollView.contentOffset;
                offset.y = -top;
                [self.scrollView setContentOffset:offset animated:NO];
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        });
    }
}


- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}

- (void)setIgnoredScrollViewContentInsetTop:(CGFloat)ignoredScrollViewContentInsetTop {
    _ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
    
    self.jx_y = - self.jx_height - _ignoredScrollViewContentInsetTop;
}


@end



