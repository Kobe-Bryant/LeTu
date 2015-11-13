//
//  MapActivityDetailViewController.h
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import "BaseViewController.h"
#import "MapActivityModel.h"

/**
 *  活动详情ViewController
 */
@interface MapActivityDetailViewController : BaseViewController

-(id)initWithActivityModel:(MapActivityModel *)model;

/**
 *  回调函数
 */
@property(strong , nonatomic) void (^callBack) ();

@end
