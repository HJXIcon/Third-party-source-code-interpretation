//
//  JXProgressView.h
//  JXPhotosView
//
//  Created by HJXICon on 2018/3/20.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, JXProgressViewMode){
    JXProgressViewModeLoopDiagram, // 环形
    JXProgressViewModePieDiagram   // 饼形
};

UIKIT_EXTERN CGFloat const JXProgressViewItemMargin;

UIKIT_EXTERN CGFloat const JXProgressViewLoopDiagramWidth;

@interface JXProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) JXProgressViewMode mode;
@end
