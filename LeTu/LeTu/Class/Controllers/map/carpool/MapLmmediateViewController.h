//
//  MapLmmediateViewController.h
//  LeTu
//
//  Created by DT on 14-6-11.
//
//

#import "BaseViewController.h"

/**
 *  即时拼车ViewController
 */
@interface MapLmmediateViewController : BaseViewController

/**
 *  初始化方法
 *
 *  @param startCoordinate 起点坐标
 *  @param startAddress    起点地址
 *  @param endCoordinate   终点坐标
 *  @param endAddress      终点地址
 *
 *  @return
 */
-(id)initWithStartCoordinate:(CLLocationCoordinate2D)startCoordinate startAddress:(NSString*)startAddress endCoordinate:(CLLocationCoordinate2D)endCoordinate endAddress:(NSString*)endAddress;

/**
 *  回调函数,表示增加数据后会调用这个函数
 */
@property(strong , nonatomic) void (^callBack) ();

@end
