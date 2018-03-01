//
//  JXRefreshBackGifFooter.h
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshBackStateFooter.h"

@interface JXRefreshBackGifFooter : JXRefreshBackStateFooter

@property (weak, nonatomic, readonly) UIImageView *gifView;
@property (nonatomic, assign) CGSize gifViewSize;
/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images
         duration:(NSTimeInterval)duration
         forState:(JXRefreshState)state;
- (void)setImages:(NSArray *)images
         forState:(JXRefreshState)state;

@end
