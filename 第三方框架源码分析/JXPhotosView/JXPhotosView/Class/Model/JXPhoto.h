//
//  JXPhoto.h
//  JXPhotosView
//
//  Created by HJXICon on 2018/3/20.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXPhoto : NSObject
/** thumbnail_pic 图片缩略图地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;
/** original_pic 图片原图地址 */
@property (nonatomic, copy) NSString *original_pic;

@end
