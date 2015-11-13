//
//  MapCarSharingDetailModel.h
//  LeTu
//
//  Created by DT on 14-6-5.
//
//

#import "BaseModel.h"

/**
 *  拼车详情Model
 */
@interface MapCarSharingDetailModel : BaseModel

@property(nonatomic,copy)NSString *carPhoto;
@property(nonatomic,copy)NSString *favorite;
/** 金额 */
@property(nonatomic,copy)NSString *fee;
/** 当前用户是否已报名 */
@property(nonatomic,copy)NSString *hasApply;
@property(nonatomic,copy)NSString *mId;
/** 支付方式 1:线上支付 2:线下支付 */
@property(nonatomic,copy)NSString *payType;

@property(nonatomic,copy)NSString *remark;
/** 目的地点 */
@property(nonatomic,copy)NSString *routeEnd;
/** 出发地点 */
@property(nonatomic,copy)NSString *routeStart;
/** 座位数 */
@property(nonatomic,copy)NSString *seating;
/** 剩余座位数 */
@property(nonatomic,copy)NSString *seatingLeft;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *userGender;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userPhoto;
@property(nonatomic,copy)NSString *userSign;
/** 用户类型 1:车主 2:乘客 */
@property(nonatomic,copy)NSString *userType;
@end
