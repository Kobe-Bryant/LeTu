//
//  MyCarDetilUpdateViewController.h
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "BaseViewController.h"

typedef void (^CallBack) (NSString *content,NSString *brindId); //Block

@interface MyCarDetilUpdateViewController : BaseViewController

/**
 *  UIViewController初始化方法
 *
 *  @param content 内容
 *  @param 标题    类型
 *  @param block    回调函数
 *  @return
 */
-(id)initWithContent:(NSString *)content title:(NSString *)title block:(CallBack)block;

/**
 *  获取骑车品牌信息
 *
 *  @param block 回调函数
 *
 *  @return
 */
-(id)initWithBrandAndblock:(CallBack)block;

@end
