//
//  MapActivityApplysModel.h
//  LeTu
//
//  Created by DT on 14-7-2.
//
//

#import "BaseModel.h"

/**
 *  活动报名人数
 */
@interface MapActivityApplysModel : BaseModel

@property(nonatomic,copy)NSString *applyDate;
@property(nonatomic,copy)NSString *mId;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *userGender;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userSign;
@property(nonatomic,copy)NSString *userPhoto;

@end
