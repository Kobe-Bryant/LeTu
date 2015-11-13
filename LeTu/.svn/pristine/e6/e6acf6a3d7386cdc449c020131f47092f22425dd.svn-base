//
//  QCPhotoView.h
//  qualityControl
//
//  Created by dan on 13-7-9.
//  Copyright (c) 2013年 DT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCPhotoView;

@protocol QCPhotoViewDelegate <NSObject>
@optional
- (void)photoTaped:(QCPhotoView*)photoView;
@end

@interface QCPhotoView : UIView
@property(nonatomic, retain)UIImage *imageName;
@property(nonatomic, assign)BOOL isAddImage;
@property (nonatomic, retain) id <QCPhotoViewDelegate> delegate;
@end
