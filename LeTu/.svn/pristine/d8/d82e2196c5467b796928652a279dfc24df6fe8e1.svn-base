//
//  QCPhotoView.m
//  qualityControl
//
//  Created by dan on 13-7-9.
//  Copyright (c) 2013年 DT. All rights reserved.
//

#import "QCPhotoView.h"

@interface QCPhotoView()
{
    CALayer *_grayCover;
}
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, assign) BOOL isMoved;
@end

@implementation QCPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        CALayer *layer = [self.imageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:4.0];
        [self addSubview:self.imageView];
        
        //图片增加一个层
        CALayer *bgLayer = self.imageView.layer;
        _grayCover = [[CALayer alloc] init];
        _grayCover.frame = self.imageView.bounds;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:4.0];
        _grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        [bgLayer addSublayer:_grayCover];
        _grayCover.hidden = YES;
    }
    return self;
}
- (void)setImageName:(UIImage *)imageName
{
    self.imageView.image = imageName;
}
#pragma mark -
#pragma mark - touchEvent
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.isMoved = NO;
    _grayCover.hidden = NO;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    self.isMoved = YES;
    _grayCover.hidden = YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    _grayCover.hidden = YES;
    if (!self.isMoved) {
        if ([self.delegate respondsToSelector:@selector(photoTaped:)]) {
            [self.delegate photoTaped:self];
        }
    }
}
@end
