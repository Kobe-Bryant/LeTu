//
//  view.m
//  绘制
//
//  Created by 斌 on 12-10-27.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import "view.h"

@implementation view


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectt = CGRectMake(0 ,0, 15, 15);//坐标
   
   
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 0.5);

    switch (self.type) {
        case 0:
         CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f,0.8);//颜色（RGB）,透明度
        break;
        case 1:
            //设置画笔颜色：黑色
            CGContextSetRGBStrokeColor(context, 160.0/255.0f, 160.0/255.0f, 160.0/255.0f, 1);
             CGContextSetRGBFillColor(context, 255.0/ 255.0f, 255.0/ 255.0f, 255/ 255.0f,0.8);//颜色（RGB）,透明度
         
            break;
        case 2:
         CGContextSetRGBFillColor(context, 160.0/ 255.0f, 160.0/ 255.0f, 160/ 255.0f,0.8);//颜色（RGB）,透明度
            break;
        case 3:
            CGContextSetRGBFillColor(context, 255.0/ 255.0f, 55.0/ 255.0f, 69.0/ 255.0f,0.8);//颜色（RGB）,透明度
            break;
        case 4:
           CGContextSetRGBFillColor(context, 16.0/ 255.0f, 107.0/ 255.0f, 217/ 255.0f,0.8);//颜色（RGB）,透明度
            break;
        case 5:
            CGContextSetRGBFillColor(context, 255.0/ 255.0f, 241.0/ 255.0f, 0.0f,0.8);//颜色（RGB）,透明度
            break;
        case 6:
            CGContextSetRGBFillColor(context, 102.0/ 255.0f, 102.0/ 255.0f, 102.0/ 255.0f,1.0);//颜色（RGB）,透明度
            break;
      
        default:
            break;
    }
    

    CGContextFillRect(context, rectt);
    //画矩形边框
    CGContextAddRect(context,rect);
    CGContextStrokePath(context);

}

@end
