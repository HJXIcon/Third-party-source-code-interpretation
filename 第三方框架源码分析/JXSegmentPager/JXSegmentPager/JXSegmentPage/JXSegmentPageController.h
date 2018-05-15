//
//  JXSegmentPageController.h
//  JXSegmentPager
//
//  Created by HJXICon on 2018/5/14.
//  Copyright © 2018年 beiyugame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXSegmentPageControllerDelegate.h"
#import "JXSegmentPageHeaderProcotol.h"

@class JXSegmentView;
@interface JXSegmentPageController : UIViewController


@property(nonatomic, assign) CGFloat segmentHeight;
@property(nonatomic, assign) CGFloat headerHeight; 
@property(nonatomic, assign)
CGFloat segmentMiniTopInset; // should be equal or greater than 0
@property(nonatomic, assign) BOOL freezenHeaderWhenReachMaxHeaderHeight;

//readonly properties
@property(nonatomic, assign, readonly) CGFloat segmentTopInset;
@property(nonatomic, weak, readonly)
UIViewController<JXSegmentPageControllerDelegate> *currentDisplayController;
@property(nonatomic, strong, readonly) JXSegmentView *segmentView;
@property(nonatomic, strong, readonly)
UIView<JXSegmentPageHeaderProcotol> *headerView;

- (instancetype)initWithControllers:
(UIViewController<JXSegmentPageControllerDelegate> *)controller,
... NS_REQUIRES_NIL_TERMINATION;

- (void)setViewControllers:(NSArray *)viewControllers;
- (UIView<JXSegmentPageHeaderProcotol> *)customHeaderView;

@end
