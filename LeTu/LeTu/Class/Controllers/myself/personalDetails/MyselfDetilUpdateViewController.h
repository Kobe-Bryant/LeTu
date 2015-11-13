//
//  MyselfDetilUpdateViewController.h
//  LeTu
//
//  Created by DT on 14-5-20.
//
//

#import "BaseViewController.h"
#import "UserDetailModel.h"

typedef void (^CallBack) (UserDetailModel *detailModel); //Block

/**
 *  个人资料数据修改ViewController
 */
@interface MyselfDetilUpdateViewController : BaseViewController

/**
 *  UIViewController初始化方法
 *
 *  @param content 内容
 *  @param type    类型  -- 0:修改昵称 1:修改个性签名 2:修改地区 3:修改年龄
 *  @param detailModel    数据模型
 *  @param isMe    是否自己
 *  @param block    回调函数
 *  @return
 */
-(id)initWithContent:(NSString *)content type:(NSString *)type isMe:(BOOL)isMe detailModel:(UserDetailModel*)detailModel block:(CallBack)block;

/**
 *  初始化方法
 *
 *  @param content 内容
 *  @param type    类型  -- 0:修改昵称 1:修改个性签名 2:修改地区 3:修改年龄
 *  @param userKey 回调函数
 *
 *  @return
 */
-(id)initWithContent:(NSString *)content type:(NSString *)type userKey:(NSString*)userKey;

/**
 *  回调函数
 *  value 数据
 */
@property(strong , nonatomic) void (^blockBack) (NSString *value);

@end
