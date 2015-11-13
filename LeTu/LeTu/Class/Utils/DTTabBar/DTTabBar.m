//
//  DTTabBar.m
//  AnimatTabbarSample
//
//  Created by DT on 14-6-7.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import "DTTabBar.h"
#import "DTTabBarItem.h"

@interface DTTabBar()
{
    NSMutableArray *_buttonsArray;
    CGRect _frame;
    float _tabHeight;
    float _tabWidth;
}
@end

@implementation DTTabBar
@synthesize currentTab = _currentTab;

- (id)initWithFrame:(CGRect)frame array:(NSArray*)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _frame = frame;
        _tabHeight = frame.size.height;
        _tabWidth = frame.size.width/[array count];
        _buttonsArray = [[NSMutableArray alloc] init];
        [self initButtons:array];
    }
    return self;
}
-(void)initButtons:(NSArray*)array
{
    self.shadeButton = [[DTButton alloc] initWithFrame:CGRectMake(0, 0, _tabWidth, _tabHeight)];
//    [self.shadeButton setBackgroundImage:[UIImage imageNamed:@"toolBar_shade"] forState:UIControlStateNormal];
//    [self.shadeButton setBackgroundImage:[UIImage imageNamed:@"toolBar_shade"] forState:UIControlStateSelected];
    self.shadeButton.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.shadeButton];
    
    DTButton *button = nil;
    for (int i=0; i<[array count]; i++) {
        DTTabBarItem *barItem = [array objectAtIndex:i];
        button = [[DTButton alloc] initWithFrame:CGRectMake(i*_tabWidth, 0, _tabWidth, _tabHeight)];
        button.normalImage = [UIImage imageNamed:barItem.normalImageName];
        button.pressImage = [UIImage imageNamed:barItem.highlightImageName];
        button.isSelect = NO;
        if (i==0) {
            button.isSelect = YES;
        }
        button.tag = i;
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonsArray addObject:button];
    }
}
-(void)buttonClickAction:(DTButton*)button
{
    for (DTButton *btn in _buttonsArray) {
        btn.isSelect = NO;
    }
    button.isSelect = ![button isSelect];
    [self moveShadeBtn:button];
//    [self imgAnimate:button];
    [self btnAnimate:button];
    if ([self.delegate respondsToSelector:@selector(callButtonAction:)]) {
        [self.delegate callButtonAction:button.tag];
    }
    _currentTab = button.tag;
}
//移动ShadeBtn动画效果
- (void)moveShadeBtn:(UIButton*)btn{
    
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         
         CGRect frame = self.shadeButton.frame;
         frame.origin.x = btn.frame.origin.x;
         self.shadeButton.frame = frame;
     } completion:^(BOOL finished){
     }];
}
//按钮动画
- (void)btnAnimate:(UIButton *)btn{
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	CAKeyframeAnimation * animation;
	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.duration = 0.50;
	animation.delegate = self;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeForwards;
	NSMutableArray *values = [NSMutableArray array];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	animation.values = values;
	[btn.layer addAnimation:animation forKey:nil];
    
}
-(NSArray*)buttonArray
{
    return _buttonsArray;
}
/*
-(int)currentTab
{
    return _currentTab;
}
 //*/

@end
