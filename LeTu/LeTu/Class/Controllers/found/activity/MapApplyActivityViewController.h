//
//  MapApplyActivityViewController.h
//  LeTu
//
//  Created by DT on 14-6-19.
//
//

#import "BaseViewController.h"

/**
 *  活动报名申请ViewController
 */
@interface MapApplyActivityViewController : BaseViewController

-(id)initWithActivityId:(NSString*)activityId;

/**
 *  回调函数
 */
@property(strong , nonatomic) void (^callBack) ();

@end
