//
//  MapActivityBoxViewController.h
//  LeTu
//
//  Created by DT on 14-6-19.
//
//

#import "BaseViewController.h"

typedef void (^MapActivityBoxBlock) (NSString *value);

/**
 *  创建活动输入框
 */
@interface MapActivityBoxViewController : BaseViewController
{
    MapActivityBoxBlock boxBlock;
}
/**
 *  初始化方法
 *
 *  @param type  类型 0:主题 1:时间 2:地点 3:人数
 *  @param content 文本内容
 *  @param block 回调函数
 *
 *  @return
 */
-(id)initWithType:(int)type content:(NSString*)content block:(MapActivityBoxBlock)block;

@end
