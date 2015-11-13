//
//  MyCarEditViewController.h
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "BaseViewController.h"

/**
 *  填写车辆信息ViewController
 */
@interface MyCarEditViewController : BaseViewController

@property(nonatomic,copy)NSString *brandId;

-(id)initWithDictionary:(NSDictionary *)dictionary array:(NSMutableArray*)array;

/**
 *  回调函数
 *  value 数据
 */
@property(strong , nonatomic) void (^callBack) ();

@end
