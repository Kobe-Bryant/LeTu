//
//  view.h
//  绘制
//
//  Created by 斌 on 12-10-27.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ColorType)
{
    ColorTypeBlack = 0,
    ColorTypeWhite = 1,
    ColorTypeYinGray = 2,
    ColorTypeRed = 3,
    ColorTypeBlue = 4,
    ColorTypeYellow = 5,
    ColorTypeOthers = 6,
  
};


@interface view : UIView
@property(nonatomic,assign) ColorType type;


@end
