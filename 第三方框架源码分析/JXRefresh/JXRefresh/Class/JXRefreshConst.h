//
//  JXRefreshConst.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define JXWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define JXRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define JXRefreshLog(...)
#endif

// 过期提醒
#define JXRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define JXRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define JXRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define JXRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define JXRefreshLabelTextColor JXRefreshColor(90, 90, 90)
// 字体大小
#define JXRefreshLabelFont [UIFont boldSystemFontOfSize:14]


// 数字
UIKIT_EXTERN const CGFloat JXRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat JXRefreshStateLabelWidth;
UIKIT_EXTERN const CGFloat JXRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat JXRefreshFooterHeight;
UIKIT_EXTERN const CGFloat JXRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat JXRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const JXRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const JXRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const JXRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const JXRefreshKeyPathPanState;

// 偏好设置key
UIKIT_EXTERN NSString *const JXRefreshHeaderLastUpdatedTimeKey;

// 文字
UIKIT_EXTERN NSString *const JXRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const JXRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const JXRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const JXRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const JXRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const JXRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const JXRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const JXRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const JXRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const JXRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const JXRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const JXRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const JXRefreshHeaderNoneLastDateText;

// 状态检查
#define JXRefreshCheckState \
JXRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];

