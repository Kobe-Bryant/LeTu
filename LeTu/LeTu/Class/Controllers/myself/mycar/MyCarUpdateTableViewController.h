//
//  MyCarUpdateTableViewController.h
//  LeTu
//
//  Created by DT on 14-8-1.
//
//

#import "BaseViewController.h"

typedef void (^CallBack1) (NSString *content); //Block

@interface MyCarUpdateTableViewController : BaseViewController

/**
 *  UIViewController初始化方法
 *
 *  @param content 内容
 *  @param title    标题
 *  @param type    类型 1:车辆地 2:汽车类型
 *  @param block    回调函数
 *  @return
 */
-(id)initWithContent:(NSString *)content title:(NSString *)title type:(NSString*)type block:(CallBack1)block;

@end
