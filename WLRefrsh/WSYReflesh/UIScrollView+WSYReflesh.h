//
//  UIScrollView+WSYReflesh.h
//  Sinllia_iPhone2.0
//
//  Created by 王声远 on 15/5/24.
//  Copyright (c) 2015年 王声远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSYRefleshHeaderView.h"
#import "WSYRefleshFooterView.h"

@interface UIScrollView (WSYReflesh)

- (void)addHeaderRefleshBlock:(HeaderRefleshBlock)block adjust:(WSYHeaderViewAdjust)height loadByStart:(BOOL)isStartLoad;
- (void) finishHeaderReflesh;

//主动刷新加载
- (void) startHeaderReflesh;

- (void)addFooterRefleshBlock:(FooterRefleshBlock)block;
- (void) finishFooterReflesh;
- (void)setFooterLoadAllDataFinishText;
- (void)setFooterLoadDataText;



@end
