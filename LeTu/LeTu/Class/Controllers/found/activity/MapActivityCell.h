//
//  MapActivityCell.h
//  LeTu
//
//  Created by DT on 14-6-13.
//
//

#import <UIKit/UIKit.h>
#import "MapActivityModel.h"

@class MapActivityCell;

@protocol MapActivityCellDelegate <NSObject>

/**
 *  按钮点击事件
 *
 *  @param activityCell 当前cell
 *  @param index        类型 1:修改按钮 2:删除按钮
 */
- (void)activityCell:(MapActivityCell*)activityCell clickButtonAtIndex:(NSInteger)index;
@end

@interface MapActivityCell : UITableViewCell
@property(nonatomic,assign)id<MapActivityCellDelegate> delegate;

@property(nonatomic,strong)MapActivityModel *model;
@property(nonatomic,assign)BOOL isMyActivity;
@end
