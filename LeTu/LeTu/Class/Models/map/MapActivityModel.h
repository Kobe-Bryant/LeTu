//
//  MapActivityModel.h
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import "BaseModel.h"

/**
 *  活动Model
 */
@interface MapActivityModel : BaseModel

@property(nonatomic,copy)NSString *address;
//报名状态 0:未报名 1:已报名
@property(nonatomic,copy)NSString *apply;
@property(nonatomic,copy)NSString *applyCount;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *mId;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *leftCount;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *logPath;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userGender;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userPhoto;
@property(nonatomic,copy)NSString *userSign;
@property(nonatomic,copy)NSString *latitudeActivity;
@property(nonatomic,copy)NSString *longitudeActivity;
@property(nonatomic,strong)NSMutableArray *messages;
@property(nonatomic,strong)NSMutableArray *activityApplys;

@end
