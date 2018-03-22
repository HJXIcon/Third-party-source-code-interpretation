//
//  JXPhotoBrowser.h
//  JXPhotosView
//
//  Created by HJXICon on 2018/3/20.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPhotoBrowser;
@protocol JXPhotoBrowserDelegate<NSObject>

@required
- (UIImage *)photoBrowser:(JXPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
@optional
- (NSURL *)photoBrowser:(JXPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
@end


@interface JXPhotoBrowser : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<JXPhotoBrowserDelegate> delegate;

- (void)show;
@end
