//
//  WSYRefleshHeaderView.h
//  Sinllia_iPhone2.0
//
//  Created by 王声远 on 15/5/24.
//  Copyright (c) 2015年 王声远. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSYRefleshHeaderView;

typedef NS_ENUM(NSInteger, WSYRefleshHeaderStatusType){
    WSYRefleshHeaderStatusTypeNormal = 0,
    WSYRefleshHeaderStatusTypePulling,
    WSYRefleshHeaderStatusTypeLoading
};

typedef NS_ENUM(NSInteger, WSYHeaderViewAdjust) {
    WSYHeaderViewAdjustDefault = 0,
    WSYHeaderViewAdjustDetail = 64
};

typedef void (^HeaderRefleshBlock)();

@interface WSYRefleshHeaderView : UIView

@property (nonatomic,weak) UIScrollView *orginScrollView;
@property (nonatomic,assign) UIEdgeInsets orginInsets;

@property (nonatomic,assign) CGFloat orginInset_top;

+ (instancetype)shareWithScrollView:(UIScrollView *)scrollView AndBlock:(HeaderRefleshBlock)block andAdjust:(WSYHeaderViewAdjust)height loadByStart:(BOOL)isStartLoad;

@property (nonatomic,assign) WSYRefleshHeaderStatusType statusType;

@property (nonatomic,copy) HeaderRefleshBlock block;

- (void)finishReflesh;

- (void)startReflesh;

@end
