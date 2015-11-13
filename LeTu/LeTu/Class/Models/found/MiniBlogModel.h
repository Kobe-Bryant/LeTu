//
//  MiniBlogModel.h
//  LeTu
//
//  Created by DT on 14-5-26.
//
//

#import "BaseModel.h"

/**
 *  微博列表Model
 */
@interface MiniBlogModel : BaseModel

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *commendNum;
@property(nonatomic,copy)NSString *commentNum;
@property(nonatomic,copy)NSString *createdDate;
@property(nonatomic,copy)NSString *hasCommend;
@property(nonatomic,copy)NSString *hasComment;
@property(nonatomic,copy)NSString *mid;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userPhoto;
@property(nonatomic,copy)NSString *userSign;
@property(nonatomic,strong)NSMutableArray *imagesArray;

@end
