//
//  BlogOverheadModel.h
//  LeTu
//
//  Created by DT on 14-5-29.
//
//

#import "BaseModel.h"

/**
 *  微博列表顶置
 */
@interface BlogOverheadModel : BaseModel

@property(nonatomic,copy)NSString *hbgPhoto;
@property(nonatomic,copy)NSString *sign;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userPhoto;

@end
