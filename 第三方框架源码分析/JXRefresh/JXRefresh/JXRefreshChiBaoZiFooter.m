//
//  JXRefreshChiBaoZiFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshChiBaoZiFooter.h"

@implementation JXRefreshChiBaoZiFooter
- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:JXRefreshStateRefreshing];
}

@end
