//
//  JXRefreshBackNormalFooter.h
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshBackStateFooter.h"

@interface JXRefreshBackNormalFooter : JXRefreshBackStateFooter

@property (weak, nonatomic, readonly) UIImageView *arrowImageView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
