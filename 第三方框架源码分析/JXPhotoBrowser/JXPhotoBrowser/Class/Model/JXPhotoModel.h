//
//  JXPhotoModel.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/22.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXPhotoModel : NSObject
/** thumbnail_pic 图片缩略图地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;
/** original_pic 图片原图地址 */
@property (nonatomic, copy) NSString *original_pic;

@property (nonatomic, strong) UIImage *thumbnail_image;
@property (nonatomic, strong) UIImage *original_image;

@property (nonatomic, assign, getter=isBigImage) BOOL bigImage;

@end
