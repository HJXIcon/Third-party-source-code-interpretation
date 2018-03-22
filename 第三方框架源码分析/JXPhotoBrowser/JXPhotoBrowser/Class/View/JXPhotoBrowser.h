//
//  JXPhotoBrowser.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXPhotoBrowser : UIWindow

@property (nonatomic, strong) NSArray<NSString *> *thumbnail_pics;
@property (nonatomic, strong) NSArray<NSString *> *original_pics;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;

+ (instancetype)photoBrowser;
- (void)show;

@end
