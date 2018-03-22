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

@interface JXPhotoBrowser()
@property (nonatomic, strong) UIWindow *window;

@end

@implementation JXPhotoBrowser



+ (instancetype)photoBrowser{
    return [[self alloc]initWithFrame:CGRectMake(0, 0, JXScreenW, JXScreenH)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)show{
    self.window = self;
    JXPhotoPreViewController *root = [[JXPhotoPreViewController alloc]init];
    root.window = self;
    root.original_pics = self.original_pics;
    root.thumbnail_pics = self.thumbnail_pics;
    self.rootViewController = root;
    
    // 设置窗口级别(最高级)
    self.windowLevel = UIWindowLevelAlert;
    self.hidden = NO;
    self.backgroundColor = [UIColor blackColor];

}

- (void)hide{
    self.window = nil;
}

@end
