//
//  UserDetailModel.h
//  LeTu
//
//  Created by DT on 14-5-26.
//
//

#import "BaseModel.h"

/**
 *  用户详情Model
 */
@interface UserDetailModel : BaseModel

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *loginName;
@property(nonatomic,copy)NSString *fullName;
@property(nonatomic,copy)NSString *alias;
@property(nonatomic,copy)NSString *userPhoto;
@property(nonatomic,copy)NSString *carPhoto;
@property(nonatomic,copy)NSString *mobile;
/** 用户性别：1=男，2=女 */
@property(nonatomic,assign) NSInteger gender;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,copy)NSString *sign;
@property(nonatomic,copy)NSString *area;
@property(nonatomic,copy)NSString *registerDate;
/** 关系 0:陌生人 1:朋友 2:黑名单*/
@property(nonatomic,copy)NSNumber *relationType;
@property(nonatomic,copy)NSString *relationName;
@property(nonatomic,copy)NSString *lastestPhotos;

@property(nonatomic,strong) NSString* birthDay;
@property(nonatomic,strong) NSString* emotionalState;//情感状态
@property(nonatomic,strong) NSString* userLanguage;//语言
@property(nonatomic,strong) NSString* occupation;//职业
@property(nonatomic,assign) NSInteger constellation;//星座
@end
