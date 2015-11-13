//
//  CircleImageView.m
//  WYGJ
//
//  Created by cyberwayios on 13-12-23.
//
//

#import "CircleImageView.h"
#import "UIImage+JSMessagesView.h"

@implementation CircleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  block:(CallBack)block
{
    self = [super initWithFrame:frame];
    if (self) {
        callBack = block;
    }
    return self;
}

- (void)setImageURL:(NSURL *)aURL {
	if(headImageURL) {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:headImageURL];
		headImageURL = nil;
	}
	
	if(!aURL) {
		self.image = self.placeholderImage;
		headImageURL = nil;
		return;
	}
    
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self];
	
    UIImage *circleImage = [anImage js_imageAsCircle:YES
                                             withDiamter:50.0f
                                             borderColor:nil
                                             borderWidth:0.0f
                                            shadowOffSet:CGSizeZero];
    
	if(anImage) {

		self.image = circleImage;
//        self.image = [self getEllipseImageWithImage:anImage];
//        self.image = [self getEllipseImageWithBorderImage:anImage];
//        self.image = anImage;
        
		if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
			[self.delegate imageViewLoadedImage:self];
		}
	} else {
		self.image = self.placeholderImage;
	}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (callBack) {
        callBack();
    }
}
-( UIImage *)getEllipseImageWithImage:( UIImage *)originImage

{
    
    CGFloat padding = 5 ; // 圆形图像距离图像的边距
    
    UIColor * epsBackColor = [ UIColor clearColor ]; // 图像的背景色
    
    CGSize originsize = originImage. size ;
    
    CGRect originRect = CGRectMake ( 0 , 0 , originsize. width , originsize. height );
    
    UIGraphicsBeginImageContext (originsize);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext ();
    
    // 目标区域。
    
    CGRect desRect =  CGRectMake (padding, padding,originsize. width -(padding* 2 ), originsize. height -(padding* 2 ));
    
    // 设置填充背景色。
    
    CGContextSetFillColorWithColor (ctx, epsBackColor. CGColor );
    
    UIRectFill (originRect); // 真正的填充
    
    // 设置椭圆变形区域。
    
    CGContextAddEllipseInRect (ctx,desRect);
    
    CGContextClip (ctx); // 截取椭圆区域。
    
    [originImage drawInRect :originRect]; // 将图像画在目标区域。
    
    UIImage * desImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return desImage;
    
}

-( UIImage *)getEllipseImageWithBorderImage:( UIImage *)originImage
{
    
    CGFloat padding = 10 ; // 圆形图像距离图像的边距
    
    UIColor * epsBackColor = [ UIColor clearColor ]; // 图像的背景色
    
    CGSize originsize = originImage. size ;
    
    CGRect originRect = CGRectMake ( 0 , 0 , originsize. width , originsize. height );
    
    UIGraphicsBeginImageContext (originsize);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext ();
    
    // 目标区域。
    
    CGRect desRect =  CGRectMake (padding, padding,originsize. width -(padding* 2 ), originsize. height -(padding* 2 ));
    
    // 设置填充背景色。
    
    CGContextSetFillColorWithColor (ctx, epsBackColor. CGColor );
    
    UIRectFill (originRect); // 真正的填充
    
    // 设置椭圆变形区域。
    
    CGContextAddEllipseInRect (ctx,desRect);
    
    CGContextClip (ctx); // 截取椭圆区域。
    
    [originImage drawInRect :originRect]; // 将图像画在目标区域。
    
    // 边框 //
    
    CGFloat borderWidth = 50 ;
    
    CGContextSetStrokeColorWithColor (ctx, [ UIColor whiteColor ]. CGColor ); // 设置边框颜色
    
    CGContextSetLineCap (ctx, kCGLineCapButt );
    
    CGContextSetLineWidth (ctx, borderWidth); // 设置边框宽度。
    
    CGContextAddEllipseInRect (ctx, desRect); // 在这个框中画圆
    
    CGContextStrokePath (ctx); // 描边框。
    
    // 边框 //
    
    UIImage * desImage = UIGraphicsGetImageFromCurrentImageContext (); // 获取当前图形上下文中的图像。
    
    UIGraphicsEndImageContext ();
    
    return desImage;
    
}
@end
