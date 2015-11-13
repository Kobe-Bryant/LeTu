//
//  TableView.h
//  CyberwayIOS
//
//  Created by screate on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFootView.h"
#import "Paging.h"
#import "BaseViewController.h"


@protocol UITableViewRefresh
-(void) reloadRefreshDataSource:(int) pageIndex;

@end

@interface TableView : UITableView<EGORefreshTableHeaderDelegate,EGORefreshTableFootDelegate> {
	EGORefreshTableHeaderView *_refreshHeaderView;//刷新的控件
	
	
	
	
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
	
	id<UITableViewRefresh> __unsafe_unretained refreshDelegate;
	
	
	CGPoint point;//判断是上拉还是下拉
    
	NSMutableArray *tableArray;//列表的显示数据集
	
	NSMutableDictionary *mutableArray;//多列表数据   这个对象有点怪异  需要在子页面去alloc  所以不用release
	
	int currentPage;
	
	BOOL added;
	
	Paging *pg;
	
    BaseViewController *target;
	
}
@property(assign) id<UITableViewRefresh> refreshDelegate;
@property(nonatomic,retain) NSMutableArray *tableArray;
@property(nonatomic,retain) NSMutableDictionary *mutableArray;
@property(readonly) int currentPage;
@property(nonatomic) BOOL added;
@property(nonatomic,retain) Paging *pg;
@property(nonatomic,retain)EGORefreshTableFootView *_refreshFootView;//加载更多
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
- (void)isHiddenFooter:(BOOL)isHidden;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (id)initWithFrame:(CGRect)frame;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
