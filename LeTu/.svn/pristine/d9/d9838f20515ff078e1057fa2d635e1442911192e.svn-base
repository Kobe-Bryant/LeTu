//
//  CourseCell.m
//  PGCBD
//
//  Created by mac on 13-5-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CourseCell.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
@implementation CourseCell
@synthesize delegate,CourseNameValue=_courseNameValue,lineView,lightView,contentView,downloadBtn,writeBtn,courseNamelabel;

- (id)initWithFrame:(CGRect)frame
{
self = [super initWithFrame:frame];
if (self) 
{
    contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 258, 46)];
    [self addSubview:contentView];
}
return self;

}

-(UIImageView *)lightView
{
    if (!lightView)
    {
        self.lightView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CBD_course_condition_white.png"]];
        [self.contentView addSubview: self.lightView];
    }
    return lightView;
}

-(UIImageView *)lineView
{
    if (!lineView)
    {
        self.lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CBD_course_line.png"]];
        [self.contentView addSubview: self.lineView];
        
    }
    return lineView;

}

-(UILabel *)courseNamelabel
{
if (!courseNamelabel) 
{
    self.courseNamelabel=[[UILabel alloc]initWithFrame:CGRectMake(26, 15, 200, 20)];
    self.courseNamelabel.text=_courseNameValue;
    self.courseNamelabel.font=[UIFont systemFontOfSize:15];
    self.courseNamelabel.backgroundColor=[UIColor clearColor];
    self.courseNamelabel.textColor=[Utility colorWithHexString:@"#222222"];
    [self.contentView addSubview:self.courseNamelabel];
}
return courseNamelabel;
}


-(UIButton *)downloadBtn
{
if (!downloadBtn)
{
    
}
return downloadBtn;
}

-(UIButton *)writeBtn
{
    if (!writeBtn)
    {
        
    }
    return writeBtn;
}
//绘制布局
- (void)layoutSubviews 
{
[super layoutSubviews];
self.contentView.frame	=CGRectMake(0, 0, 258, 46);
if (lightView!=nil)
{
    self.lightView.frame= CGRectMake(7, 20, 11, 11);
}
if (lineView!=nil)
{
   [lineView removeFromSuperview];
}
self.lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CBD_course_line.png"]];
self.lineView.frame= CGRectMake(1, 45, 256, 1);
[self.contentView addSubview: self.lineView];
    
    
if (courseNamelabel!=nil) 
{
    self.courseNamelabel.frame= CGRectMake(26, 15, 200, 20);
}

if (downloadBtn!=nil) {
    [downloadBtn removeFromSuperview];
}
downloadBtn=[UIButton buttonWithType:UIButtonTypeCustom];
downloadBtn.frame=CGRectMake(221, 13, 24, 24);
[downloadBtn setImage:[UIImage imageNamed:@"CBD_course_btn_download.png"] forState:UIControlStateNormal];
[downloadBtn setImage:[UIImage imageNamed:@"CBD_course_btn_download1.png"] forState:UIControlStateHighlighted];
[downloadBtn addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchDown];
[self.contentView addSubview:downloadBtn];
downloadBtn.hidden=NO;

    if (writeBtn!=nil) {
        [writeBtn removeFromSuperview];
    }
    writeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    writeBtn.frame=CGRectMake(221, 13, 24, 24);
    [writeBtn setImage:[UIImage imageNamed:@"Triplist-delete.png"] forState:UIControlStateNormal];
    [writeBtn setImage:[UIImage imageNamed:@"Triplist-delete-1.png"] forState:UIControlStateHighlighted];
    [writeBtn addTarget:self action:@selector(write:) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:writeBtn];
    writeBtn.hidden=YES;
    
//点击手势
gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activityPressed:)];
[self addGestureRecognizer:gestureRecognizer];

}



//单击事件代理
-(IBAction)activityPressed:(id)sender
{

[delegate ClickToDetails:self];


}
//卷写事件代理
-(void)write:(id)sender
{
[delegate Write:self];
}
//下载事件代理
-(void)download:(id)sender
{
    [delegate DownloadCourse:self];
}

@end
