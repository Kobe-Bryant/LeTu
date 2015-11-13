//
//  MapDetailTableHeaderView.h
//  LeTu
//
//  Created by DT on 14-5-22.
//
//

#import <UIKit/UIKit.h>
#import "MapCarSharingModel.h"

@class MapDetailTableHeaderView;
@protocol MapDetailTableHeaderViewDelegate <NSObject>

/**
 *  点击事件
 *
 *  @param mapDetailHeaderView 当前view
 *  @param index     位置 1:头像 2:收藏按钮
 */
- (void)mapDetailHeaderView:(MapDetailTableHeaderView*)mapDetailHeaderView didClickAtIndex:(NSInteger)index;
@end

@interface MapDetailTableHeaderView : UIView

@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIButton *collectButton;

@property(nonatomic,assign)id<MapDetailTableHeaderViewDelegate> delegate;
@property(nonatomic,strong)MapCarSharingModel *model;

@end
