//
//  UIScrollView+JXRefreshExtension.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/27.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JXRefreshHeader,JXRefreshFooter;
@interface UIScrollView (JXRefreshExtension)

/** 下拉刷新控件 */
@property (strong, nonatomic) JXRefreshHeader *jx_header;
/** 上拉刷新控件 */
@property (strong, nonatomic) JXRefreshFooter *jx_footer;


#pragma mark - *** dataCount
- (NSInteger)jx_totalDataCount;
@property (copy, nonatomic) void (^jx_reloadDataBlock)(NSInteger totalDataCount);

@end
