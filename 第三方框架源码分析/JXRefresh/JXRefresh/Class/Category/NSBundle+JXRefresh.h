//
//  NSBundle+JXRefresh.h
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (JXRefresh)
+ (instancetype)jx_refreshBundle;
+ (UIImage *)jx_arrowImage;
+ (NSString *)jx_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)jx_localizedStringForKey:(NSString *)key;

@end
