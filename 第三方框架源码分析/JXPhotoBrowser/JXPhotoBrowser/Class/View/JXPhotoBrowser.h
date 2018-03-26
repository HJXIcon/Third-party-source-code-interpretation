//
//  JXPhotoBrowser.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JXPhotoBrowser;
@protocol JXPhotoBrowserDataSource<NSObject>
@required

- (NSInteger)photoBrowserCurrentImageIndex:(JXPhotoBrowser *)browser;

- (NSInteger)photoBrowserImageCount:(JXPhotoBrowser *)browser;

- (UIImage *)photoBrowser:(JXPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional
- (NSURL *)photoBrowser:(JXPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
@end


@protocol JXPhotoBrowserDelegate<NSObject>


@end


@interface JXPhotoBrowser : UIWindow

@property (nonatomic, weak) id<JXPhotoBrowserDataSource> dataSource;
@property (nonatomic, weak) UIView *sourceImageContainerView;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)photoBrowser;
- (void)show;
- (void)hide;

- (void)reloadData;
@end
