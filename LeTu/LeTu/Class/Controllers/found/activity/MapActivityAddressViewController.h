//
//  MapActivityAddressViewController.h
//  LeTu
//
//  Created by DT on 14-7-2.
//
//

#import "BaseViewController.h"

/**
 *  活动地址ViewController
 */
@interface MapActivityAddressViewController : BaseViewController

-(id)initWithTitle:(NSString*)title latitude:(float)latitude longitude:(float)longitude address:(NSString*)address;

/**
 *  回调函数
 *  latitude 纬度
 *  longitude 精度
 *  address 地址
 */
@property(strong , nonatomic) void (^callBack) (float latitude,float longitude, NSString *address);

@end
