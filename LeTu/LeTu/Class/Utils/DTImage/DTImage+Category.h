//
//  UIImage+Category.h
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 *  图片圆形
 *
 *  @param clipToCircle 是否圆形
 *  @param diameter     直径
 *  @param borderColor  边框颜色
 *  @param borderWidth  边框宽度
 *  @param shadowOffset 阴影偏移
 *
 *  @return
 */
- (UIImage *)imageAsCircle:(BOOL)clipToCircle
               withDiamter:(CGFloat)diameter
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              shadowOffSet:(CGSize)shadowOffset;

// 图片水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;

/**
 *  压缩图片大小
 *
 *  @param image   要压缩的图片
 *  @param newSize 压缩的尺度
 *
 *  @return
 */
-(UIImage*) imageWithScaledToSize:(CGSize)newSize;

/**
 *  图片角度旋转
 *
 *  @param degrees 旋转度数
 *
 *  @return 
 */
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  图片压缩
 *
 *  @param maxImagePix        压缩的像素
 *  @param compressionQuality 压缩的比例
 *
 *  @return
 */
- (UIImage*)imageWithMaxImagePix:(CGFloat)maxImagePix compressionQuality:(CGFloat)compressionQuality;

/**
 *  图片按尺寸比例缩小
 *
 *  @param ProportionSize 最大尺寸
 *  @param percent        压缩比例
 *
 *  @return
 */
- (UIImage*)imageWithProportion:(CGSize)ProportionSize percent:(CGFloat)percent;

@end
