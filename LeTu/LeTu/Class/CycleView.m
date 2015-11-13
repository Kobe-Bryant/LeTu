//
//  CycleView.m
//  LeTu
//
//  Created by mafeng on 14-9-27.
//
//

#import "CycleView.h"
#import <CoreFoundation/CoreFoundation.h>


@implementation CycleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    
    
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextFillEllipseInRect(ref, CGRectMake(95, 95, 100.0, 100));
   // CGContextSetFillColorWithColor(ref, RGBCOLOR(<#r#>, <#g#>, <#b#>))
    
    CGContextStrokePath(ref);

}

@end
