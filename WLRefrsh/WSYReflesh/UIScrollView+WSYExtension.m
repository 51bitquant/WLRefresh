
//  Sinllia_iPhone2.0
//
//  Created by 王声远 15-5-28.
//  Copyright (c) 2015年 王声远 All rights reserved.
//

#import "UIScrollView+WSYExtension.h"

@implementation UIScrollView (WSYExtension)

- (void)setWsy_insetT:(CGFloat)wsy_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = wsy_insetT;
    self.contentInset = inset;
}

- (CGFloat)wsy_insetT
{
    return self.contentInset.top;
}

- (void)setWsy_insetB:(CGFloat)wsy_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = wsy_insetB;
    self.contentInset = inset;
}

- (CGFloat)wsy_insetB
{
    return self.contentInset.bottom;
}

- (void)setWsy_insetL:(CGFloat)wsy_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = wsy_insetL;
    self.contentInset = inset;
}

- (CGFloat)wsy_insetL
{
    return self.contentInset.left;
}

- (void)setWsy_insetR:(CGFloat)wsy_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = wsy_insetR;
    self.contentInset = inset;
}

- (CGFloat)wsy_insetR
{
    return self.contentInset.right;
}

- (void)setWsy_offsetX:(CGFloat)wsy_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = wsy_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)wsy_offsetX
{
    return self.contentOffset.x;
}

- (void)setWsy_offsetY:(CGFloat)wsy_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = wsy_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)wsy_offsetY
{
    return self.contentOffset.y;
}

- (void)setWsy_contentSizeW:(CGFloat)wsy_contentSizeW
{
    CGSize size = self.contentSize;
    size.width = wsy_contentSizeW;
    self.contentSize = size;
}

- (CGFloat)wsy_contentSizeW
{
    return self.contentSize.width;
}

- (void)setWsy_contentSizeH:(CGFloat)wsy_contentSizeH
{
    CGSize size = self.contentSize;
    size.height = wsy_contentSizeH;
    self.contentSize = size;
}

- (CGFloat)wsy_contentSizeH
{
    return self.contentSize.height;
}
@end
