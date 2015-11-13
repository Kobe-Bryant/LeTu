//
//  MapCarpoolBoxViewController.h
//  LeTu
//
//  Created by DT on 14-6-2.
//
//

#import "BaseViewController.h"

typedef void (^MapCarpoolBoxBlock) (NSString *value);

@interface MapCarpoolBoxViewController : BaseViewController
{
    MapCarpoolBoxBlock boxBlock;
}

/**
 *  初始化方法
 *
 *  @param type  类型 1:人数 2:金额
 *  @param content 文本内容
 *  @param block 回调函数
 *
 *  @return
 */
-(id)initWithType:(int)type content:(NSString*)content block:(MapCarpoolBoxBlock)block;

@end
