//
//  MapSearchLocationViewController.h
//  LeTu
//
//  Created by DT on 14-7-2.
//
//

#import "BaseViewController.h"

/**
 *  搜索地址ViewController
 */
@interface MapSearchLocationViewController : BaseViewController

@property(nonatomic,copy)NSString *adress;

-(id)initWithSearchType:(int)type;

/**
 *  回调函数
 *  latitude 纬度
 *  longitude 精度
 *  address 地址
 */
@property(strong , nonatomic) void (^callBack) (float latitude,float longitude, NSString *address);

@end
