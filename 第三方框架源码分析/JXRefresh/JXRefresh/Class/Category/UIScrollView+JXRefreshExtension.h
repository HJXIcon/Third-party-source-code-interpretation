//
//  UIScrollView+JXRefreshExtension.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/27.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXRefreshHeader.h"

@interface UIScrollView (JXRefreshExtension)

/** 下拉刷新控件 */
@property (strong, nonatomic) JXRefreshHeader *jx_header;

@end
