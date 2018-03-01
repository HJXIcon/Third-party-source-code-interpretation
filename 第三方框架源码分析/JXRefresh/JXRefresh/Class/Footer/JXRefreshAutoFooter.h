//
//  JXRefreshAutoFooter.h
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshFooter.h"

/**！
 0.添加footer并设置frame、控制contentSize、监听contentSize并修改footer的y、控制footer的刷新动作、处理刷新ing的时候继续拖拽不会开始刷新、
 1.是否自动刷新；
 2.当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新；
 3.是否每一次拖拽只发一次请求
 */
@interface JXRefreshAutoFooter : JXRefreshFooter
/** 是否自动刷新(默认为YES) */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;

/** 是否每一次拖拽只发一次请求 */
@property (assign, nonatomic, getter=isOnlyRefreshPerDrag) BOOL onlyRefreshPerDrag;

@end
