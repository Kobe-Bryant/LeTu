//
//  BubbleView.m
//  Pringles
//
//  Created by hao li on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BubbleView.h"

@implementation BubbleView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (id)initWithFrame1:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}








- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
	
	if (aTouch.tapCount == 1) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];		
		
    }
	
} 


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (int) getWidth{
	return self.frame.size.width;
}
- (int) getHeigth{
	return self.frame.size.height;
}
- (int) getX{
	return self.frame.origin.x;
}
- (int) getY{
	return self.frame.origin.y;
}


@end
