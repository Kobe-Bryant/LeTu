//
//  DTGridTableView.h
//  gridView
//
//  Created by DT on 14-5-24.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridTableViewCell.h"

@class DTGridTableView;

@protocol DTGridTableViewDatasource <NSObject>

/**
 *  一行有多少个gridView
 *
 *  @return
 */
- (NSInteger)numberOfGridsInRow;
/**
 *  总共有多少gridView;
 *
 *  @return
 */
- (NSInteger)numberOfGrids;
/**
 *  对应位置的gridView
 *
 *  @param index 位置
 *  @param size  大小
 *
 *  @return
 */
- (UIView*)viewAtIndex:(NSInteger)index size:(CGSize)size;

@end

@protocol DTGridTableViewDelegate <NSObject>

@optional

/**
 *  给gridView填充数据
 *  @param gridView gridView
 *  @param index    位置
 */
- (void)gridView:(UIView*)gridView gridViewForRowAtIndexPath:(int)index;

@end

/**
 *  网格视图
 */
@interface DTGridTableView : UIView<UITableViewDataSource,UITableViewDelegate,DTGridTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) id <DTGridTableViewDatasource> datasource;
@property (nonatomic,assign) id <DTGridTableViewDelegate>   delegate;

- (void)reloadData;

@end
