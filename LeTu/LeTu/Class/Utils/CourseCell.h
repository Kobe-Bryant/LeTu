//
//  CourseCell.h
//  PGCBD
//
//  Created by mac on 13-5-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CourseCell;
@protocol CourseCellDelegate
@optional
-(void)ClickToDetails:(CourseCell*)course;
-(void)DownloadCourse:(CourseCell*)course;
-(void)Write:(CourseCell*)course;
@end
@interface CourseCell : UIView
{
    UIView *contentView;
    UIImageView *lightView;
    UIImageView *lineView;
    UILabel *courseNamelabel;

   	NSObject<CourseCellDelegate> *delegate;
    NSString *_courseNameValue;
    int lightColor;
    BOOL Isdownload;
    
  
    UIButton *downloadBtn;
    UIButton *writeBtn;
    UITapGestureRecognizer *gestureRecognizer;
}
@property(nonatomic,retain) UIImageView *lightView;
@property(nonatomic,retain) UIImageView *lineView;
@property(nonatomic,retain) UIButton *downloadBtn;
@property(nonatomic,retain) UILabel *courseNamelabel;
@property(nonatomic,retain) UIButton *writeBtn;
@property(nonatomic,retain) UIView *contentView;
@property(nonatomic,retain) NSObject<CourseCellDelegate> *delegate;
@property(nonatomic,retain) NSString *CourseNameValue;


@end
