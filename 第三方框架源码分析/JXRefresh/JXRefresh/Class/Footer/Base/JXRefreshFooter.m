//
//  JXRefreshFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshFooter.h"
#import "JXRefreshConst.h"
#import "UIView+JXExtension.h"
#import "UIScrollView+JXExtension.h"


@interface JXRefreshFooter ()

@end
@implementation JXRefreshFooter
+ (instancetype)footerWithRefreshingBlock:(JXRefreshComponentRefreshingBlock)block{
    JXRefreshFooter *cmp = [[self alloc]init];
    cmp.refreshingBlock = block;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    JXRefreshFooter *cmp = [[self alloc]init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}


#pragma mark - *** Override Method
- (void)prepare{
    [super prepare];
    
    // 设置高度
    self.jx_height = JXRefreshFooterHeight;
}


#pragma mark - *** Public Method
- (void)endRefreshingWithNoMoreData{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = JXRefreshStateNoMoreData;
    });
}

- (void)resetNoMoreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = JXRefreshStateIdle;
    });
}



@end
