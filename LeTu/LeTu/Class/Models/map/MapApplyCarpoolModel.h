//
//  MapApplyCarpoolModel.h
//  LeTu
//
//  Created by DT on 14-6-26.
//
//

#import "BaseModel.h"

/**
 *  拼车申请Model
 */
@interface MapApplyCarpoolModel : BaseModel

@property(nonatomic,strong)NSString *carPhoto;
@property(nonatomic,strong)NSString *carSharingId;
@property(nonatomic,strong)NSString *mId;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userPhoto;
@property(nonatomic,strong)NSString *userSign;

@end
