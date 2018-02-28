//
//  JXRefreshStateHeader.m
//  JXRefresh
//
//  Created by HJXICon on 2018/2/28.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXRefreshStateHeader.h"
#import "JXRefreshConst.h"
#import "UIView+JXExtension.h"
#import "NSBundle+JXRefresh.h"

@interface JXRefreshStateHeader(){
    /** 显示上一次刷新时间的label */
    __unsafe_unretained UILabel *_lastUpdatedTimeLabel;
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation JXRefreshStateHeader

#pragma mark - *** lazy load
- (NSMutableDictionary *)stateTitles{
    if (_stateTitles == nil) {
        _stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel jx_label]];
    }
    return _stateLabel;
}

- (UILabel *)lastUpdatedTimeLabel{
    if (!_lastUpdatedTimeLabel) {
        [self addSubview:_lastUpdatedTimeLabel = [UILabel jx_label]];
    }
    return _lastUpdatedTimeLabel;
}

#pragma mark - *** Public Method
- (void)setTitle:(NSString *)title forState:(JXRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}


#pragma mark key的处理
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    // 如果label隐藏了，就不用再处理
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [self currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        BOOL isToday = NO;
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @" HH:mm";
            isToday = YES;
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@%@",
                                          [NSBundle jx_localizedStringForKey:JXRefreshHeaderLastTimeText],
                                          isToday ? [NSBundle jx_localizedStringForKey:JXRefreshHeaderDateTodayText] : @"",
                                          time];
        
    } else {
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",
                                          [NSBundle  jx_localizedStringForKey:JXRefreshHeaderLastTimeText],
                                          [NSBundle  jx_localizedStringForKey:JXRefreshHeaderNoneLastDateText]];
    }
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = JXRefreshLabelLeftInset;
    
    // 初始化文字
    [self setTitle:[NSBundle jx_localizedStringForKey:JXRefreshHeaderIdleText] forState:JXRefreshStateIdle];
    [self setTitle:[NSBundle jx_localizedStringForKey:JXRefreshHeaderPullingText] forState:JXRefreshStatePulling];
    [self setTitle:[NSBundle jx_localizedStringForKey:JXRefreshHeaderRefreshingText] forState:JXRefreshStateRefreshing];
}


- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    // stateLabel
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态  如果lastUpdatedTimeLabel不显示，_stateLabel垂直居中显示
        if (noConstrainsOnStatusLabel) {
            [self addStateLabelConstraint:YES];
        }
        
    } else {
        
        [self addStateLabelConstraint:NO];
        
        // 更新时间
        if (self.lastUpdatedTimeLabel.constraints.count == 0) {
            [self addLastUpdatedTimeLabelConstraint];
        }
    }
}

- (void)setState:(JXRefreshState)state
{
    JXRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 重新设置key（重新显示时间）
    self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
}

#pragma mark - *** SubViews Constraint
- (void)addLastUpdatedTimeLabelConstraint{
    /// LastUpdatedTimeLabel
    self.lastUpdatedTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_stateLabel,_lastUpdatedTimeLabel);
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_lastUpdatedTimeLabel]-|" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_lastUpdatedTimeLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_stateLabel]-[_lastUpdatedTimeLabel(==_stateLabel)]" options:0 metrics:nil views:views]];
}
- (void)addStateLabelConstraint:(BOOL)isCenterY{
    /// _stateLabel
    self.stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_stateLabel);
    NSDictionary *metrics = @{@"width":@(JXRefreshStateLabelWidth)};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_stateLabel(width)]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_stateLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    if (!isCenterY){
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_stateLabel]" options:0 metrics:nil views:views]];
    }
    else{
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_stateLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
    }
    
    
}

@end
