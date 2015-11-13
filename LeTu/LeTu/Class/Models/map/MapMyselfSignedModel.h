//
//  MapMyselfSigned.h
//  LeTu
//
//  Created by DT on 14-6-6.
//
//

#import "BaseModel.h"

/**
 *  我报名的
 */
@interface MapMyselfSignedModel : BaseModel

@property(nonatomic,copy)NSString *mId;
@property(nonatomic,copy)NSString *routeEnd;
@property(nonatomic,copy)NSString *routeStart;
@property(nonatomic,copy)NSString *startTime;
/** 状态 -1:被拒绝状态 0:初始状态 1:已接受 2:已完成 3:已完成 */
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,strong)NSMutableArray *applys;

@property(nonatomic,copy)NSString *longitudeStart;
@property(nonatomic,copy)NSString *longitudeEnd;
@property(nonatomic,copy)NSString *latitudeStart;
@property(nonatomic,copy)NSString *latitudeEnd;

@end
