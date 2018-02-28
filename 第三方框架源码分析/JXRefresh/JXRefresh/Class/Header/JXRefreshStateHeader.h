//
//  JXRefreshStateHeader.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshHeader.h"

@interface JXRefreshStateHeader : JXRefreshHeader
#pragma mark - 刷新时间相关
/** 利用这个block来决定显示的更新时间文字 */
@property (copy, nonatomic) NSString *(^lastUpdatedTimeText)(NSDate *lastUpdatedTime);
/** 显示上一次刷新时间的label */
@property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;

#pragma mark - 状态相关
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(JXRefreshState)state;

@end
