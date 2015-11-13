//
//  MyselfBlacklistCell.h
//  LeTu
//
//  Created by DT on 14-6-9.
//
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@class MyselfBlacklistCell;

@protocol MyselfBlacklistCellDelegate <NSObject>
//移动按钮事件
- (void)blacklistCell:(MyselfBlacklistCell*)blacklistCell tag:(NSInteger)tag;
@end

@interface MyselfBlacklistCell : UITableViewCell
@property(nonatomic,strong)UIButton *deleteButton;
@property(nonatomic,weak)id<MyselfBlacklistCellDelegate> delegate;
@property(nonatomic,strong)UserModel *model;
@end
