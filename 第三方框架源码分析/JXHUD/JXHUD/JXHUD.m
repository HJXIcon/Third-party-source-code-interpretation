//
//  JXHUD.m
//  JXHUD
//
//  Created by HJXICon on 2018/2/26.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXHUD.h"

#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

static CGFloat const kMargin = 20;
static CGFloat const kPadding = 4;

@interface JXHUD()

@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic) CGSize size;
@end

@implementation JXHUD

- (void)dealloc {
    [self unregisterFromKVO];
}

- (instancetype)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}

// 自身初始化，设置组件默认属性，更新布局，注册kvo监视属性变化。
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _mode = JXHUDModeIndeterminate;
        _labelText = nil;
        _size = CGSizeZero;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        
        [self setupView];
        [self updateIndicators];
        [self registerForKVO];
    }
    return self;
}

-(void)show {
    self.alpha = 1;
}

-(void)hide {
    self.alpha = 0;
    [self removeFromSuperview];
}

- (void)setupView {
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.adjustsFontSizeToFitWidth = NO;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.text = self.labelText;
    [self addSubview:_label];
}


// 初始化转圈动画，并添加到hud上，ZCJHUDModeIndeterminate模式才有这个动画
- (void)updateIndicators {
    
    BOOL isActivityIndicator = [_indicator isKindOfClass:[UIActivityIndicatorView class]];
    
    if (_mode == JXHUDModeIndeterminate) {
        if (!isActivityIndicator) {
            // Update to indeterminate indicator
            [_indicator removeFromSuperview];
            self.indicator = ([[UIActivityIndicatorView alloc]
                               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
            [(UIActivityIndicatorView *)_indicator startAnimating];
            [self addSubview:_indicator];
        }
    } else if (_mode == JXHUDModeText) {
        [_indicator removeFromSuperview];
        self.indicator = nil;
    }
}


// 这里使用了frame动态布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 覆盖整个视图，屏蔽交互操作
    UIView *parent = self.superview;
    if (parent) {
        self.frame = parent.bounds;
    }
    CGRect bounds = self.bounds;
    
    
    CGFloat maxWidth = bounds.size.width - 4 * kMargin;
    /// 总size
    CGSize totalSize = CGSizeZero;
    
    CGRect indicatorF = _indicator.bounds;
    indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
    totalSize.width = MAX(totalSize.width, indicatorF.size.width);
    totalSize.height += indicatorF.size.height;
    
    CGSize labelSize = MB_TEXTSIZE(_label.text, _label.font);
    labelSize.width = MIN(labelSize.width, maxWidth);
    totalSize.width = MAX(totalSize.width, labelSize.width);
    totalSize.height += labelSize.height;
    if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
        totalSize.height += kPadding;
    }
    
    totalSize.width += 2 * kMargin;
    totalSize.height += 2 * kMargin;
    
    // Position elements
    CGFloat yPos = round(((bounds.size.height - totalSize.height) / 2)) + kMargin;
    CGFloat xPos = 0;
    indicatorF.origin.y = yPos;
    indicatorF.origin.x = round((bounds.size.width - indicatorF.size.width) / 2) + xPos;
    _indicator.frame = indicatorF;
    yPos += indicatorF.size.height;
    
    if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
        yPos += kPadding;
    }
    CGRect labelF;
    labelF.origin.y = yPos;
    labelF.origin.x = round((bounds.size.width - labelSize.width) / 2) + xPos;
    labelF.size = labelSize;
    _label.frame = labelF;
    
    _size = totalSize;
}

// 绘制背景框
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    
    CGContextSetGrayFillColor(context, 0.0f, 0.8);
    
    // Center HUD
    CGRect allRect = self.bounds;
    // Draw rounded HUD backgroud rect
    CGRect boxRect = CGRectMake(round((allRect.size.width - _size.width) / 2),
                                round((allRect.size.height - _size.height) / 2) , _size.width, _size.height);
    float radius = 10;
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    UIGraphicsPopContext();
}

#pragma mark - KVO
// kvo监控属性变化，使用者在修改属性时，触发页面刷新，赋上新值。注意在页面销毁时要取消kvo监控，否则程序会崩溃
- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"mode", @"labelText", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"mode"]) {
        [self updateIndicators];
    } else if ([keyPath isEqualToString:@"labelText"]) {
        _label.text = self.labelText;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
}



@end
