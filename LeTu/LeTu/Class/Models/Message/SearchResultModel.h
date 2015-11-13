//
//  SearchResultModel.h
//  LeTu
//
//  Created by mac on 14-7-1.
//
//

#import "BaseModel.h"

@interface SearchResultModel : BaseModel
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPhoto;
@property (nonatomic, strong) NSString *isFriend;
@end
