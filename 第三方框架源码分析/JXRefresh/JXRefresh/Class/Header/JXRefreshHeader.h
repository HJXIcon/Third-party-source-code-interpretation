//
//  JXRefreshHeader.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/27.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshComponent.h"

@interface JXRefreshHeader : JXRefreshComponent

+ (instancetype)headerWithRefreshingBlock:(JXRefreshComponentRefreshingBlock)block;
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;


@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

@end



