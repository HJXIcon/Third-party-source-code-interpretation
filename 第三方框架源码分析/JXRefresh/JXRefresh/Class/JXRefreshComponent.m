//
//  JXRefreshComponent.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshComponent.h"
#import "JXRefreshConst.h"
#import "UIView+JXExtension.h"
#import "UIScrollView+JXExtension.h"

@interface JXRefreshComponent ()

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation JXRefreshComponent
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self prepare];
        // 默认是普通状态
        self.state = JXRefreshStateIdle;
    }
    
    return self;
}



- (void)layoutSubviews{
    [self placeSubviews];
    [super layoutSubviews];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.jx_width = newSuperview.jx_width;
        // 设置位置
        self.jx_x = -_scrollView.jx_insetL;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.jx_inset;
        
        // 添加监听
        [self addObservers];
    }
}

#pragma mark - *** Override Method
/** 初始化 */
- (void)prepare {
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}
/** 摆放子控件frame */
- (void)placeSubviews{}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}

#pragma mark - *** Public Method
#pragma mark 设置回调对象和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}
- (void)setState:(JXRefreshState)state{
    _state = state;
    // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

#pragma mark 进入刷新状态
- (void)beginRefreshing
{
    [UIView animateWithDuration:JXRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = JXRefreshStateRefreshing;
    } else {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.state != JXRefreshStateRefreshing) {
            self.state = JXRefreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}

- (void)beginRefreshingWithCompletionBlock:(void (^)(void))completionBlock{
    self.beginRefreshingCompletionBlock = completionBlock;
    [self beginRefreshing];
}

#pragma mark 结束刷新状态
- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = JXRefreshStateIdle;
    });
}

- (void)endRefreshingWithCompletionBlock:(void (^)(void))completionBlock{
    self.endRefreshingCompletionBlock = completionBlock;
    [self endRefreshing];
}

#pragma mark 是否正在刷新
- (BOOL)isRefreshing{
    return self.state == JXRefreshStateRefreshing || self.state == JXRefreshStateWillRefresh;
}

- (BOOL)isAutoChangeAlpha{
    return self.isAutomaticallyChangeAlpha;
}
- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha{
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    
    if (self.isRefreshing) return;
    if (automaticallyChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}
#pragma mark 根据拖拽进度设置透明度
- (void)setPullingPercent:(CGFloat)pullingPercent{
    _pullingPercent = pullingPercent;
    if (self.isRefreshing) return;
    if (self.isAutomaticallyChangeAlpha) {
        self.alpha = pullingPercent;
    }
}

#pragma mark - 内部方法
- (void)executeRefreshingCallback{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
    /*!
     我们定义一个方法只带参数，不带返回值：
     - (void)hasArguments:(NSString *)arg {
     NSLog(@"%s was called, and argument is %@", __FUNCTION__, arg);
     }
     
     然后尝试发送消息试试：
     // 3.调用带一个参数但无返回值的方法
     ((void (*)(id, SEL, NSString *))objc_msgSend)((id)msg, @selector(hasArguments:), @"带一个参数，但无返回值");
     同样，我们也是需要强转函数指针类型，否则会报错的。其实，只有调用runtime函数来发送消息，几乎都需要强转函数指针类型为合适的类型。
     */
        JXRefreshMsgSend(JXRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
        }
        if (self.beginRefreshingCompletionBlock) {
            self.beginRefreshingCompletionBlock();
        }
    });
}

#pragma mark - *** KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:JXRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:JXRefreshKeyPathContentSize options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:JXRefreshKeyPathPanState options:options context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:JXRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:JXRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:JXRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}



- (void)removeObservers{
    
    [self.superview removeObserver:self forKeyPath:JXRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:JXRefreshKeyPathContentSize];
    [self.pan removeObserver:self forKeyPath:JXRefreshKeyPathPanState];
    self.pan = nil;
}



@end

@implementation UILabel(JXRefresh)
+ (instancetype)jx_label
{
    UILabel *label = [[self alloc] init];
    label.font = JXRefreshLabelFont;
    label.textColor = JXRefreshLabelTextColor;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)jx_textWith {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringWidth =[self.text
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:self.font}
                      context:nil].size.width;
#else
        
        stringWidth = [self.text sizeWithFont:self.font
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByCharWrapping].width;
#endif
    }
    return stringWidth;
}
@end
