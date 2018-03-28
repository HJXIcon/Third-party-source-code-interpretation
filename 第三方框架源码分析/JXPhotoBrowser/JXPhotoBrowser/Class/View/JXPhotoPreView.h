//
//  JXPhotoPreView.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/22.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXPhotoPreView : UIImageView


- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(void(^)(UIImage *image))complete;

- (void)removeProgressView;
@end
