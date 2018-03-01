//
//  JXRefreshStateFooter.m
//  JXRefresh
//
//  Created by HJXICon on 2018/3/1.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshAutoStateFooter.h"
#import "JXRefreshConst.h"
#import "NSBundle+JXRefresh.h"

@interface JXRefreshAutoStateFooter (){
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@end

@implementation JXRefreshAutoStateFooter

#pragma mark - *** lazy load
- (NSMutableDictionary *)stateTitles
{
    if (_stateTitles == nil) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel{
    if (_stateLabel == nil) {
        [self addSubview:_stateLabel = [UILabel jx_label]];
    }
    return _stateLabel;
}

#pragma mark - *** Public Method
- (void)setTitle:(NSString *)title forState:(JXRefreshState)state{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - *** Override Method
- (void)prepare{
    [super prepare];
    // 初始化间距
    self.labelLeftInset = JXRefreshLabelLeftInset;
    
    // 初始化文字
    [self setTitle:[NSBundle jx_localizedStringForKey:JXRefreshAutoFooterIdleText] forState:JXRefreshStateIdle];
    [self setTitle:[NSBundle jx_localizedStringForKey:JXRefreshAutoFooterRefreshingText] forState:JXRefreshStateRefreshing];
    [self setTitle:[NSBundle jx_localizedStringForKey:JXRefreshAutoFooterNoMoreDataText] forState:JXRefreshStateNoMoreData];
    
    // 监听label
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.stateLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.stateLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
     [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.stateLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    if (self.isRefreshingTitleHidden && state == JXRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}


#pragma mark - *** Actions
- (void)stateLabelClick{
    if (self.state == JXRefreshStateIdle) {
        [self beginRefreshing];
    }
}

@end







