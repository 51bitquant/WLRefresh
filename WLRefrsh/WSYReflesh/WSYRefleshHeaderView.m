//
//  WSYRefleshHeaderView.m
//  Sinllia_iPhone2.0
//
//  Created by 王声远 on 15/5/24.
//  Copyright (c) 2015年 王声远. All rights reserved.
//

#import "WSYRefleshHeaderView.h"
#import "WSYRefleshConst.h"
#import "UIView+WSYExtension.h"
#import "UIScrollView+WSYExtension.h"

@interface WSYRefleshHeaderView()

@property (nonatomic,weak) UIImageView *footerImg;
@property (nonatomic,weak) UIImageView *headerImg;

@property (nonatomic,assign,getter=isUpToStart) BOOL upToStart;
@property (nonatomic,assign) double currentSecond;

@property (nonatomic,assign) BOOL startLoad;

@end

@implementation WSYRefleshHeaderView

+ (instancetype)shareWithScrollView:(UIScrollView *)scrollView AndBlock:(HeaderRefleshBlock)block andAdjust:(WSYHeaderViewAdjust)height loadByStart:(BOOL)isStartLoad
{
    return [[self alloc] initSuperView:scrollView AndBlock:block andAdjust:height loadByStart:isStartLoad];
}

- (instancetype)initSuperView:(UIScrollView *)scrollView AndBlock:(HeaderRefleshBlock)block andAdjust:(WSYHeaderViewAdjust)height loadByStart:(BOOL)isStartLoad
{
    self = [super init];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        self.orginScrollView = scrollView;
        
        //self.orginInsets = self.orginScrollView.contentInset;
        UIScrollView *myView = [[UIScrollView alloc] init];
        [myView setContentInset:self.orginScrollView.contentInset];
        [myView setWsy_insetT:height];
        self.orginInsets = myView.contentInset;
        
//        if(self.orginScrollView.frame.origin.y < 64){
//            UIScrollView *myView = [[UIScrollView alloc] init];
//            [myView setContentInset:self.orginScrollView.contentInset];
//            [myView setWsy_insetT:64];
//            self.orginInsets = myView.contentInset;
//        }
        
        //添加尾部图片
        UIImageView *headerImg = [[UIImageView alloc] init];
        [self addSubview:headerImg];
        self.headerImg = headerImg;
        self.headerImg.image = [UIImage imageNamed:@"refleshheaderimage"];
        
        //添加尾部图片
        UIImageView *footerImg = [[UIImageView alloc] init];
        [self addSubview:footerImg];
        self.footerImg = footerImg;
        self.footerImg.image = [UIImage imageNamed:@"refleshfooterimage"];
        
        [self.orginScrollView addSubview:self];
        
        self.statusType = WSYRefleshHeaderStatusTypeNormal;
        
        self.block = block;
        
        if (isStartLoad) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startReflesh];
            });
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.frame = CGRectMake(0,  -kHeaderHeight, self.orginScrollView.frame.size.width, kHeaderHeight);
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat footerfooterImgWith = 30;
    CGFloat footerfooterImgHeight = 30;
    
    CGFloat headerImgWidth = 109;
    CGFloat headerImgHeight = 65;
    
    [self.footerImg setFrame:CGRectMake((width - footerfooterImgWith) * 0.5, height - footerfooterImgHeight, footerfooterImgWith, footerfooterImgHeight)];
    
    [self.headerImg setFrame:CGRectMake((width - headerImgWidth) * 0.5, CGRectGetMinY(self.footerImg.frame)-headerImgHeight + 5, headerImgWidth, headerImgHeight)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGPoint currentOffset = [change[@"new"] CGPointValue];
    
    if (_statusType == WSYRefleshHeaderStatusTypeLoading) {
        return;
    }
    
    if (self.orginScrollView.isDragging)
    {
        if (currentOffset.y <= -kHeaderHeight)//到达刷新临界点
        {
            if (!self.isUpToStart) {
                self.upToStart = YES;
                [UIView animateWithDuration:0.3f animations:^{
                    [self.footerImg setTransform:CGAffineTransformMakeRotation(M_PI)];
                }];
            }
        }
        else//没有到达临界点
        {
            if (self.isUpToStart) {
                self.upToStart = NO;
                [UIView animateWithDuration:0.3f animations:^{
                    [self.footerImg setTransform:CGAffineTransformMakeRotation(0)];
                }];
            }
        }
        return;
    }
    
    if (self.isUpToStart)
    {
        self.upToStart = NO;
        [self setStatusType:WSYRefleshHeaderStatusTypeLoading];
    }
}

- (void)setStatusType:(WSYRefleshHeaderStatusType)statusType
{
    if(statusType == WSYRefleshHeaderStatusTypeLoading)
    {
        if(_statusType == WSYRefleshHeaderStatusTypeLoading) return;
        _statusType = statusType;
        
        self.currentSecond = [self getCurrentSecond];
        
        [self rotationImage];
        
        CGFloat offset = MAX(self.orginScrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, kHeaderHeight);
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.orginScrollView setWsy_insetT:offset+self.orginInsets.top];
        }];
        
        if (self.block) {
            self.block();
        }
    }
    _statusType = statusType;
}

//启动界面后开始刷新加载数据
- (void)startReflesh
{
    self.upToStart = NO;
    _statusType = WSYRefleshHeaderStatusTypeLoading;
        
    self.currentSecond = [self getCurrentSecond];
    [self rotationImage];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.orginScrollView setWsy_offsetY:-kHeaderHeight];
        [self.orginScrollView setWsy_insetT:self.orginInsets.top+kHeaderHeight];
    }];
    
    if (self.block) {
        self.block();
    }
}

//结束刷新
- (void)finishReflesh
{
    NSTimeInterval tempSecond = [self getCurrentSecond];
    NSTimeInterval t = tempSecond - self.currentSecond;
    
    if (t >= minimumTime) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:(^{
            [self finishProcess];
        })];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((minimumTime - t) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self finishProcess];
        });
    }
}

- (void) finishProcess
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.orginScrollView setWsy_insetT:self.orginInsets.top];
    } completion:^(BOOL finished) {
        self.upToStart = NO;
        [self.footerImg setTransform:CGAffineTransformMakeRotation(0)];
        [self.footerImg.layer removeAllAnimations];
        _statusType = WSYRefleshHeaderStatusTypeNormal;
    }];
}

- (void)rotationImage
{
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 300];
    rotationAnimation.repeatCount = 1;
    rotationAnimation.duration = 150.0f;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.footerImg.layer addAnimation:rotationAnimation forKey:nil];
}

- (NSTimeInterval)getCurrentSecond
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval second =[dat timeIntervalSince1970];
    return second;
}

@end
