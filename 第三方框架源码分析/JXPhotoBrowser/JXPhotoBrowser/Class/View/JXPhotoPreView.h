//
//  JXPhotoPreView.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/22.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPhotoModel,JXPhotoPreviewCell,JXPhotoPreViewController;

@interface JXPhotoPreView : UIImageView

@property (nonatomic, strong) JXPhotoModel *photo;
@property (nonatomic, weak) JXPhotoPreviewCell *previewCell;
@property (nonatomic, weak) JXPhotoPreViewController *photoPreViewController;
@end
