//
//  MapLocationViewController.h
//  LeTu
//
//  Created by DT on 14-5-29.
//
//

#import "BaseViewController.h"

typedef void (^CallBackLocation) (int type,NSString *latitude,NSString *longitude,NSString *location);
/**
 *  地址位置获取
 */
@interface MapLocationViewController : BaseViewController
{
    CallBackLocation callBack;
}
/**
 *  初始化方法
 *
 *  @param type     类型 1:起始位置 2:目的位置
 *  @param location 位置信息
 *  @param block    回调函数
 *
 *  @return
 */
-(id)initWithType:(int)type location:(NSDictionary*)location block:(CallBackLocation) block;

/**
 *  初始化方法
 *
 *  @param type            类型 1:起始位置 2:目的位置
 *  @param currentLocation 当前位置信息
 *  @param beforeLocation  以前位置信息
 *  @param block           回调函数
 *
 *  @return
 */
-(id)initWithType:(int)type currentLocation:(NSDictionary*)currentLocation
   beforeLocation:(NSDictionary*)beforeLocation block:(CallBackLocation) block;

@end
