//
//  JXPhotoBrowser.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoBrowser.h"
#import "JXPhotoBrowserConst.h"
#import "JXPhotoPreViewController.h"
#import "UIView+JXExtension.h"
#import "JXPhotoPreView.h"
#import "JXProgressView.h"

@interface JXPhotoBrowser()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) NSInteger currentImageIndex;

@end

@implementation JXPhotoBrowser

+ (instancetype)photoBrowser{
    return [[self alloc]initWithFrame:CGRectMake(0, 0, JXScreenW, JXScreenH)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)show{
    self.window = self;
    JXPhotoPreViewController *root = [[JXPhotoPreViewController alloc]init];
    root.photoBrowser = self;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(photoBrowserImageCount:)]) {
        self.imageCount = [self.dataSource photoBrowserImageCount:self];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(photoBrowserCurrentImageIndex:)]) {
        self.currentImageIndex = [self.dataSource photoBrowserCurrentImageIndex:self];
    }
    
    NSMutableArray *placeholderImages = [NSMutableArray array];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        for (NSInteger i = 0; i < self.imageCount; i ++) {
            [placeholderImages addObject:[self.dataSource photoBrowser:self placeholderImageForIndex:i]];
        }
    }
    
    
    NSMutableArray *highImages = [NSMutableArray array];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        for (NSInteger i = 0; i < self.imageCount; i ++) {
            [highImages addObject:[self.dataSource photoBrowser:self highQualityImageURLForIndex:i]];
        }
    }
    
    root.highQualityImages = highImages;
    root.placeholderImages = placeholderImages;
    root.currentImageIndex = self.currentImageIndex;
    self.rootViewController = root;

    [[NSNotificationCenter defaultCenter]postNotificationName:JXShowPhotoBrowserOriginFrameNoti object:self.sourceImageContainerView];
    
    // 设置窗口级别(最高级)
    self.windowLevel = UIWindowLevelAlert;
    self.hidden = NO;
    self.backgroundColor = [UIColor blackColor];

}

- (void)reloadData{
    
}

- (void)hide{
    self.window = nil;
}

@end
