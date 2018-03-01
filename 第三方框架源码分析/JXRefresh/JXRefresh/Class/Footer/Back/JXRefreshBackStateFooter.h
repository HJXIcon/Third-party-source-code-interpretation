//
//  JXRefreshBackStateFooter.h
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshBackFooter.h"

@interface JXRefreshBackStateFooter : JXRefreshBackFooter
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(JXRefreshState)state;

/** 获取state状态下的title */
- (NSString *)titleForState:(JXRefreshState)state;

@end
