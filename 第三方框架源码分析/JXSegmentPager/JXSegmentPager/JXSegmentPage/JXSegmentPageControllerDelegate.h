//
//  JXSegmentPageControllerDelegate.h
//  JXSegmentPager
//
//  Created by HJXICon on 2018/5/14.
//  Copyright © 2018年 beiyugame. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JXSegmentPageControllerDelegate <NSObject>

- (NSString *)segmentTitle;

@optional
- (UIScrollView *)streachScrollView;

@end
