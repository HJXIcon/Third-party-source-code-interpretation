//
//  UIScrollView+JXRefreshExtension.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/27.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "UIScrollView+JXRefreshExtension.h"
#import "JXRefreshFooter.h"
#import "JXRefreshHeader.h"
#import <objc/runtime.h>

@implementation UIScrollView (JXRefreshExtension)

- (void)setJx_header:(JXRefreshHeader *)jx_header{
    
    if (jx_header != self.jx_header) {
        // 删除旧的，添加新的
        [self.jx_header removeFromSuperview];
        [self insertSubview:jx_header atIndex:0];
        // 存储新的
        [self willChangeValueForKey:@"jx_header"]; // KVO
        objc_setAssociatedObject(self, @selector(jx_header), jx_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"jx_header"]; // KVO
    }
    
}

- (JXRefreshHeader *)jx_header{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJx_footer:(JXRefreshFooter *)jx_footer{
    if (jx_footer != self.jx_footer) {
        // 删除旧的，添加新的
        [self.jx_footer removeFromSuperview];
        [self insertSubview:jx_footer atIndex:0];
        // 存储新的
        [self willChangeValueForKey:@"jx_footer"]; // KVO
        objc_setAssociatedObject(self, @selector(jx_footer), jx_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"jx_footer"]; // KVO
    }
}


- (JXRefreshFooter *)jx_footer{
    return objc_getAssociatedObject(self, _cmd);
}
@end
