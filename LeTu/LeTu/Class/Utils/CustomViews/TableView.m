//
//  TableView.m
//  CyberwayIOS
//
//  Created by screate on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableView.h"
#import "EGORefreshTableHeaderView.h"

@implementation TableView
@synthesize refreshDelegate,tableArray,mutableArray,currentPage,added,pg;
@synthesize _refreshFootView;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
		//self.userInteractionEnabled = YES;
        self.backgroundView = nil;
        self.backgroundColor = RGBCOLOR(239, 238, 244);
		tableArray = [[NSMutableArray alloc] init];
    }
    return self;
}

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
		//NSLog(@"%@", NSStringFromCGRect( _refreshHeaderView.frame ));
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
		//[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		//NSLog(@"%@", NSStringFromCGRect( v.frame ));
		_refreshFootView.delegate = self;
		[self addSubview:_refreshFootView];
		_refreshFootView.hidden = YES;
	}
	
	//  update the last update date
	//[_refreshFootView refreshLastUpdatedDate];
}
-(void) modifyMoreFrame{
	_refreshFootView.frame = CGRectMake(0.0f, self.contentSize.height, 320, 650);
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		int count = [self.tableArray count];
	return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 400.0f;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:0.5] : [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:0.5];
	//cell.backgroundColor = color;
	//	UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:0.5] : [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:0.5];
	//	cell.backgroundColor = color;
	//	ImageView *m = [[ImageView alloc] initWithPath:@"NotificationBg.png"];
	//	CGRect frame = m.frame;
	//	frame.size.height = 80;
	//	m.frame = frame;
	//	cell.backgroundColor = [UIColor colorWithPatternImage:m.image];
	//	[m release];
	
	
    //	UIColor *color = ((indexPath.row % 2) == 0) ? [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1] : [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1];
    //	cell.backgroundColor = color;
	[self modifyMoreFrame];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //	static NSString *SimpleTableIdentifier = @"STI_productscell";  //SimpleTableIdentifier
	
	//定义“视图闲置组”标识符，可以是任意字符串，只要不冲突即可
	
    //	itemlistone *cell = (itemlistone*)[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	//创建一个视图，从标识为“STI“的闲置视图组中。
	//如果“STI”中有可用的闲置视图，则返回一个UITableViewCell，否则返回nil
	
    //	NSString *libget=@"itemlistone";
	
    //	if (cell == nil) {   //如果cell=nil , 则表示sti中没有可用的闲置视图
    //创建一个视图，表示这个同STI组里面的组是同一种类型
    //		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:libget owner:self options:nil];
    //		for (id oneObject in nib) 
    //			if ([oneObject isKindOfClass:[itemlistone class]]) 
    //				cell = (itemlistone*)oneObject;
    
    //	};	
    
    //   return cell;
	return nil;
}


// Override to support row selection in the table view.
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (indexPath.row == [tableArray count]) {
//        
//		UITableViewCell *loadMoreCell = [tableView cellForRowAtIndexPath:indexPath];
//		[loadMoreCell setDisplayText:@"loading more ..."];
//        [loadMoreCell setAnimating:YES];
//        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
//        //[loadMoreCell setHighlighted:NO];
//        [self deselectRowAtIndexPath:indexPath animated:YES];
//        return;
//    }	
//}




//-(void)loadMore
//{
//    NSMutableArray *more; 
//	//加载你的数据
//    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO];
//}
//
//-(void) appendTableWith:(NSMutableArray *)data
//{
//	
//    for (int i=0;i<[data count];i++) {
//        [tableArray addObject:[data objectAtIndex:i]];
//    }
//    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
//    for (int ind = 0; ind < [data count]; ind++) {
//        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[tableArray indexOfObject:[data objectAtIndex:ind]] inSection:0];
//        [insertIndexPaths addObject:newPath];
//    }
//    [self insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//	
//}

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



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */



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

- (void)reloadData{
	[super reloadData];
}


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
    
	[super reloadData];
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

- (void)isHiddenFooter:(BOOL)isHidden
{
    _refreshFootView.hidden = isHidden;
}

#pragma mark -


@end
