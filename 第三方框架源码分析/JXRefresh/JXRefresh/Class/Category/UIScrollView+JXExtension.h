//
//  UIScrollView+JXExtension.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (JXExtension)

@property (readonly, nonatomic) UIEdgeInsets jx_inset;

@property (assign, nonatomic) CGFloat jx_insetT;
@property (assign, nonatomic) CGFloat jx_insetB;
@property (assign, nonatomic) CGFloat jx_insetL;
@property (assign, nonatomic) CGFloat jx_insetR;

@property (assign, nonatomic) CGFloat jx_offsetX;
@property (assign, nonatomic) CGFloat jx_offsetY;

@property (assign, nonatomic) CGFloat jx_contentW;
@property (assign, nonatomic) CGFloat jx_contentH;

@end
