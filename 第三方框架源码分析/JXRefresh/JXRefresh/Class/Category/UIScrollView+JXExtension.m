//
//  UIScrollView+JXExtension.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "UIScrollView+JXExtension.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
static BOOL gt_ios_11_;
@implementation UIScrollView (JXExtension)
+ (void)load
{
    // 缓存判断值
    gt_ios_11_ = [[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending;
}

- (UIEdgeInsets)jx_inset
{
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}

- (void)setJx_insetT:(CGFloat)jx_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = jx_insetT;
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)jx_insetT
{
    return self.jx_inset.top;
}


- (void)setJx_insetB:(CGFloat)jx_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = jx_insetB;
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)jx_insetB
{
    return self.jx_inset.bottom;
}

- (void)setJx_insetL:(CGFloat)jx_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = jx_insetL;
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)jx_insetL
{
    return self.jx_inset.left;
}

- (void)setJx_insetR:(CGFloat)jx_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = jx_insetR;
#ifdef __IPHONE_11_0
    if (gt_ios_11_) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)jx_insetR
{
    return self.jx_inset.right;
}

- (void)setJx_offsetX:(CGFloat)jx_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = jx_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)jx_offsetX
{
    return self.contentOffset.x;
}

- (void)setJx_offsetY:(CGFloat)jx_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = jx_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)jx_offsetY
{
    return self.contentOffset.y;
}

- (void)setJx_contentW:(CGFloat)jx_contentW
{
    CGSize size = self.contentSize;
    size.width = jx_contentW;
    self.contentSize = size;
}

- (CGFloat)jx_contentW
{
    return self.contentSize.width;
}

- (void)setJx_contentH:(CGFloat)jx_contentH
{
    CGSize size = self.contentSize;
    size.height = jx_contentH;
    self.contentSize = size;
}

- (CGFloat)jx_contentH
{
    return self.contentSize.height;
}

@end

#pragma clang diagnostic pop
