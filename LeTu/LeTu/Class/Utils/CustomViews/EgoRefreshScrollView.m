//
//  EgoRefreshScrollView.m
//  CyberwayIOS
//
//  Created by mac on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EgoRefreshScrollView.h"

@interface EgoRefreshScrollView ()

@end
@implementation EgoRefreshScrollView
@synthesize tableArray,mutableArray,currentPage,added,pg;


- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		tableArray = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) addRefreshView{
	added = YES;
	currentPage = -1;
	// Initialization code.
	if (_refreshHeaderView == nil) {
		_refreshHeaderView =  [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
		
		_refreshHeaderView.delegate = self;
		[self addSubview:_refreshHeaderView];
	}
	
	//  update the last update date
	//[_refreshHeaderView refreshLastUpdatedDate:lastRefreshTime];
	
	//显示刷新条 并且即将要执行刷新的动作
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:self isFirstTime:YES];
}

-(void) addMoreView{
	if (_refreshFootView == nil) {
		_refreshFootView = [[EGORefreshTableFootView alloc] initWithFrame: CGRectMake(0.0f, self.contentSize.height, 320, 650)];
		
		_refreshFootView.delegate = self;
		[self addSubview:_refreshFootView];
		_refreshFootView.hidden = YES;
	}
	
}
-(void) modifyMoreFrame{
	_refreshFootView.frame = CGRectMake(0.0f, self.contentSize.height, 320, 650);
}







#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	currentPage = 0;
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	//刷新数据去吧
	if (refreshDelegate!=nil) {
		[refreshDelegate reloadRefreshDataSource:currentPage];
	}
	
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	_refreshFootView.frame = CGRectMake(0.0f, self.contentSize.height, 320, 650);
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	point =scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	CGPoint pt =scrollView.contentOffset;
	if (point.y < pt.y) {//向上提加载更多
		if (_refreshFootView.hidden) {
			return;
		}
		[_refreshFootView egoRefreshScrollViewDidScroll:self];
	}
	else {
		[_refreshHeaderView egoRefreshScrollViewDidScroll:self];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView{
	CGPoint pt =scrollView.contentOffset;
	if (point.y < pt.y) {//向上提加载更多
		if (_refreshFootView.hidden) {
			return;
		}
		[_refreshFootView egoRefreshScrollViewDidEndDragging:self];
	}
	else {//向下拉加载更多
		[_refreshHeaderView egoRefreshScrollViewDidEndDragging:self isFirstTime:NO];
	}
}
//显示状态条
- (void)showStateBar{
	//显示刷新条 并且即将要执行刷新的动作
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:self isFirstTime:YES];
}


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}





#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableFootDidTriggerRefresh:(EGORefreshTableFootView*)view{
	
	[self reloadTableViewDataSource1];
	//[self performSelector:@selector(doneLoadingTableViewData1) withObject:nil afterDelay:3.0f];
	
}

- (BOOL)egoRefreshTableFootDataSourceIsLoading:(EGORefreshTableFootView*)view{
	
	return _reloading; // should return if data source model is reloading
}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource1{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	//刷新数据去吧
	if (refreshDelegate != nil) {
		currentPage = currentPage + 1;
		[refreshDelegate reloadRefreshDataSource:currentPage];
	}
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData1{
	//  model should call this when its done loading
	[self modifyMoreFrame];
	_reloading = NO;
	[_refreshFootView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -


-(void) reload:(int)rows{
    //	if (rows<10) {
    //		_refreshFootView.hidden = YES;
    //	}
    //	else {
    //		_refreshFootView.hidden = NO;
    //	}
	if (pg.isEnd) {
		_refreshFootView.hidden = YES;
	}
	else {
		_refreshFootView.hidden = NO;
	}
    
	if (currentPage == 0) {
		//[self doneLoadingTableViewData];
		[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.01f];
	}
	else {
		//[self doneLoadingTableViewData1];
		[self performSelector:@selector(doneLoadingTableViewData1) withObject:nil afterDelay:0.01f];
	}
    
	//[super reloadData];
}


- (int) getWidth{
	return self.frame.size.width;
}
- (int) getHeigth{
	return self.frame.size.height;
}
- (int) getX{
	return self.frame.origin.x;
}
- (int) getY{
	return self.frame.origin.y;
}

#pragma mark -

@end

