
//  Sinllia_iPhone2.0
//
//  Created by 王声远 15-5-28.
//  Copyright (c) 2015年 王声远 All rights reserved.
//

#import "UIView+WSYExtension.h"

@implementation UIView (WSYExtension)
- (void)setWsy_x:(CGFloat)wsy_x
{
    CGRect frame = self.frame;
    frame.origin.x = wsy_x;
    self.frame = frame;
}

- (CGFloat)wsy_x
{
    return self.frame.origin.x;
}

- (void)setWsy_y:(CGFloat)wsy_y
{
    CGRect frame = self.frame;
    frame.origin.y = wsy_y;
    self.frame = frame;
}

- (CGFloat)wsy_y
{
    return self.frame.origin.y;
}

- (void)setWsy_w:(CGFloat)wsy_w
{
    CGRect frame = self.frame;
    frame.size.width = wsy_w;
    self.frame = frame;
}

- (CGFloat)wsy_w
{
    return self.frame.size.width;
}

- (void)setWsy_h:(CGFloat)wsy_h
{
    CGRect frame = self.frame;
    frame.size.height = wsy_h;
    self.frame = frame;
}

- (CGFloat)wsy_h
{
    return self.frame.size.height;
}

- (void)setWsy_size:(CGSize)wsy_size
{
    CGRect frame = self.frame;
    frame.size = wsy_size;
    self.frame = frame;
}

- (CGSize)wsy_size
{
    return self.frame.size;
}

- (void)setWsy_origin:(CGPoint)wsy_origin
{
    CGRect frame = self.frame;
    frame.origin = wsy_origin;
    self.frame = frame;
}

- (CGPoint)wsy_origin
{
    return self.frame.origin;
}
@end
