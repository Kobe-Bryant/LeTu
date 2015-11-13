//
//  EgoRefreshScrollView.h
//  CyberwayIOS
//
//  Created by mac on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFootView.h"
#import "Paging.h"

@protocol UIScrollViewRefresh
-(void) reloadRefreshDataSource:(int) pageIndex;

@end
@interface EgoRefreshScrollView : UIScrollView<UIScrollViewDelegate,EGORefreshTableHeaderDelegate,EGORefreshTableFootDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;//刷新的控件
	
	EGORefreshTableFootView *_refreshFootView;//加载更多
	
	
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
	
	id<UIScrollViewRefresh> refreshDelegate;
	
	
	CGPoint point;//判断是上拉还是下拉
    
	NSMutableArray *tableArray;//列表的显示数据集
	
	NSMutableDictionary *mutableArray;//多列表数据   这个对象有点怪异  需要在子页面去alloc  所以不用release
	
	int currentPage;
	
	BOOL added;
	
	Paging *pg;
	
	
}

@property(assign) id<UIScrollViewRefresh> refreshDelegate;@property(nonatomic,retain) NSMutableArray *tableArray;
@property(nonatomic,retain) NSMutableDictionary *mutableArray;
@property(readonly) int currentPage;
@property(nonatomic) BOOL added;
@property(nonatomic,retain) Paging *pg;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)reloadTableViewDataSource1;
- (void)doneLoadingTableViewData1;


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)showStateBar;

-(void) addRefreshView;
-(void) addMoreView;
-(void) modifyMoreFrame;


-(void) reload:(int)rows;

- (int) getWidth;
- (int) getHeigth;
- (int) getX;
- (int) getY;


- (id)initWithFrame:(CGRect)frame;

@end
