//
//  JXHUD.h
//  JXHUD
//
//  Created by HJXICon on 2018/2/26.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JXHUDMode) {
    /** 转圈动画模式，默认值 */
    JXHUDModeIndeterminate,
    /** 只显示标题 */
    JXHUDModeText
};

@interface JXHUD : UIView

@property (nonatomic, assign) JXHUDMode mode;
@property (nonatomic, strong) NSString *labelText;
- (instancetype)initWithView:(UIView *)view;

- (void)show;

- (void)hide;

@end
