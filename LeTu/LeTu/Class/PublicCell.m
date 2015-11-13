//
//  PublicCell.m
//  LeTu
//
//  Created by mafeng on 14-9-25.
//
//

#import "PublicCell.h"

@implementation PublicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.subviews[0] setBackgroundColor:[UIColor clearColor]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, RGBCOLOR(238.0, 238.0, 238.0).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width - 10, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context,  RGBCOLOR(238.0, 238.0, 238.0).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width - 10, 1));
    
    CGContextSaveGState(context);
    
}
@end
