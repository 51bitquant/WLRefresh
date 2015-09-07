//
//  WSYRefleshFooterView.h
//  WSYRefleshDemo
//
//  Created by 王声远 on 15/5/28.
//  Copyright (c) 2015年 王声远. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WSYRefleshFooterStatusType){
    WSYRefleshFooterStatusNormal = 0,
    WSYRefleshFooterStatusPulling,
    WSYRefleshFooterStatusLoading
};

typedef void (^FooterRefleshBlock)();

@interface WSYRefleshFooterView : UIView

@property (nonatomic,weak) UIScrollView *orginScrollView;
@property (nonatomic,assign) UIEdgeInsets orginInsets;

@property (nonatomic,weak) NSString *loadAllDataText;

+ (instancetype)initWithScrollView:(UIScrollView *)scrollView AndBlock:(FooterRefleshBlock)block;

@property (nonatomic,copy) FooterRefleshBlock block;

@property (nonatomic,assign) WSYRefleshFooterStatusType statusType;

- (void)finishReflesh;

@end
