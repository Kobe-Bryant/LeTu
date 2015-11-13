//
//  MapFaceAnnotation.h
//  LeTu
//
//  Created by DT on 14-5-12.
//
//

#import "BMKPointAnnotation.h"
#import "MapCarSharingModel.h"
/**
 *  气泡信息类
 */
@interface MapFaceAnnotation : BMKPointAnnotation

@property(nonatomic,strong)MapCarSharingModel *model;

@property(nonatomic,assign)int tag;

@property(nonatomic,copy)NSString *facePath;
@property(nonatomic,strong)UIImage *faceImage;

//@property(nonatomic,copy)NSString *name;
//@property(nonatomic,assign)int sex;
//@property(nonatomic,assign)int payType;
//@property(nonatomic,assign)int userType;

@end
