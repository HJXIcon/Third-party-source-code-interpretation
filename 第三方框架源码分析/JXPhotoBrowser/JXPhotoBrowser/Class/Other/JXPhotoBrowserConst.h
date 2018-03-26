//
//  JXPhotoBrowserConst.h
//  JXPhotoBrowser
//
//  Created by HJXICon on 2018/3/21.
//  CoJXright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>


// 屏幕宽高
// 屏幕宽高(注意：由于不同iOS系统下，设备横竖屏时屏幕的高度和宽度有的是变化的有的是不变的)
#define JXRealyScreenW [UIScreen mainScreen].bounds.size.width
#define JXRealyScreenH [UIScreen mainScreen].bounds.size.height

// 屏幕宽高（这里获取的是正常竖屏的屏幕宽高（宽永远小于高度））
#define JXScreenW (JXRealyScreenW < JXRealyScreenH ? JXRealyScreenW : JXRealyScreenH)
#define JXScreenH (JXRealyScreenW > JXRealyScreenH ? JXRealyScreenW : JXRealyScreenH)
#define JXScreenSize CGSizeMake(JXScreenW, JXScreenH)

// 旋转角为90°或者270°
#define PYVertical (ABS(acosf(self.photoBrowser.transform.a) - M_PI_2) < 0.01 || ABS(acosf(self.photoBrowser.transform.a) - M_PI_2 * 3) < 0.01)


// cell的宽
#define JXPreviewCellW (_previewCell.jx_width > 0 ? _previewCell.jx_width : JXScreenW)
// cell的高
#define JXPreviewCellH (_previewCell.jx_height > 0 ? _previewCell.jx_height : JXScreenH)


UIKIT_EXTERN const CGFloat PYPreviewPhotoSpacing;   // 预览图片时，图片的间距（默认为30

UIKIT_EXTERN  NSString * const JXAddGestureRecognizersNoti;
UIKIT_EXTERN  NSString * const JXHidePhotoBrowserNoti;
UIKIT_EXTERN  NSString * const JXShowPhotoBrowserOriginFrameNoti;
