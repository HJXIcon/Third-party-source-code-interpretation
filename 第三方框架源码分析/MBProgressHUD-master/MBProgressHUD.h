//
//  MBProgressHUD.h
//  Version 1.1.0
//  Created by Matej Bukovinski on 2.4.09.
//

// This code is distributed under the terms and conditions of the MIT license. 

// Copyright © 2009-2016 Matej Bukovinski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class MBBackgroundView;
@protocol MBProgressHUDDelegate;


extern CGFloat const MBProgressMaxOffset;

typedef NS_ENUM(NSInteger, MBProgressHUDMode) {
    /// UIActivityIndicatorView.
    MBProgressHUDModeIndeterminate,
    /// A round, pie-chart like, progress view.
    MBProgressHUDModeDeterminate,
    /// Horizontal progress bar.
    MBProgressHUDModeDeterminateHorizontalBar,
    /// Ring-shaped progress view.
    MBProgressHUDModeAnnularDeterminate,
    /// Shows a custom view.
    MBProgressHUDModeCustomView,
    /// Shows only labels.
    MBProgressHUDModeText
};

typedef NS_ENUM(NSInteger, MBProgressHUDAnimation) {
    /// Opacity animation
    MBProgressHUDAnimationFade,
    /// Opacity + scale animation (zoom in when appearing zoom out when disappearing)
    MBProgressHUDAnimationZoom,
    /// Opacity + scale animation (zoom out style)
    MBProgressHUDAnimationZoomOut,
    /// Opacity + scale animation (zoom in style)
    MBProgressHUDAnimationZoomIn
};

typedef NS_ENUM(NSInteger, MBProgressHUDBackgroundStyle) {
    /// Solid color background
    MBProgressHUDBackgroundStyleSolidColor,
    /// UIVisualEffectView or UIToolbar.layer background view
    MBProgressHUDBackgroundStyleBlur
};

typedef void (^MBProgressHUDCompletionBlock)(void);


NS_ASSUME_NONNULL_BEGIN


/** 
 * Displays a simple HUD window containing a progress indicator and two optional labels for short messages.
 *
 * This is a simple drop-in class for displaying a progress HUD view similar to Apple's private UIProgressHUD class.
 * The MBProgressHUD window spans over the entire space given to it by the initWithFrame: constructor and catches all
 * user input on this region, thereby preventing the user operations on components below the view.
 *
 * @note To still allow touches to pass through the HUD, you can set hud.userInteractionEnabled = NO.
 * @attention MBProgressHUD is a UI class and should therefore only be accessed on the main thread.
 */
@interface MBProgressHUD : UIView

/**
 * Creates a new HUD, adds it to provided view and shows it. The counterpart to this method is hideHUDForView:animated:.
 *
 * @note This method sets removeFromSuperViewOnHide. The HUD will automatically be removed from the view hierarchy when hidden.
 *
 * @param view The view that the HUD will be added to
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 * @return A reference to the created HUD.
 *
 * @see hideHUDForView:animated:
 * @see animationType
 
 * @return：返回一个HUD，与类方法hideHUDForView:animated:对应
 * @param：view   HUD要显示的view
 * @param：animated   是否要动画
 */
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/// @name Showing and hiding

/**
 * Finds the top-most HUD subview that hasn't finished and hides it. The counterpart to this method is showHUDAddedTo:animated:.
 *
 * @note This method sets removeFromSuperViewOnHide. The HUD will automatically be removed from the view hierarchy when hidden.
 *
 * @param view The view that is going to be searched for a HUD subview.
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @return YES if a HUD was found and removed, NO otherwise.
 *
 * @see showHUDAddedTo:animated:
 * @see animationType
 
 * @return 返回YES，发现一个HUD并将它移出。否则，什么也不做。
 *  @param：view   显示HUD的view
 * @param：animated   是否要动画
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 * Finds the top-most HUD subview that hasn't finished and returns it.
 *
 * @param view The view that is going to be searched.
 * @return A reference to the last HUD subview discovered.
 
 * @return：返回一个HUD，遍历view的子控件，返回最上面的那个HUD
 *  @param：view   被遍历的view
 */
+ (nullable MBProgressHUD *)HUDForView:(UIView *)view;

/**
 * A convenience constructor that initializes the HUD with the view's bounds. Calls the designated constructor with
 * view.bounds as the parameter.
 *
 * @param view The view instance that will provide the bounds for the HUD. Should be the same instance as
 * the HUD's superview (i.e., the view that the HUD will be added to).
 
 *  @param：view传入的视图对象仅仅做为定义MBProgressHUD视图frame属性的参照
 */
