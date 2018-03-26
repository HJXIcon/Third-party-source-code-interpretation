//
//  JXPhotoPreViewController.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPhotoBrowser,JXProgressView;
@interface JXPhotoPreViewController : UIViewController

@property (nonatomic, weak) JXPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSArray<UIImage *> *placeholderImages;
@property (nonatomic, strong) NSArray<NSURL *> *highQualityImages;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, strong) JXProgressView *progressView;
@end
