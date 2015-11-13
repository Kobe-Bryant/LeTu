//
//  LeTuRouteModel.h
//  LeTu
//
//  Created by mafeng on 14-9-27.
//
//

#import <Foundation/Foundation.h>

@interface LeTuRouteModel : NSObject

@property(nonatomic,assign) NSInteger applyCount;
@property(nonatomic,assign) NSInteger carId;
@property(nonatomic,strong) NSString* carName;
@property(nonatomic,strong) NSString* carPhoto;

@property(nonatomic,strong) NSString* carBrandLogo;
@property(nonatomic,strong) NSString* carLocation;
@property(nonatomic,assign) NSInteger carNumber;

@property(nonatomic,strong) NSString* distanceString;
@property(nonatomic,assign) NSInteger collectCount;
@property(nonatomic,assign) NSInteger free;
@property(nonatomic,assign) NSInteger fee;
@property(nonatomic,assign) NSString* letuId;

@property(nonatomic)CLLocationCoordinate2D originLocationCoordinate2D;
@property(nonatomic)CLLocationCoordinate2D destinationLocationCoordinate2D;
@property(nonatomic)CLLocationCoordinate2D createLocationCoordinate2D;

@property(nonatomic,strong) NSString* loginName;
@property(nonatomic,assign) NSInteger payType;
@property(nonatomic,strong) NSString* relationType;
@property(nonatomic,strong) NSString* remark;

@property(nonatomic,strong) NSString* routeStartPlace;
@property(nonatomic,strong) NSString*  routeEndPlace;

@property(nonatomic,assign) NSInteger seatCount;
@property(nonatomic,assign) NSInteger seatLeftCount;
@property(nonatomic,assign) NSInteger shareType;
@property(nonatomic,strong) NSString* startTime;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,assign) NSInteger userAge;
@property(nonatomic,assign) NSInteger userGender;
@property(nonatomic,strong) NSString* userId;
@property(nonatomic,strong) NSString* userName;
@property(nonatomic,strong) NSString* userPhoto;
@property(nonatomic,strong) NSString* userSign;
@property(nonatomic,assign) NSInteger userType;
@end
