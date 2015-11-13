//
//  LeTuUserHeadImageView.m
//  LeTu
//
//  Created by Jason on 2014/7/14.
//
//

#import "LeTuSourceImageView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@implementation LeTuSourceImageView

- (id)initWithPhotoPath:(NSString *)photoPath placeholderImage:(UIImage*)anImage {
    self = [self initWithPlaceholderImage:anImage delegate:nil];
//    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        
        _sourceImagePath = photoPath;
        [self setImageWithURL:[NSURL URLWithString:_sourceImagePath] placeholderImage:anImage]; // 默认图片 PLACEHOLDER
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:_sourceImagePath];
    photo.srcImageView = self;
    [photos addObject:photo];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = photos; // 设置所有的图片
    browser.currentPhotoIndex =  0; // 弹出相册时显示的第一张图片是？
    [browser show];
}

/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
