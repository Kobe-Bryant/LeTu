//
//  CarManagerModel.h
//  LeTu
//
//  Created by mafeng on 14-9-20.
//
//

#import <Foundation/Foundation.h>

@interface CarManagerModel : NSObject

@property(nonatomic,strong) NSString* carpoolId;//拼车id
@property(nonatomic,strong) NSString* userId;//用户id
@property(nonatomic,strong) NSString* userName;//用户名称
@property(nonatomic,strong) NSString* nickName;//用户签名
@property(nonatomic,assign) NSInteger carType;//用户类型 1 ＝车主 2= 乘客
@property(nonatomic,assign) NSInteger gender;//性别1= 男， 2= 女
@property(nonatomic,assign) NSString* imageUrl;//头像

@property(nonatomic,strong) NSString* starPlace;//出发地点
@property(nonatomic,strong) NSString* endPlace;//终点
@property(nonatomic,strong) NSString* starTime;//出发时间
@property(nonatomic,strong) NSString* seatCount;//座位数
@property(nonatomic,strong) NSString* collectCount;//关注数
@property(nonatomic,strong) NSString* downSeatCount;//余座
@property(nonatomic,strong) NSString* enrollCount;//报名人数
@property(nonatomic,strong) NSString* remark;//备注
@property(nonatomic,strong) NSString* carSeriesName;//汽车系列名称
@property(nonatomic,strong) NSString* carImage;//汽车的logo
@property(nonatomic,strong) NSString* carLocation;//汽车归属地
@property(nonatomic,strong) NSString* carNumber;//汽车号码







@end
