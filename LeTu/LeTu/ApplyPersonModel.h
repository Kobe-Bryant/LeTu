//
//  ApplyPersonModel.h
//  LeTu
//
//  Created by mafeng on 14-9-28.
//
//

#import <Foundation/Foundation.h>

@interface ApplyPersonModel : NSObject

@property(nonatomic,assign) NSInteger favoriteCount;
@property(nonatomic,strong) NSString* PinCheId;
@property(nonatomic,assign) NSInteger newApply;
@property(nonatomic,assign) NSInteger relationType;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,assign) NSInteger userAge;
@property(nonatomic,assign) NSInteger userGender;
@property(nonatomic,strong) NSString* userId;
@property(nonatomic,strong) NSString* userName;
@property(nonatomic,strong) NSString* userPhoto;
@property(nonatomic,strong) NSString* userSign;
@property(nonatomic,strong) NSString* carBrandLogo;
@property(nonatomic,strong) NSString* carLocation;
@property(nonatomic,assign) NSString* carNumber;
@property(nonatomic,strong) NSString* carSeriesName;










@end
