//
//  DTButton.m
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import "DTButton.h"

@interface DTButton()
{
    UIImage *_normal;
    UIImage *_press;
    UIImage *_redDotNormal;
    UIImage *_redDotPress;
}
@end

@implementation DTButton
@synthesize isSelect = _isSelect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage;
    _normal = normalImage;
}
-(void)setPressImage:(UIImage *)pressImage
{
    _pressImage = pressImage;
    _press = pressImage;
}
- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (_isSelect) {
        [self setImage:self.pressImage forState:UIControlStateNormal];
        [self setImage:self.pressImage forState:UIControlStateHighlighted];
    }else{
        NSLog(@"%@",self.normalImage);
        [self setImage:self.normalImage forState:UIControlStateNormal];
        [self setImage:self.normalImage forState:UIControlStateHighlighted];
    }
}
-(void)redDotNormal:(UIImage *)normalImage redDotPress:(UIImage *)pressImage
{
    _redDotNormal = normalImage;
    _redDotPress = pressImage;
}
-(void)setIsRedDot:(BOOL)isRedDot
{
    if (isRedDot) {
        _normalImage = _redDotNormal;
        _pressImage = _redDotPress;
    }else{
        _normalImage = _normal;
        _pressImage = _press;
    }
    self.isSelect = [self isSelect];
}
@end