- (instancetype)initWithView:(UIView *)view;

/** 
 * Displays the HUD. 
 *
 * @note You need to make sure that the main thread completes its run loop soon after this method call so that
 * the user interface can be updated. Call this method when your task is already set up to be executed in a new thread
 * (e.g., when using something like NSOperation or making an asynchronous call like NSURLRequest).
 *
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 *
 * @see animationType
 
  是否动画显示HUD
 */
- (void)showAnimated:(BOOL)animated;

/** 
 * Hides the HUD. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 *
 * @see animationType
 
 // 是否动画隐藏HUD
 */
- (void)hideAnimated:(BOOL)animated;

/** 
 * Hides the HUD after a delay. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 * @param delay Delay in seconds until the HUD is hidden.
 *
 * @see animationType
 
 // 延迟几秒隐藏HUD，与上面不同的是：若只是提示用户直接用这个方法就比较好
 */
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/**
 * The HUD delegate object. Receives HUD state notifications.
 */
@property (weak, nonatomic) id<MBProgressHUDDelegate> delegate;

/**
 * Called after the HUD is hiden.
 // HUD隐藏后的回调
 */
@property (copy, nullable) MBProgressHUDCompletionBlock completionBlock;

/*
 * Grace period is the time (in seconds) that the invoked method may be run without
 * showing the HUD. If the task finishes before the grace time runs out, the HUD will
 * not be shown at all.
 * This may be used to prevent HUD display for very short tasks.
 * Defaults to 0 (no grace time).
 * @note The graceTime needs to be set before the hud is shown. You thus can't use `showHUDAddedTo:animated:`,
 * but instead need to alloc / init the HUD, configure the grace time and than show it manually.
 
 *  作用：防止HUD显示非常短的任务。如果任务非常短就完成了，HUD一闪而过，多不友好。
 * 这时设置这个graceTime就可以防止HUD显示非常短（就不显示了）。也就是说
 * 如果graceTime时间没有走 完而任务完成了，这时就不显示HUD。graceTime默认值为0.
 */
@property (assign, nonatomic) NSTimeInterval graceTime;

/**
 * The minimum time (in seconds) that the HUD is shown.
 * This avoids the problem of the HUD being shown and than instantly hidden.
 * Defaults to 0 (no minimum show time).
 
最短显示时间，避免HUD刚显示就隐藏的情况，与graceTime有点像，都是避免HUD显示非常短
 */
@property (assign, nonatomic) NSTimeInterval minShowTime;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to NO.
 
 //  HUD隐藏的时候，是否从Super上移出。默认是NO
 */
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;

/// @name Appearance

/** 
 * MBProgressHUD operation mode. The default is MBProgressHUDModeIndeterminate.
// HUD的形式，mode值是上面模式的值
 */
@property (assign, nonatomic) MBProgressHUDMode mode;

/**
 * A color that gets forwarded to all labels and supported indicators. Also sets the tintColor
 * for custom views on iOS 7+. Set to nil to manage color individually.
 * Defaults to semi-translucent black on iOS 7 and later and white on earlier iOS versions.
 
 iOS后属性带UI_APPEARANCE_SELECTOR 可以统一设置全局作用
 // 设置HUD的子控件的颜色，label和进度模式都是contentColor
 */
@property (strong, nonatomic, nullable) UIColor *contentColor UI_APPEARANCE_SELECTOR;

/**
 * The animation type that should be used when the HUD is shown and hidden.
 
 // HUD显示与隐藏的动画形式
 */
@property (assign, nonatomic) MBProgressHUDAnimation animationType UI_APPEARANCE_SELECTOR;

/**
 * The bezel offset relative to the center of the view. You can use MBProgressMaxOffset
 * and -MBProgressMaxOffset to move the HUD all the way to the screen edge in each direction.
 * E.g., CGPointMake(0.f, MBProgressMaxOffset) would position the HUD centered on the bottom edge.
 
 //  HUD默认是显示在super控件的中央，offset就是HUD相对于super控件中央的偏移量
 */
@property (assign, nonatomic) CGPoint offset UI_APPEARANCE_SELECTOR;

/**
 * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views).
 * This also represents the minimum bezel distance to the edge of the HUD view.
 * Defaults to 20.f
 
 //  margin是HUD的子控件到HUD的边距（最小边距），默认是20.f。
 */
@property (assign, nonatomic) CGFloat margin UI_APPEARANCE_SELECTOR;

/**
 * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
 // 背景框的大小。默认值为CGSizeZero，
 */
@property (assign, nonatomic) CGSize minSize UI_APPEARANCE_SELECTOR;

