//
//  CarPoolTableHeadView.h
//  LeTu
//
//  Created by mafeng on 14-9-22.
//
//

#import <UIKit/UIKit.h>
@class LeTuRouteModel;




@interface CarPoolTableHeadView : UIView

@property(nonatomic,strong) UIImageView* avatorImageView;//头像
@property(nonatomic,strong) UIImageView* cartypeImageView;//车的标志或者乘客的标志
@property(nonatomic,strong) UILabel* nicknameLabel;//昵称
@property(nonatomic,strong) UIImageView* carImageView;//车的图片，只有车主才显示
@property(nonatomic,strong) UILabel* carNameLabel;//车的名字 只有车主才显示
@property(nonatomic,strong) UILabel* carNumberLabel;//车牌号 只有车主才显示

@property(nonatomic,strong) UILabel* downCountLabel;//余座
@property(nonatomic,strong) UILabel* downnumberLabel;//余座的个数
@property(nonatomic,strong) UILabel* startStationLabel;//起点
@property(nonatomic,strong) UILabel* startplaceLabel;//起点的位置
@property(nonatomic,strong) UILabel* locationstarLabel;//起点的区
@property(nonatomic,strong) UILabel* overStationLabel;//终点
@property(nonatomic,strong) UILabel* overplaceLabel;//终点的位置
@property(nonatomic,strong) UILabel* locationoverLabel;//终点的区
@property(nonatomic,strong) UILabel* time;//时间
@property(nonatomic,strong) UILabel* timeLabel;//日期和时间

- (void)setTableHeadViewInformation:(LeTuRouteModel*)model;


@end
