//
//  BaseCell.h
//  LiveByTouch
//
//  Created by hao.li on 11-7-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellView.h"
#import "BaseModel.h"
#import "BaseViewController.h"


@interface BaseCell : UITableViewCell {
	//id<CellsDelegate> delegate;
	BaseCellView __unsafe_unretained *baseCellView;//不用release
}
//@property(nonatomic,retain) id<CellsDelegate> delegate;
@property(nonatomic,assign) BaseCellView *baseCellView;
-(void) setTarget:(BaseViewController *)value;
-(void) setBaseEntity:(BaseModel *)value;
-(void) setRow:(int) value;
@end
