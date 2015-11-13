//
//  MyselfSignedCell.h
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import <UIKit/UIKit.h>
#import "MapMyselfSignedModel.h"

@class MyselfSignedCell;

@protocol MyselfSignedCellDelegate <NSObject>

/**
 *  类型按钮
 *
 *  @param myselfSignedCell
 */
- (void)signedCellClickToButton:(MyselfSignedCell *)myselfSignedCell;

/**
 *  地址按钮
 *
 *  @param myselfSignedCell 当前cell
 *  @param index            类型 100:起点 101:终点 222:删除
 */
- (void)myselfSignedCell:(MyselfSignedCell *)myselfSignedCell ClickToAddressAtIndex:(NSInteger)index;

/**
 *  头像按钮
 *
 *  @param myselfSignedCell
 *  @param userName         用户名
 *  @param userId           用户id
 */
- (void)signedCellClickToButton:(MyselfSignedCell *)myselfSignedCell userName:(NSString*)userName userId:(NSString*)userId;

@end

@interface MyselfSignedCell : UITableViewCell
@property(nonatomic,strong)UIButton *deleteButton;

@property(nonatomic,assign)id<MyselfSignedCellDelegate> delegate;
/** 类型 1:已上车 2:支付 3:已完成 */
@property(nonatomic,assign)int type;

@property(nonatomic,strong)MapMyselfSignedModel *model;
@end
