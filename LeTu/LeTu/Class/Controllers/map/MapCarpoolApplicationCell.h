//
//  MapCarpoolApplicationCell.h
//  LeTu
//
//  Created by DT on 14-7-3.
//
//

#import <UIKit/UIKit.h>
#import "MapApplyCarpoolModel.h"

@class MapCarpoolApplicationCell;

@protocol MapCarpoolApplicationCellDelegate <NSObject>

/**
 *  按钮点击事件
 *
 *  @param carpoolApplicationCell 当前cell
 *  @param index        类型 1:接受按钮 2:拒绝按钮
 */
- (void)carpoolApplicationCell:(MapCarpoolApplicationCell*)carpoolApplicationCell clickButtonAtIndex:(NSInteger)index;
@end

@interface MapCarpoolApplicationCell : UITableViewCell

@property(nonatomic,assign)id<MapCarpoolApplicationCellDelegate> delegate;

@property(nonatomic,strong)MapApplyCarpoolModel *model;
@end
