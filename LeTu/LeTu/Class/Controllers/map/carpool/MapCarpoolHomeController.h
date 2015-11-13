//
//  MapCarpoolHomeController.h
//  LeTu
//
//  Created by DT on 14-5-28.
//
//

#import "BaseViewController.h"

/**
 *  拼车ViewController
 */
@interface MapCarpoolHomeController : BaseViewController

/**
 *  初始化方法
 *
 *  @param type 拼车类型 1:即时 2:预约 3:活动
 *
 *  @return
 */
-(id)initWithType:(int)type;

/**
 *  回调函数,表示增加数据后会调用这个函数
 */
@property(strong , nonatomic) void (^callBack) ();

@end
