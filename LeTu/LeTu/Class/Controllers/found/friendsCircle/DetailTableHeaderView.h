//
//  DetailTableHeaderView.h
//  LeTu
//
//  Created by DT on 14-5-14.
//
//

#import <UIKit/UIKit.h>
#import "MiniBlogModel.h"
#import "DTButton.h"

@class DetailTableHeaderView;

@protocol DetailTableHeaderViewDelegate <NSObject>

/**
 *  点击事件
 *
 *  @param otherCell 当前cell
 *  @param index     位置 1:赞按钮 2:评论按钮
 */
- (void)tableHeaderView:(DetailTableHeaderView*)tableHeaderView button:(DTButton*)button didClickAtIndex:(NSInteger)index;

@end
/**
 *  朋友圈详情内容
 */
@interface DetailTableHeaderView : UIView

@property(nonatomic,retain)DTButton *heartButton;
@property(nonatomic,retain)DTButton *bubbleButton;

@property(nonatomic,assign)id<DetailTableHeaderViewDelegate> delegate;
@property(nonatomic,assign)BOOL isAuto;
@property(nonatomic,strong)MiniBlogModel *model;
@end
