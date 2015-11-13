//
//  BaseCell.m
//  LiveByTouch
//
//  Created by hao.li on 11-7-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseCell.h"


@implementation BaseCell
@synthesize baseCellView;
//@synthesize delegate;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		//ImageView *img = [[ImageView alloc] initWithPath:@"NoticeBgNormal.png" ImageType:ImageDefault];
		//self.backgroundView = img;
		//self.backgroundView.alpha = 0.5;
		//[img release];
		//self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
	}
	
	return self;
}


-(void) setBaseEntity:(BaseModel *)value{
	[baseCellView setBaseEntity:value];
	[baseCellView setNeedsDisplay];
}

-(void) setTarget:(BaseViewController *)value{
	[baseCellView setTarget:value];
}

-(void) setRow:(int) value{
	[baseCellView setRow:value];
}

//-(void) setDelegate:(id <CellsDelegate>)value{
//	//delegate = value;
//	baseCellView.delegate = value;
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
				
//		self.backgroundColor = BARBACKGROUND;
		//self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;//不透明
	}
	
	return self;
}



-(void) setFrame:(CGRect)frame{
	[super setFrame:frame];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
	
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect r = self.bounds;
	if (r.size.width>300&&r.size.height>0) {
		//r.size.height -= 1;
		baseCellView.frame = r;
	}
	else {
		self.frame = baseCellView.frame;
	}
}


@end
