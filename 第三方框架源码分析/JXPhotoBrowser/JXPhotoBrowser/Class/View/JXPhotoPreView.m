//
//  JXPhotoPreView.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/22.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoPreView.h"
#import "UIView+JXExtension.h"
#import "JXPhotoBrowserConst.h"
#import "JXProgressView.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>


@interface JXPhotoPreView()
@property (nonatomic, weak) JXProgressView *progressView;
@end
@implementation JXPhotoPreView

#pragma mark - *** setter
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(void(^)(UIImage *image))complete{
    
    if (!url) {
        self.image = placeholder;
        return;
    }
    
    JXProgressView *progressView = [[JXProgressView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    progressView.center = self.center;
    _progressView = progressView;
    [self addSubview:progressView];
    [self bringSubviewToFront:progressView];
    
    __weak typeof(self) weakSelf = self;
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.progress = receivedSize * 1.0 /expectedSize;
        });
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.progressView removeFromSuperview];
        weakSelf.image = image;
        if (complete) {
            complete (image);
        }
    }];
    
}

- (void)removeProgressView{
    [self.progressView removeFromSuperview];
}
@end
