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

@implementation NSObject (JXRefreshExtension)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2{
    
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

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

#pragma mark - *** dataCount
- (NSInteger)jx_totalDataCount{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

- (void)setJx_reloadDataBlock:(void (^)(NSInteger))jx_reloadDataBlock{
    
    if (self.jx_reloadDataBlock != jx_reloadDataBlock) {
        [self willChangeValueForKey:@"jx_reloadDataBlock"];
        objc_setAssociatedObject(self, @selector(jx_reloadDataBlock), jx_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self didChangeValueForKey:@"jx_reloadDataBlock"];
    }
}


- (void (^)(NSInteger))jx_reloadDataBlock{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)executeReloadDataBlock{
    !self.jx_reloadDataBlock ? : self.jx_reloadDataBlock(self.jx_totalDataCount);
}


@end


@implementation UITableView (JXRefreshExtension)

+ (void)load{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(jx_reloadData)];
}

- (void)jx_reloadData{
    [self jx_reloadData];
    [self executeReloadDataBlock];
}
@end


@implementation UICollectionView (JXRefreshExtension)
+ (void)load{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(jx_reloadData)];
}

- (void)jx_reloadData{
    [self jx_reloadData];
    [self executeReloadDataBlock];
}
@end
