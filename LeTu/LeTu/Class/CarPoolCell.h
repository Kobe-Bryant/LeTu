//
//  CarPoolCell.h
//  LeTu
//
//  Created by mafeng on 14-9-19.
//
//

#import <UIKit/UIKit.h>
@class LeTuRouteModel;

typedef NS_ENUM(NSInteger, CarType)
{
    CarOwner = 0,//车主
    Coustomer = 1,//乘客
   
    
};

@interface CarPoolCell : UITableViewCell
@property(nonatomic,assign) CarType type;
@property(nonatomic,strong) UIImageView* avatorImageView;//头像
@property(nonatomic,strong) UIImageView* cartypeImageView;//车的标志或者乘客的标志
@property(nonatomic,strong) UILabel* nicknameLabel;//昵称
@property(nonatomic,strong) UIImageView* carImageView;//车的图片，只有车主才显示
@property(nonatomic,strong) UILabel* carNameLabel;//车的名字 只有车主才显示
@property(nonatomic,strong) UILabel* carNumberLabel;//车牌号 只有车主才显示
@property(nonatomic,strong) UIImageView* careImageview;//关注图片
@property(nonatomic,strong) UILabel* careLabel;//关注的个数
@property(nonatomic,strong) UILabel* careCountLabel;
@property(nonatomic,strong) UILabel* enrollCountLabel;
@property(nonatomic,strong) UILabel* downnumberLabel;
@property(nonatomic,strong) UILabel* lineLabelOne;//线条
@property(nonatomic,strong) UIImageView* personImageview;//报名乘客的图片
@property(nonatomic,strong) UILabel* enrollLabel;//报名的个数，区分车主和乘客
@property(nonatomic,strong) UILabel* lineLabelTwo;//线条
@property(nonatomic,strong) UIImageView* downImageView;//余座的图片
@property(nonatomic,strong) UILabel* downCountLabel;//余座的个数
@property(nonatomic,strong) UILabel* startStationLabel;//起点
@property(nonatomic,strong) UILabel* startplaceLabel;//起点的位置
@property(nonatomic,strong) UILabel* locationstarLabel;//起点的区
@property(nonatomic,strong) UILabel* overStationLabel;//终点
@property(nonatomic,strong) UILabel* overplaceLabel;//终点的位置
@property(nonatomic,strong) UILabel* locationoverLabel;//终点的区
@property(nonatomic,strong) UILabel* time;//时间
@property(nonatomic,strong) UILabel* timeLabel;//日期和时间

+ (CGFloat)getCellHeight;//设置cell的行高
- (void)setCellInformation:(LeTuRouteModel*)model;









@end
