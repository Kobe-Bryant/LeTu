//
//  MapFaceAnnotationView.h
//  LeTu
//
//  Created by DT on 14-5-16.
//
//

#import <UIKit/UIKit.h>

/**
 *  气泡显示类
 */
@interface MapFaceAnnotationView : BMKActionPaopaoView

@property(nonatomic,copy)NSString *headPortrait;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)int userType;
@property(nonatomic,assign)int free;
@end
