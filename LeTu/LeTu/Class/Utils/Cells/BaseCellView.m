//
//  BaseCellView.m
//  LiveByTouch
//
//  Created by hao.li on 11-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseCellView.h"

@implementation BaseCellView
@synthesize imageRect,imagePoint;
@synthesize target,row;
@synthesize baseEntity;
//@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor clearColor];
		//self.backgroundColor = BARBACKGROUND;
		//self.backgroundColor = [UIColor whiteColor];
		self.opaque =  YES;
    }
    return self;
}

-(void) setBaseEntity:(BaseModel *)value{
//    if (baseEntity!=nil) {
//        [baseEntity release];
//        baseEntity = nil;
//    }
	baseEntity = value;
}

-(void) setTarget:(BaseViewController *)value{
	target = value;
}

-(void) setRow:(int)value{
	row = value;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	self.clearsContextBeforeDrawing = YES;
	CGContextClearRect(UIGraphicsGetCurrentContext(), self.frame);
}
-(NSString*) formatStr:(NSString *)str{
	if ([str isEqualToString:@"iphone"]) {
		return @"iphone客户端";
	}
	else if	([str isEqualToString:@"android"]){
		return @"android客户端";
	}
	else {
		return @"网页";
	}
}


@end
