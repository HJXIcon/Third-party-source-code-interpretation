//
//  JXRefreshNormalHeader.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshStateHeader.h"

@interface JXRefreshNormalHeader : JXRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowImageView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
