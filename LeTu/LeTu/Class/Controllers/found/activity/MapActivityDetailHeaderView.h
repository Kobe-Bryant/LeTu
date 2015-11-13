//
//  MapActivityDetailHeaderView.h
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import <UIKit/UIKit.h>
#import "MapActivityModel.h"

@interface MapActivityDetailHeaderView : UIView
@property(nonatomic,strong)UIButton *joinButton;

@property(nonatomic,strong)MapActivityModel *model;

/**
 *  回调函数
 *  type类型 1:查看报名人数 2:参加活动
 */
@property(strong , nonatomic) void (^callBack) (int type);

@end
