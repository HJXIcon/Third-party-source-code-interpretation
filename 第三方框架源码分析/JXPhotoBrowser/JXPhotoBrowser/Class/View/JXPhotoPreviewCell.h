//
//  JXPhotoPreviewCell.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPhotoModel,JXPhotoPreView;
@interface JXPhotoPreviewCell : UICollectionViewCell
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) JXPhotoPreView *photoPreView;
@property (nonatomic, strong) JXPhotoModel *photoModel;

@end
