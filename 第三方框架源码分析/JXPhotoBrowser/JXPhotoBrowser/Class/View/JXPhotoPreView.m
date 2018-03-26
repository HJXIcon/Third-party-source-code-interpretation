//
//  JXPhotoPreView.m
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/22.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXPhotoPreView.h"
#import "UIImageView+WebCache.h"
#import "JXPhotoModel.h"
#import "UIView+JXExtension.h"
#import "JXPhotoBrowserConst.h"
#import "JXPhotoPreviewCell.h"
#import "JXPhotoBrowser.h"
#import "JXProgressView.h"
#import "JXPhotoPreViewController.h"

@interface JXPhotoPreView()
@end
@implementation JXPhotoPreView

#pragma mark - *** setter
- (void)setPhoto:(JXPhotoModel *)photo{
    _photo = photo;
    
    if (!photo.highImageURL) {
        self.image = photo.placeholderImage;
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self sd_setImageWithURL:photo.highImageURL placeholderImage:photo.placeholderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.photoPreViewController.progressView.progress = receivedSize * 1.0 /expectedSize;
        });
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
        self.photo.preImage = image;
        [[NSNotificationCenter defaultCenter]postNotificationName:JXAddGestureRecognizersNoti object:nil];
    }];
    
    
}

#pragma mark - *** Overried Method
- (void)setImage:(UIImage *)image{
    [super setImage:image];
    
    if (!image) return;
    CGFloat height = JXPreviewCellW * image.size.height / image.size.width;
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    if (height > JXPreviewCellH) { // 长图
        self.jx_size = CGSizeMake(JXPreviewCellW, JXPreviewCellW * image.size.height / image.size.width);
        
    }else{
        if (image.size.width > JXPreviewCellW) {//超过cellW
            self.jx_size = CGSizeMake(JXPreviewCellW,JXPreviewCellW * image.size.height / image.size.width);
            
        }else{
            self.jx_size = image.size;
        }
    }
    
    // 设置scrollView的大小
    self.previewCell.contentScrollView.jx_height = self.jx_height < JXPreviewCellH ? self.jx_height : JXPreviewCellH;
    self.previewCell.contentScrollView.jx_width = self.jx_width < JXPreviewCellW ? self.jx_width : JXPreviewCellW;
    self.previewCell.contentScrollView.center = CGPointMake(JXPreviewCellW * 0.5, JXPreviewCellH * 0.5);
    self.previewCell.contentScrollView.contentSize = self.jx_size;
    
    // 刷新
    [self setNeedsLayout];
}

@end
