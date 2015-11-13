//
//  UIImage+Category.m
//  LeTu
//
//  Created by DT on 14-6-17.
//
//
#import "DTImage+Category.h"

@implementation UIImage (Category)

- (UIImage *)imageAsCircle:(BOOL)clipToCircle
               withDiamter:(CGFloat)diameter
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              shadowOffSet:(CGSize)shadowOffset
{
    CGFloat increase = diameter * 0.1f;
    CGFloat newSize = diameter + increase;
    CGRect newRect = CGRectMake(0.0f,0.0f,newSize,newSize);
    
    CGRect imgRect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // draw shadow
    if(!CGSizeEqualToSize(shadowOffset, CGSizeZero)) {
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(shadowOffset.width, shadowOffset.height),
                                    2.0f,
                                    [UIColor colorWithWhite:0.0f alpha:0.45f].CGColor);
    }
    
    // draw border
    if(borderColor && borderWidth) {
        CGPathRef borderPath = (clipToCircle) ? CGPathCreateWithEllipseInRect(imgRect, NULL) : CGPathCreateWithRect(imgRect, NULL);
        CGContextAddPath(context, borderPath);
        
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGPathRelease(borderPath);
    }
    
    CGContextRestoreGState(context);
    
    if(clipToCircle) {
        UIBezierPath *imgPath = [UIBezierPath bezierPathWithOvalInRect:imgRect];
        [imgPath addClip];
    }
    
    [self drawInRect:imgRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions([self size], NO, [UIScreen mainScreen].scale);
    
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //水印图
    [mask drawInRect:rect];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

//压缩图片
-(UIImage*) imageWithScaledToSize:(CGSize)newSize
{
    //create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    //Tell the old image to draw in this new context,with the desired new size
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //Get the new image from the context
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    //End the context
    UIGraphicsEndImageContext();
    
    //Return the new image.
    return newImage;
}

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage*)imageWithMaxImagePix:(CGFloat)maxImagePix compressionQuality:(CGFloat)compressionQuality
{
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if (self.size.width >= self.size.height) {
        width = maxImagePix;
        height = self.size.height*maxImagePix/self.size.width;
    }else{
        height = maxImagePix;
        width = self.size.width*maxImagePix/self.size.height;
    }
    
    CGSize sizeImageSmall = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(sizeImageSmall);
    CGRect smallImageRect = CGRectMake(0, 0, sizeImageSmall.width, sizeImageSmall.height);
    [self drawInRect:smallImageRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *dataImage = UIImageJPEGRepresentation(smallImage, compressionQuality);
    return [UIImage imageWithData:dataImage];
}

- (UIImage*)imageWithProportion:(CGSize)ProportionSize percent:(CGFloat)percent
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = ProportionSize.width / width;
    CGFloat heightFactor = ProportionSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor) {
        thumbPoint.y = (ProportionSize.height - scaledHeight) * 0.5;
    }else if (widthFactor < heightFactor) {
        thumbPoint.x = (ProportionSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(ProportionSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [self drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
    return [UIImage imageWithData:thumbImageData];
}

@end
