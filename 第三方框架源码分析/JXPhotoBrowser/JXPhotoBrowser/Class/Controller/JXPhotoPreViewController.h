//
//  JXPhotoPreViewController.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXPhotoPreViewController : UIViewController

@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, strong) NSArray<NSString *> *thumbnail_pics;
@property (nonatomic, strong) NSArray<NSString *> *original_pics;

@end