/**
 * Force the HUD dimensions to be equal if possible.
 
 // 是否强制背景框宽高相等
 */
@property (assign, nonatomic, getter = isSquare) BOOL square UI_APPEARANCE_SELECTOR;

/**
 * When enabled, the bezel center gets slightly affected by the device accelerometer data.
 * Has no effect on iOS < 7.0. Defaults to YES.
 
 // 这个属性没用过，也没试出来。
 */
@property (assign, nonatomic, getter=areDefaultMotionEffectsEnabled) BOOL defaultMotionEffectsEnabled UI_APPEARANCE_SELECTOR;

/// @name Progress

/**
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
 
 // 进度条的进度（从0.0到1.0变化）
 */
@property (assign, nonatomic) float progress;

/// @name ProgressObject

/**
 * The NSProgress object feeding the progress information to the progress indicator.
 
 // 任务进度管理对象
 */
@property (strong, nonatomic, nullable) NSProgress *progressObject;

/// @name Views

/**
 * The view containing the labels and indicator (or customView).
 //  MBBackgroundView的对象只可读
 */
@property (strong, nonatomic, readonly) MBBackgroundView *bezelView;

/**
 * View covering the entire HUD area, placed behind bezelView.
 
 //  MBBackgroundView的对象只可读
 */
@property (strong, nonatomic, readonly) MBBackgroundView *backgroundView;

/**
 * The UIView (e.g., a UIImageView) to be shown when the HUD is in MBProgressHUDModeCustomView.
 * The view should implement intrinsicContentSize for proper sizing. For best results use approximately 37 by 37 pixels.
 
 //MBProgressHUDModeCustomView模式下实现自定义view
 */
@property (strong, nonatomic, nullable) UIView *customView;

/**
 * A label that holds an optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
 * the entire text.
 
 // 短消息提示label，自动调整大小，只可读
 */
@property (strong, nonatomic, readonly) UILabel *label;

/**
 * A label that holds an optional details message displayed below the labelText message. The details text can span multiple lines.
 
 // 与上面的简短提示来说，这次提示就比较详细了，也是只可读
 */
@property (strong, nonatomic, readonly) UILabel *detailsLabel;

/**
 * A button that is placed below the labels. Visible only if a target / action is added.
 //单个任务是，耗时比较长时，可以设置一个取消按钮，取消此次任务。
 */
@property (strong, nonatomic, readonly) UIButton *button;

@end


@protocol MBProgressHUDDelegate <NSObject>

@optional

/** 
 * Called after the HUD was fully hidden from the screen.
 
 只有一个用于HUD隐藏时的回调方法：跟属性中completionBlock属性的block回调一样。
 */
- (void)hudWasHidden:(MBProgressHUD *)hud;

@end


/**！
 * 这是提供Determinate视图显示的类，有非圆环和圆环视图两种方式。
 */
/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 */
@interface MBRoundProgressView : UIView 

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Indicator progress color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic, strong) UIColor *progressTintColor;

/**
 * Indicator background (non-progress) color. 
 * Only applicable on iOS versions older than iOS 7.
 * Defaults to translucent white (alpha 0.1).
 */
@property (nonatomic, strong) UIColor *backgroundTintColor;

/*
 * Display mode - NO = round or YES = annular. Defaults to round.
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end


/**
 * A flat bar progress view.  这是提供进度条的视图类。
 */
@interface MBBarProgressView : UIView

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Bar border line color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 * Bar background color.
 * Defaults to clear [UIColor clearColor];
 */
@property (nonatomic, strong) UIColor *progressRemainingColor;

/**
 * Bar progress color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic, strong) UIColor *progressColor;

@end

/*！
 * MBBackgroundView背景视图
 */
@interface MBBackgroundView : UIView

/**
 * The background style. 
 * Defaults to MBProgressHUDBackgroundStyleBlur on iOS 7 or later and MBProgressHUDBackgroundStyleSolidColor otherwise.
 * @note Due to iOS 7 not supporting UIVisualEffectView, the blur effect differs slightly between iOS 7 and later versions.
 */
@property (nonatomic) MBProgressHUDBackgroundStyle style;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 || TARGET_OS_TV
/**
 * The blur effect style, when using MBProgressHUDBackgroundStyleBlur.
 * Defaults to UIBlurEffectStyleLight.
 */
@property (nonatomic) UIBlurEffectStyle blurEffectStyle;
#endif

/**
 * The background color or the blur tint color.
 * @note Due to iOS 7 not supporting UIVisualEffectView, the blur effect differs slightly between iOS 7 and later versions.
 */
@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
