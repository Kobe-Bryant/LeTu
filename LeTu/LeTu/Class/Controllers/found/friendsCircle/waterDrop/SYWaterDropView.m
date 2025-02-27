//
//  SYWaterDropView.m
//
//
//  Created by ljh on 14-1-1.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import "SYWaterDropView.h"

@interface SYWaterDropView()
{
    float _minOffset;
    float _maxOffset;
    float _radius;
    BOOL _animationing;
    BOOL _isRefresh;
}

@property(strong,nonatomic)NSTimer* timer;
@end

@implementation SYWaterDropView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self cinit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self cinit];
    }
    return self;
}
-(BOOL)isRefreshing
{
    return _isRefresh;
}
-(void)cinit
{
    _maxOffset = 60;
    _radius = 3.5;
    
    CGRect frame = self.frame;
//    frame.size = CGSizeMake(30, 100);  //固定 30 * 100
    self.frame = frame;
    
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.fillColor = [UIColor colorWithRed:222./255. green:216./255. blue:211./255. alpha:0.5].CGColor;
    
    [self.layer addSublayer:_lineLayer];
    
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = [UIColor colorWithRed:222./255. green:216./255. blue:211./255. alpha:1].CGColor;
    _shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    _shapeLayer.lineWidth = 3;
    [self.layer addSublayer:_shapeLayer];
    
    self.currentOffset = 0;
}

-(CGMutablePathRef)createPathWithOffset:(float)currentOffset
{
    CGMutablePathRef path = CGPathCreateMutable();
    float top = self.frame.size.height - 20 - _radius*2 - currentOffset;
    float wdiff = currentOffset* 0.2;
    
    if(currentOffset==0)
    {
        CGPathAddEllipseInRect(path, NULL, CGRectMake(15-_radius, top, _radius*2, _radius*2));
    }
    else
    {
        CGPathAddArc(path, NULL, 15,top+_radius, _radius, 0, M_PI, YES);
        float bottom = top + wdiff+_radius*2;
        if(currentOffset<10)
        {
            CGPathAddCurveToPoint(path, NULL,15-_radius,bottom,15,bottom, 15,bottom);
            CGPathAddCurveToPoint(path, NULL, 15,bottom,15+_radius,bottom, 15+_radius, top+_radius);
        }
        else
        {
            CGPathAddCurveToPoint(path, NULL,15-_radius ,top +_radius, 15 - _radius ,bottom-2,15 , bottom);
            CGPathAddCurveToPoint(path,NULL, 15 + _radius, bottom-2, 15+_radius,top +_radius , 15+_radius, top+_radius);
        }
    }
    CGPathCloseSubpath(path);
    
    return path;
}
-(void)setCurrentOffset:(float)currentOffset
{
    if(_isRefresh)
        return;
    
    [self privateSetCurrentOffset:currentOffset];
}
-(void)privateSetCurrentOffset:(float)currentOffset
{
    currentOffset = currentOffset>0?0:currentOffset;
    currentOffset = -currentOffset;
    _currentOffset =  currentOffset;
    if(currentOffset < _maxOffset)
    {
        float wdiff = currentOffset* 0.2;
        float top = self.frame.size.height - 20 - _radius*2 - currentOffset;
        
        CGMutablePathRef path = [self createPathWithOffset:currentOffset];
        _shapeLayer.path = path;
        CGPathRelease(path);
        
        
        CGMutablePathRef line = CGPathCreateMutable();
        float w = ((_maxOffset - currentOffset)/_maxOffset) + 1;
        CGPathAddRect(line, NULL, CGRectMake(15-w/2, top + wdiff + _radius*2,w, currentOffset-wdiff+20));
        _lineLayer.path = line;
        
        self.transform = CGAffineTransformMakeScale(0.8+0.2*(w-1), 1);
    }
    else
    {
        if(self.timer == nil)
        {
            _isRefresh = YES;
            self.transform = CGAffineTransformIdentity;
            self.timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(resetWater) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            [_timer fire];
        }
    }
}
-(void)resetWater
{
    [self privateSetCurrentOffset:-(_currentOffset-(_maxOffset/8))];
    if(_currentOffset==0)
    {
        [self.timer invalidate];
        self.timer = nil;
        
        if(self.handleRefreshEvent!= nil)
        {
            self.handleRefreshEvent();
        }
        [self startRefreshAnimation];
    }
}
-(void)stopRefresh
{
    _isRefresh = NO;
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @(1);
    anim.toValue = @(0);
    anim.duration = 0.2;
    anim.delegate = self;
    [_refreshView.layer addAnimation:anim forKey:nil];
    _refreshView.layer.opacity = 0;
    

    anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @(0);
    anim.toValue = @(1);
    anim.beginTime = 0.2;
    anim.duration = 0.2;
    anim.delegate = self;
    [_shapeLayer addAnimation:anim forKey:nil];
    _shapeLayer.opacity = 0;
}
-(void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    if(anim.beginTime > 0)
    {
        _shapeLayer.opacity = 1;
    }
    else
    {
        [_refreshView.layer removeAllAnimations];
    }
}
-(void)startRefreshAnimation
{
    if(self.refreshView == nil)
    {
        self.refreshView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"first_timetowlight"]];
        [self addSubview:_refreshView];
    }
    _shapeLayer.opacity = 0;
    
    _refreshView.center = CGPointMake(15,self.frame.size.height - 20 - _radius);
    [_refreshView.layer removeAllAnimations];
    _refreshView.layer.opacity = 1;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1;
    animation.fromValue = @0;
    animation.toValue = @(M_PI*2);
    animation.repeatCount = INT_MAX;
    
    [_refreshView.layer addAnimation:animation forKey:@"rotation"];
}
@end
