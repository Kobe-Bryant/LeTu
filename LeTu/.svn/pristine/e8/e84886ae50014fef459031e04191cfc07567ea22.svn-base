//
//  ShowBigImageView.h
//  ShowBigPic
//
//  Created by cyberway on 12-10-24.
//  Copyright (c) 2012年 cyberway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowBigImageView : UIScrollView <UIScrollViewDelegate>
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    UIImage *mImage;
    
    UIImageView *imageView;
    UIButton *closeBtn;
    BOOL isAddBottomBar;
}

@property (nonatomic, retain) UIImage *image;
@property BOOL isAddBottomBar;

- (id)init;

- (id)initWithImage:(UIImage *)image;

- (void)showAnimationsWithOrigin:(CGPoint)origin;

@end
