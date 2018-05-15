//
//  JXSegmentPageHeader.m
//  JXSegmentPager
//
//  Created by HJXICon on 2018/5/14.
//  Copyright © 2018年 beiyugame. All rights reserved.
//

#import "JXSegmentPageHeader.h"

@interface JXSegmentPageHeader()

@property(nonatomic, strong) NSLayoutConstraint *imageTopConstraint;
@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation JXSegmentPageHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self _setup];
    }
    return self;
}

- (void)_setup{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"listdownload.jpg"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self addSubview:self.imageView];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self
     addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                attribute:NSLayoutAttributeLeft
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                attribute:NSLayoutAttributeLeft
                                               multiplier:1
                                                 constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.imageView
                         attribute:NSLayoutAttributeRight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeRight
                         multiplier:1
                         constant:0]];
    self.imageTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    [self addConstraint:self.imageTopConstraint];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:self.imageView
                         attribute:NSLayoutAttributeBottom
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeBottom
                         multiplier:1
                         constant:0]];
}

#pragma mark - *** JXSegmentPageHeaderProtocol
- (UIImageView *)backgroundImageView{
    return _imageView;
}

@end
