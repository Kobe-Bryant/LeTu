//
//  MapCreateActivityViewController.h
//  LeTu
//
//  Created by DT on 14-6-19.
//
//

#import "BaseViewController.h"
#import "MapActivityModel.h"
/**
 *  创建活动ViewController
 */
@interface MapCreateActivityViewController : BaseViewController

//-(id)initWithActivityModel:(MapActivityModel *)model;

@property(strong , nonatomic) void (^callBack) ();

@end
