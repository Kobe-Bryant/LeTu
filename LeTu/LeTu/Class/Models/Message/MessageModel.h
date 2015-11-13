//
//  MessageModel.h
//  LeTu
//
//  Created by mac on 14-5-26.
//
//

#import "BaseModel.h"

@interface MessageModel : BaseModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *mId;
@property (nonatomic, strong) NSString *mediaFile;
@property (nonatomic, strong) NSString *msgType;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, strong) NSString *targetType;
@property (nonatomic, strong) NSString *userPhoto;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *headPhoto;

/** 聊天系统对应的messageID */
@property (nonatomic)NSInteger identity;



@end
