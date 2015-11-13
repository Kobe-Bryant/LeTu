//
//  FriendsCircleDetailViewController.h
//  LeTu
//
//  Created by DT on 14-5-14.
//
//

#import "BaseViewController.h"
#import "MiniBlogModel.h"

typedef void (^CallBack) (int type); //Block
/**
 *  朋友圈详情
 */
@interface FriendsCircleDetailViewController : BaseViewController

/**
 *  初始化方法
 *
 *  @param model 数据model
 *  @param block 回调函数 1:评论了 2:赞了
 *
 *  @return
 */
-(id)initWithModel:(MiniBlogModel*)model block:(CallBack)block;

/**
 *  回调函数
 *  value 返回值
 */
@property(strong , nonatomic) void (^callBack) ();

@end
