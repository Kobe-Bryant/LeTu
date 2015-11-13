//
//  FriendsCircleBlacklistAddViewController.h
//  LeTu
//
//  Created by DT on 14-6-13.
//
//

#import "BaseViewController.h"

/**
 *  朋友圈黑名单添加
 */
@interface FriendsCircleBlacklistAddViewController : BaseViewController

-(id)initWithArray:(NSMutableArray*)array;
/**
 *  回调函数
 *  dataSource 数据
 */
@property(strong , nonatomic) void (^callBack) (NSMutableArray *dataSource);
@end
