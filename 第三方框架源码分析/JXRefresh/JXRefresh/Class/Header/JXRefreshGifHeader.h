//
//  JXRefreshGifHeader.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshStateHeader.h"

@interface JXRefreshGifHeader : JXRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *gifImageView;
// 默认 JXRefreshHeaderHeight * JXRefreshHeaderHeight
@property (nonatomic, assign) CGSize gifImageViewSize;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images
         duration:(NSTimeInterval)duration
         forState:(JXRefreshState)state;
- (void)setImages:(NSArray *)images
         forState:(JXRefreshState)state;
@end
