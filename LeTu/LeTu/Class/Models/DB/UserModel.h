//
//  UserModel.h
//  E-learning
//
//  Created by cyberway on 13-9-24.
//
//

#import "BaseModel.h"

/**
 *  用户model
 */
@interface UserModel : BaseModel

//@property (nonatomic, strong) NSString *userId;
//@property (nonatomic, strong) NSString *userName;
//@property (nonatomic, strong) NSString *passWord;
//@property (nonatomic, strong) NSString *loginTime;
//@property (nonatomic, strong) NSString *lastLoginTime;

@property(nonatomic,copy)NSString *userId;//用户id
@property(nonatomic,copy)NSString *userName;//用户名称
@property(nonatomic,copy)NSString *loginName;//登录名称或叫乐透号
@property(nonatomic,copy)NSString *fullName;//昵称
@property(nonatomic,copy)NSString *userPhoto;//用户头像
@property(nonatomic,copy)NSString *carPhoto;//车的图片
@property(nonatomic,copy)NSString *mobile;//手机号
/** 用户性别：1=男，2=女 */
@property(nonatomic,assign) int relationType; //0=陌生人，1=朋友，2=黑名单

@property(nonatomic,assign) NSInteger gender;//性别
@property(nonatomic,copy)NSString *age;//年龄
@property(nonatomic,copy)NSString *sign;//用户签名
@property(nonatomic,copy)NSString *area;//用户地址
@property(nonatomic,copy)NSString *registerDate;//注册日期
@property(nonatomic,copy)NSString *lastestPhotos;//最新照片



@end
