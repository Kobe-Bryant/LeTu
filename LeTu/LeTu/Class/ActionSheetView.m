//
//  ActionSheetView.m
//  LeTu
//
//  Created by mafeng on 14-9-24.
//
//

#import "ActionSheetView.h"

#define duration 0.55

#define sideViewDamping 0.87
#define sideViewVelocity 10

#define centerViewDamping 1.0
#define centerViewVelocity 8


@interface ActionSheetView()
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,strong)  UIColor* backColor;
@property(nonatomic,assign) BOOL showSheet;
@property(nonatomic,strong) UIView* sideHelperView;
@property(nonatomic,strong) UIView* centerHelperView;
@property(nonatomic,strong) CADisplayLink *displayLink;
@property(nonatomic,strong) UIView *contentView;
@property int counter;

@end

@implementation ActionSheetView
- (id)initWithHeight:(CGFloat)height backColor:(UIColor*)color
{
    self.height=height;
    self.backColor=color;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = CGRectGetWidth(screenRect);
    CGFloat screenHeight = CGRectGetHeight(screenRect);
    
    self=[super initWithFrame:CGRectMake(0, screenHeight-height, screenWidth, height)];
    if(self){
        
        self.counter = 0;
        self.showSheet = NO;
        
        
        
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, height)];
        self.contentView.transform = CGAffineTransformMakeTranslation(0, self.height);
        [self addSubview:self.contentView];
        
        self.sideHelperView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 0, 0)];
        self.sideHelperView.backgroundColor=[UIColor blackColor];
        [self addSubview:self.sideHelperView];
        
        
        self.centerHelperView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2, height, 0, 0)];
        self.centerHelperView.backgroundColor=[UIColor blackColor];
        [self addSubview:self.centerHelperView];
        
        self.backgroundColor=[UIColor clearColor];
        
        UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(10.0, 205, 300, 40);
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setBackgroundColor:self.backColor];
        [sureButton addTarget:self action:@selector(sureMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:sureButton];
        
        
        
        
        
    }
    return self;
}
- (void)sureMethod:(UIButton*)bt
{
    if (self.sureDelegate && [self.sureDelegate respondsToSelector:@selector(sureClickMethod:)]) {
        
        
    }
  

}

-(void) addView:(UIView *)view
{
    [self.contentView addSubview:view];
}

-(void) show
{
    if(self.counter!=0){
        return;
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.showSheet=YES;
    [self start];
    [self animateSideHelperViewToPoint:CGPointMake(self.sideHelperView.center.x, 0)];
    [self animateCenterHelperViewToPoint: CGPointMake(self.centerHelperView.center.x, 0)];
    [self animateContentViewToHeight:0];
    
}

-(void) hide
{
    if(self.counter!=0){
        return;
    }
    self.showSheet=NO;
    [self start];
    CGFloat height = CGRectGetHeight(self.bounds);
    
    [self animateSideHelperViewToPoint:CGPointMake(self.sideHelperView.center.x, height)];
    [self animateCenterHelperViewToPoint: CGPointMake(self.centerHelperView.center.x, height)];
    [self animateContentViewToHeight:self.height];
    
}

-(void) animateSideHelperViewToPoint:(CGPoint) point
{
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:sideViewDamping initialSpringVelocity:sideViewVelocity options:0 animations:^{
        self.sideHelperView.center = point;
    } completion:^(BOOL finished) {
        [self complete];
        
    }];
    
}


-(void) animateCenterHelperViewToPoint:(CGPoint) point
{
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:centerViewDamping initialSpringVelocity:centerViewVelocity options:0 animations:^{
        self.centerHelperView.center = point;
        
    } completion:^(BOOL finished) {
        [self complete];
    }];
}

-(void) animateContentViewToHeight:(CGFloat) height
{
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:centerViewDamping initialSpringVelocity:centerViewVelocity options:0 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, height);
    } completion:^(BOOL finished) {
    }];
}




-(void) tick:(CADisplayLink*) displayLink
{
    //NSLog(@"%@", NSStringFromCGPoint(self.centerHelperView.center));
    [self  setNeedsDisplay];
}

-(void) start
{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
        self.counter=2;
    }
}

-(void) complete
{
    self.counter--;
    if(self.counter==0){
        [self.displayLink invalidate];
        self.displayLink = nil;
        if(!self.showSheet){
            [self removeFromSuperview];
        }
    }
}
- (void)drawRect:(CGRect)rect
{
    if(self.counter==0){
        return;
    }
    CALayer* sideLayer=self.sideHelperView.layer.presentationLayer;
    CGPoint sidePoint=sideLayer.frame.origin;
    
    CALayer* centerLayer =self.centerHelperView.layer.presentationLayer;
    CGPoint centerPoint=centerLayer.frame.origin;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [self.backColor setFill];
    
    [path moveToPoint:sidePoint];
    [path addQuadCurveToPoint:CGPointMake(320, sidePoint.y) controlPoint:centerPoint];
    [path addLineToPoint:CGPointMake(320, CGRectGetHeight(self.bounds))];
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.bounds))];
    [path closePath];
    
    [path fill];
}
- (void)showOrHidden:(UITableView*)tableview indexPath:(NSIndexPath*)index isHidden:(BOOL)hidden
{
    self.showSheet = hidden;
    
    if (self.showSheet) {
        
        [self hide];
        [tableview deselectRowAtIndexPath:index animated:YES];
        
        
    } else {
    
        [self show];
        
    }
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    
    
    
    }
    return self;
}



@end
