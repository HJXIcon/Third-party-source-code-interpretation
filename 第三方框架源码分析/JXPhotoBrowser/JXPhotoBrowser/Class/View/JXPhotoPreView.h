//
//  JXPhotoPreView.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/22.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPhotoModel,JXPhotoPreviewCell;

@interface JXPhotoPreView : UIImageView

@property (nonatomic, strong) JXPhotoModel *photo;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, weak) JXPhotoPreviewCell *previewCell;
/** 放大的倍数 */
@property (nonatomic, assign) CGFloat scale;

@end
