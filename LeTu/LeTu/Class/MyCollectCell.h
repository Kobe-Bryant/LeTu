//
//  MyCollectCell.h
//  LeTu
//
//  Created by mafeng on 14-9-27.
//
//

#import <UIKit/UIKit.h>
@class LeTuRouteModel;



@interface MyCollectCell : UITableViewCell
@property(nonatomic,strong) UIImageView* avatorImageView;//头像
@property(nonatomic,strong) UIImageView* carTypeImageView;//判断是车主还是乘客
@property(nonatomic,strong) UIImageView* seView;//性别图片

@property(nonatomic,strong) UIImageView* sexImageView;//性别图片
@property(nonatomic,strong) UILabel* ageLabel;//年龄图片
@property(nonatomic,strong) UILabel* nickNameLabel;//昵称
@property(nonatomic,strong) UILabel* starLabel;//开始地方
@property(nonatomic,strong) UILabel* endLabel;//结束地方
@property(nonatomic,strong) UIImageView* carImageView;//车的图片
@property(nonatomic,strong) UILabel* carNameLabel;//车名字
@property(nonatomic,strong) UILabel* starTimeLabel;//开始时间
@property(nonatomic,strong) UILabel* distanceLabel;//距离

- (void)setCellInfomation:(LeTuRouteModel*)model;


@end
