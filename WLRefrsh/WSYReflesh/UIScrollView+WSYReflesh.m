//
//  UIScrollView+WSYReflesh.m
//  Sinllia_iPhone2.0
//
//  Created by 王声远 on 15/5/24.
//  Copyright (c) 2015年 王声远. All rights reserved.
//

#import "UIScrollView+WSYReflesh.h"
#import <objc/runtime.h>
#import "WSYRefleshConst.h"

static char headerKey;
static char footerKey;

@interface UIScrollView()

@property (nonatomic,weak) WSYRefleshHeaderView *header;
@property (nonatomic,weak) WSYRefleshFooterView *footer;

@end

@implementation UIScrollView (WSYReflesh)

//下拉刷新
- (void)addHeaderRefleshBlock:(HeaderRefleshBlock)block adjust:(WSYHeaderViewAdjust)height loadByStart:(BOOL)isStartLoad
{
    if (!self.header) {
        WSYRefleshHeaderView *header = [WSYRefleshHeaderView shareWithScrollView:self AndBlock:block andAdjust:height loadByStart:isStartLoad];
        self.header = header;
    }
    self.header.block = block;
}

- (void)setHeader:(WSYRefleshHeaderView *)header
{
    [self willChangeValueForKey:@"headerKey"];
    objc_setAssociatedObject(self, &headerKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"headerKey"];
}

- (WSYRefleshHeaderView *)header
{
    return objc_getAssociatedObject(self, &headerKey);
}

- (void) finishHeaderReflesh
{
    [self.header finishReflesh];
}

- (void) startHeaderReflesh
{
    [self.header startReflesh];
}

//上拉刷新
- (void)addFooterRefleshBlock:(FooterRefleshBlock)block
{
    if (!self.footer) {
        WSYRefleshFooterView *footer = [WSYRefleshFooterView initWithScrollView:self AndBlock:block];
        self.footer = footer;
    }
    self.footer.block = block;
}

- (void)setFooter:(WSYRefleshFooterView *)footer
{
    [self willChangeValueForKey:@"footerKey"];
    objc_setAssociatedObject(self, &footerKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"footerKey"];
}

- (WSYRefleshFooterView *)footer
{
    return objc_getAssociatedObject(self, &footerKey);
}

- (void)setFooterLoadAllDataFinishText
{
    [self.footer setLoadAllDataText:WSYRefleshFooterAllReloaded];
}

- (void)setFooterLoadDataText
{
    [self.footer setLoadAllDataText:WSYRefleshFooterNormalLabel];
}

- (void) finishFooterReflesh
{
    [self.footer finishReflesh];
}


@end
