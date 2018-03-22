//
//  JXPhotoView.h
//  JXPhotosView
//
//  Created by HJXICon on 2018/3/20.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "YYAnimatedImageView.h"
@class JXPhoto;

@interface JXPhotoView : YYAnimatedImageView<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;

- (void)eliminateScale; // 清除缩放

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doubleTapToZommWithScale:(CGFloat)scale;

- (void)clear;

@end
