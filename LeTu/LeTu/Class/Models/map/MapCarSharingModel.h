//
//  MapCarSharingModel.h
//  LeTu
//
//  Created by DT on 14-5-29.
//
//

#import "BaseModel.h"

/**
 *  拼车接口
 */
@interface MapCarSharingModel : BaseModel

@property(nonatomic,copy)NSString *carPhoto;
@property(nonatomic,copy)NSString *distance;//距离数(单位千米)
/** 是否付费 1:是 2:否 */
@property(nonatomic,copy)NSString *free;//free
@property(nonatomic,copy)NSString *mId;
@property(nonatomic,copy)NSString *latitudeEnd; //目的地点纬度
@property(nonatomic,copy)NSString *latitudeStart;//出发地点纬度
@property(nonatomic,copy)NSString *longitudeEnd;//目的地点经度
@property(nonatomic,copy)NSString *longitudeStart;//出发地点经度
@property(nonatomic,copy)NSString *startTime;//出发时间
/** 用户性别：1=男，2=女 */
@property(nonatomic,copy)NSString *userGender;//用户性别
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userPhoto;
@property(nonatomic,copy)NSString *userSign;
/** 用户类型，1=车主，2=乘客 */
@property(nonatomic,copy)NSString *userType;//用户类型

@property(nonatomic,copy)NSString *phoneLatitude;
@property(nonatomic,copy)NSString *phoneLongitude;

@end
