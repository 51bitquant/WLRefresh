//
//  WSYRefleshFooterView.m
//  WSYRefleshDemo
//
//  Created by 王声远 on 15/5/28.
//  Copyright (c) 2015年 王声远. All rights reserved.

#import "WSYRefleshFooterView.h"
#import "WSYRefleshConst.h"
#import "UIScrollView+WSYExtension.h"

@interface WSYRefleshFooterView()

@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UIImageView *img;
@property (nonatomic,assign,getter=isUpToStart) BOOL upToStart;
@property (nonatomic,assign) CGFloat currentSecond;

@end

@implementation WSYRefleshFooterView

+ (instancetype)initWithScrollView:(UIScrollView *)scrollView AndBlock:(FooterRefleshBlock)block
{
    return [[self alloc] initSuperView:scrollView AndBlock:block];
}

- (instancetype)initSuperView:(UIScrollView *)scrollView AndBlock:(FooterRefleshBlock)block
{
    self = [super init];
    if (self) {
        
        self.orginScrollView = scrollView;
        self.block = block;
        self.orginInsets = scrollView.contentInset;
        
        //添加文字说明
        UILabel *title = [[UILabel alloc] init];
        [self addSubview:title];
        [title setText:WSYRefleshFooterLoadMore];
        [title setTextColor:[UIColor blackColor]];
        title.alpha = 0.5;
        [title setFont:[UIFont boldSystemFontOfSize:14]];
        title.textAlignment = NSTextAlignmentCenter;
        self.title = title;
        self.backgroundColor = [UIColor whiteColor];
        
        //添加英文
        UIImageView *img = [[UIImageView alloc] init];
        [self addSubview:img];
        self.img = img;
        self.img.image = [UIImage imageNamed:@"refleshfooterimage"];
        
        [self.orginScrollView addSubview:self];
        
        self.backgroundColor = [UIColor clearColor];
        
        _statusType = WSYRefleshFooterStatusNormal;
        _loadAllDataText = WSYRefleshFooterLoadMore;
        
        [self.img setTransform:CGAffineTransformMakeRotation(M_PI)];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0,  self.orginScrollView.contentSize.height, self.orginScrollView.frame.size.width, kFooterHeight);
    
    CGFloat width = self.frame.size.width;
    CGFloat titleW = 120;
    CGFloat titleHeight = 15;
    CGFloat imgWith = 25;
    CGFloat imgHeight = 25;
    
    [self.title setFrame:CGRectMake((width - titleW) * 0.5, (kFooterHeight - titleHeight) * 0.5-5, titleW, titleHeight)];
    
    [self.img setFrame:CGRectMake(CGRectGetMinX(self.title.frame) - imgWith+5, (kFooterHeight - titleHeight) * 0.5-5, imgWith, imgHeight)];
    CGPoint center = self.title.center;
    center.x = self.img.frame.origin.x;
    [self.img setCenter:center];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    self.hidden = [self needsToHide];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGPoint currentOffset = [change[@"new"] CGPointValue];
    
    CGFloat upY = currentOffset.y + self.orginScrollView.frame.size.height - self.orginScrollView.contentSize.height;
    
    self.hidden = [self needsToHide];
    
    if (upY > kFooterHeight && !self.hidden) {
        if (!self.isUpToStart) {
            self.upToStart = YES;
            [self setStatusType:WSYRefleshFooterStatusLoading];
        }
    }
}

- (BOOL)needsToHide
{
    BOOL hi = self.orginScrollView.contentSize.height < self.orginScrollView.frame.size.height;
    if (!hi) {
        self.frame = CGRectMake(0,  self.orginScrollView.contentSize.height, self.orginScrollView.frame.size.width, kFooterHeight);
    }
    return hi;
}


- (void)setStatusType:(WSYRefleshFooterStatusType)statusType
{
    if(statusType == WSYRefleshFooterStatusLoading)
    {
        if (_statusType == WSYRefleshFooterStatusLoading) {
            return;
        }
        _statusType = statusType;
        
        self.currentSecond = [self getCurrentSecond];
        
        if([self.loadAllDataText isEqualToString:WSYRefleshFooterAllReloaded]){
            self.title.text = WSYRefleshFooterAllReloaded;
            return;
        }
        else
        {
            self.title.text = WSYRefleshFooterLoadMore;
        }
        
        [self rotationImage];

        [UIView animateWithDuration:0.3 animations:^{
            [self.orginScrollView setWsy_insetB:kFooterHeight+self.orginInsets.bottom];
        }];
        
        if (self.block) {
            self.block();
        }
    }
}

- (void)finishReflesh
{
    NSTimeInterval tempSecond = [self getCurrentSecond];
    NSTimeInterval t = tempSecond - self.currentSecond;
    if (t >= minimumTime) {
        [self finishProcess];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((minimumTime - t) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self finishProcess];
        });
    }
}

- (void)finishProcess
{
    self.frame = CGRectMake(0,  self.orginScrollView.contentSize.height, self.orginScrollView.frame.size.width, kFooterHeight);
    [UIView animateWithDuration:0.3 animations:^{
        [self.orginScrollView setWsy_insetB:(kFooterHeight + self.orginInsets.bottom)];
    } completion:^(BOOL finished) {
        self.title.text = self.loadAllDataText;
        [self.img.layer removeAllAnimations];
        [self.img setTransform:CGAffineTransformMakeRotation(M_PI)];
        _statusType = WSYRefleshFooterStatusNormal;
        self.upToStart = NO;
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
    [self.img.layer addAnimation:rotationAnimation forKey:nil];
}

- (NSTimeInterval)getCurrentSecond
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval second =[dat timeIntervalSince1970];
    return second;
}

- (void)setLoadAllDataText:(NSString *)loadAllDataText
{
    _loadAllDataText = loadAllDataText;
    
    if ([loadAllDataText isEqualToString:WSYRefleshFooterAllReloaded]) {
        self.img.hidden = YES;
    }
    else
    {
        self.img.hidden = NO;
    }
}

@end
