//
//  MapActivityMessageModel.h
//  LeTu
//
//  Created by DT on 14-7-2.
//
//

#import "BaseModel.h"

/**
 *  活动评论Model
 */
@interface MapActivityMessageModel : BaseModel

@property(nonatomic,copy)NSString *activityId;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *alias;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userPhote;
@property(nonatomic,copy)NSString *loginName;
@property(nonatomic,copy)NSString *nickName;

@property(nonatomic,copy)NSString *activityLatitude;
@property(nonatomic,copy)NSString *activityLongitude;

@end
