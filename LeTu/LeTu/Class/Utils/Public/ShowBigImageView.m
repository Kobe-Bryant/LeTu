//
//  ShowBigImageView.m
//  ShowBigPic
//
//  Created by zc on 12-10-24.
//  Copyright (c) 2012年 cyberway. All rights reserved.
//
//  放大图片视图

#import "ShowBigImageView.h"
#import "Properties.h"
#import "AppDelegate.h"

@interface ShowBigImageView (private)

-(CGRect)getImgViewRect;

@end

const CGFloat MARGIN_WIDTH = 5.0f;

@implementation ShowBigImageView

@synthesize image = mImage;
@synthesize isAddBottomBar;

- (id)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        self.maximumZoomScale = 0.3f;
        self.maximumZoomScale = 2.0f;
        self.delegate = self;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    if (self = [self init])
    {
        image = image;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    }
    return self;
}

/**
 * 初始化界面
 */
- (void)initViews
{
    CGRect imgViewRect = [self getImgViewRect];
    if (imageView == nil)
    {
        imageView = [[UIImageView alloc] init];
    }
    imageView.frame = imgViewRect;
    imageView.image = mImage;
    
    [self addSubview:imageView];
    
    UIImage *image = [UIImage imageNamed:@"close.png"];
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.tag = 1;
    [closeBtn setImage:image forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(screenWidth - image.size.width * 2 / 3 - 3, 0,
                                image.size.width * 2 / 3, image.size.height * 2 / 3);
    [closeBtn addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:closeBtn];
    
    HIDETABBAR;
}

/**
 * 动画
 */
- (void)showAnimationsWithOrigin:(CGPoint)origin
{
    if (mImage != nil)
    {
        CGRect currRect = self.frame;
        CGRect imgRect = imageView.frame;
        self.frame = CGRectMake(origin.x, origin.y, 0, 0);
        imageView.frame = CGRectMake(0, 0, 0, 0);
        closeBtn.alpha = 0;
        
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0];
        
        self.frame = currRect;
        imageView.frame = imgRect;
        closeBtn.alpha = 1;
        
        [UIView commitAnimations];
    }
}

/**
 * 移除界面事件
 */
- (void)closeEvent:(UIButton *)button
{
    if (button.tag == 1)
    {
        [self removeFromSuperview];
        [closeBtn removeFromSuperview];
        if (isAddBottomBar)
        {
            SHOWTABBAR;
        }
    }
    else if (button.tag == 2)
    {
        imageView.transform = CGAffineTransformMakeRotation(M_PI / 2.0f);
    }
}

- (void)setImage:(UIImage *)image
{
    if (image != nil)
    {
        //获取设备屏幕大小
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        screenWidth = screenFrame.size.width;
        screenHeight = screenFrame.size.height;
        
        self.frame = screenFrame;
    mImage = image;
        [self initViews];
    }
}

/**
 * 根据图片的大小生成imageView frame
 */
- (CGRect)getImgViewRect
{
    CGFloat x = 0, y = 0, width = 0, height = 0;
    
    CGFloat imgWidth = mImage.size.width;
    CGFloat imgHeight = mImage.size.height;
    
    BOOL isWidth = screenWidth - 2 * MARGIN_WIDTH >= imgWidth;
    BOOL isHeight = screenHeight - 2 * MARGIN_WIDTH >= imgHeight;
    
    if (isWidth && isHeight)
    {
        x = (screenWidth - imgWidth) / 2;
        width = mImage.size.width;
        y = (screenHeight - imgHeight) / 2;
        height = mImage.size.height;
    }
    else
    {
        /*
         * 根据缩放比例来决定
         */
        CGFloat scale = 1.0f;
        CGFloat scaleWidth = imgWidth / screenWidth;
        CGFloat scaleHeight = imgHeight / screenHeight;
        if (scaleWidth <= scaleHeight)
        {
            scale = imgHeight / (screenHeight - 2 * MARGIN_WIDTH);
            
            self.minimumZoomScale = (screenHeight - 2 * MARGIN_WIDTH) / imgHeight;
        }
        else
        {
            scale = imgWidth / (screenWidth - 2 * MARGIN_WIDTH);
            
            self.minimumZoomScale = (screenWidth - 2 * MARGIN_WIDTH) / imgWidth;
        }
        
        width = imgWidth / scale;
        height = imgHeight / scale;
        x = (screenWidth - width) / 2;
        y = (screenHeight - height) / 2;
    }
    
    self.maximumZoomScale = 1.0f / self.minimumZoomScale * 2.0f;
    
    return CGRectMake(x, y, width, height);
}

//返回ScrollView上添加的需要缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    return imageView;
}

//缩放操作中被调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    /**
     * 根据放大后的尺寸定位imageView的中心点位置
     */
    CGSize imgViewSize = imageView.frame.size;
    if (imgViewSize.width >= screenWidth && imgViewSize.height >= screenHeight)
    {
        imageView.center = CGPointMake(imgViewSize.width / 2, imgViewSize.height / 2);
    }
    else if (imgViewSize.width >= screenWidth && imgViewSize.height <= screenHeight)
    {
        imageView.center = CGPointMake(imgViewSize.width / 2, screenHeight / 2);
    }
    else if (imgViewSize.width <= screenWidth && imgViewSize.height >= screenHeight)
    {
        imageView.center = CGPointMake(screenWidth / 2, imgViewSize.height / 2);
    }
    else
    {
        imageView.center = CGPointMake(screenWidth / 2, screenHeight / 2);
    }
    
    //隐藏关闭按钮
    if (! closeBtn.hidden)
    {
        closeBtn.hidden = YES;
    }
}

//缩放结束后被调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    //显示关闭按钮
    if (closeBtn.hidden)
    {
        closeBtn.hidden = NO;
    }
}



@end
