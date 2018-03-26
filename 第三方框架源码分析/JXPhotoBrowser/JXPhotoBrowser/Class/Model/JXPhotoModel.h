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

@property (nonatomic, copy) NSURL *highImageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign, getter=isBigImage) BOOL bigImage;

// 预览的动画
@property (nonatomic, strong) UIImage *preImage;
@end
