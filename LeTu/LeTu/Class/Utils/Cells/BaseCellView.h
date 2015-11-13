//
//  BaseCellView.h
//  LiveByTouch
//
//  Created by hao.li on 11-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "BaseViewController.h"

@interface BaseCellView : UIView {
	//id<CellsDelegate> delegate;
	CGRect imageRect;// = {{0, 0}, {100, 100}};
	CGPoint imagePoint;// = {0, 0};
	BaseModel __unsafe_unretained *baseEntity;// 不需要release
	BaseViewController __unsafe_unretained *target;
	
	int row;
}
//@property (nonatomic,retain) id<CellsDelegate> delegate;
@property (nonatomic) CGRect imageRect;
@property (nonatomic) CGPoint imagePoint;
@property(nonatomic,assign) BaseViewController *target;
@property(nonatomic) int row;
@property(nonatomic,assign) BaseModel *baseEntity;
-(NSString*) formatStr:(NSString *)str;

//-(void) randerEntity;
@end
