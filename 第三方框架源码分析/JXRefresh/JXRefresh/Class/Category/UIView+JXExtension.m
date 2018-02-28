//
//  UIView+Jx_Extension.m
//  LokiUnionSDK
//
//  Created by HJXICon on 2018/2/11.
//  Copyright © 2018年 junhai. All rights reserved.
//

#import "UIView+JXExtension.h"

@implementation UIView (JXExtension)

- (void)setJx_x:(CGFloat)jx_x{
    CGRect frame = self.frame;
    frame.origin.x = jx_x;
    self.frame = frame;
}
- (CGFloat)jx_x{
    return self.frame.origin.x;
}

- (void)setJx_y:(CGFloat)jx_y{
    CGRect frame = self.frame;
    frame.origin.y = jx_y;
    self.frame = frame;
}

- (CGFloat)jx_y{
     return self.frame.origin.y;
}

- (void)setJx_width:(CGFloat)jx_width{
    CGRect frame = self.frame;
    frame.size.width = jx_width;
    self.frame = frame;
}
- (CGFloat)jx_width{
    return self.frame.size.width;
}

- (void)setJx_height:(CGFloat)jx_height{
    CGRect frame = self.frame;
    frame.size.height = jx_height;
    self.frame = frame;
}
- (CGFloat)jx_height{
     return self.frame.size.height;
}

- (void)setJx_size:(CGSize)jx_size{
    CGRect frame = self.frame;
    frame.size = jx_size;
    self.frame = frame;
}
- (CGSize)jx_size{
    return self.frame.size;
}
- (void)setJx_origin:(CGPoint)jx_origin{
    CGRect frame = self.frame;
    frame.origin = jx_origin;
    self.frame = frame;
}
- (CGPoint)jx_origin{
    return self.frame.origin;
}

- (void)setJx_centerX:(CGFloat)jx_centerX{
    CGPoint center = self.center;
    center.x = jx_centerX;
    self.center = center;
}

- (CGFloat)jx_centerX{
     return self.center.x;
}

- (void)setJx_centerY:(CGFloat)jx_centerY{
    CGPoint center = self.center;
    center.y = jx_centerY;
    self.center = center;
}
- (CGFloat)jx_centerY{
    return self.center.y;
}

- (void)setJx_cornerRadius:(CGFloat)jx_cornerRadius{
    self.layer.cornerRadius = jx_cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)jx_cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setJx_borderWidth:(CGFloat)jx_borderWidth{
    self.layer.borderWidth = jx_borderWidth;
}
- (CGFloat)jx_borderWidth{
    return self.layer.borderWidth;
}

- (void)setJx_borderColor:(CGColorRef)jx_borderColor{
    self.layer.borderColor = jx_borderColor;
}
- (CGColorRef)jx_borderColor{
    return self.layer.borderColor;
}
@end
