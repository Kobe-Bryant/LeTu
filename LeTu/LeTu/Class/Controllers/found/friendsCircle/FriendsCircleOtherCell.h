//
//  FriendsCircleOtherCell.h
//  LeTu
//
//  Created by DT on 14-5-8.
//
//

#import <UIKit/UIKit.h>
#import "MiniBlogModel.h"
#import "DTButton.h"

@class FriendsCircleOtherCell;

@protocol FriendsCircleOtherCellDelegate <NSObject>
/**
 *  点击事件
 *
 *  @param otherCell 当前cell
 *  @param index     位置 1:赞按钮 2:评论按钮 3:头像
 */
- (void)otherCell:(FriendsCircleOtherCell*)otherCell didClickAtIndex:(NSInteger)index;

@end

@interface FriendsCircleOtherCell : UITableViewCell

@property(nonatomic,retain)DTButton *heartButton;
@property(nonatomic,retain)DTButton *bubbleButton;

@property(nonatomic,assign)id<FriendsCircleOtherCellDelegate> delegate;

@property(nonatomic,assign)BOOL isFinal;
@property(nonatomic,strong)MiniBlogModel *model;

+ (CGFloat)calculateCellHeightWithAlbum:(MiniBlogModel *)model isFinal:(BOOL)isFinal;

@end
