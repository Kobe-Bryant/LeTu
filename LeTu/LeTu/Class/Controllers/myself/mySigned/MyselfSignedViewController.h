//
//  MyselfSignedViewController.h
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import "BaseViewController.h"

//我报名的ViewController
@interface MyselfSignedViewController : BaseViewController

/**
 *  初始化方法
 *
 *  @param type 类型 1:我发起的 2:我报名的
 *
 *  @return
 */
-(id)initWithType:(int)type;
@end
