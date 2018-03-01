//
//  JXRefreshFooter.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshComponent.h"
/*!*
 创建footer、endRefresh状态修改、忽略多少scrollView的contentInset的bottom 、消除没有更多数据的状态
 */
@interface JXRefreshFooter : JXRefreshComponent
+ (instancetype)footerWithRefreshingBlock:(JXRefreshComponentRefreshingBlock)block;
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData;

/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 忽略多少scrollView的contentInset的bottom */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;

@end
