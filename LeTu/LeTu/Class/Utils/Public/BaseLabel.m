//
//  BaseLabel.m
//  CBD
//
//  Created by screate on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
          [self setUserInteractionEnabled:YES];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self setTextColor:[UIColor redColor]];
}
// 还原label颜色,获取手指离开屏幕时的坐标点, 在label范围内的话就可以触发自定义的操作
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch *touch = [touches anyObject];
    //CGPoint points = [touch locationInView:self];
   // if (points.x >= self.frame.origin.x && points.y >= self.frame.origin.x && points.x <= self.frame.size.width && points.y <= self.frame.size.height)
    //{
        [delegate baseLabel:self touchesWtihTag:self.tag];
    //}
}


@end
