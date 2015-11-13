//
//  PublishPhotoView.m
//  LeTu
//
//  Created by DT on 14-5-19.
//
//

#import "PublishPhotoView.h"
#import "QCPhotoView.h"

@interface PublishPhotoView()<QCPhotoViewDelegate>

@end

@implementation PublishPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)setParameter:(NSMutableArray *)parameter
{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    for (int i=0; i<[parameter count]; i++) {
        QCPhotoView *photoView = [[QCPhotoView alloc] initWithFrame:CGRectMake(i*75+20, 5, 50, 50)];
        photoView.imageName = [parameter objectAtIndex:i];
        if (i == [parameter count]-1) {
            if (self.isAddImage) {
                photoView.isAddImage = YES;
            }
        }
        photoView.tag = i;
        photoView.delegate = self;
        [self addSubview:photoView];
    }
}

- (void)photoTaped:(QCPhotoView*)photoView
{
    if ([self.delegate respondsToSelector:@selector(photoView:index:isAddImage:)]) {
        [self.delegate photoView:self index:photoView.tag isAddImage:photoView.isAddImage];
    }
}
@end
