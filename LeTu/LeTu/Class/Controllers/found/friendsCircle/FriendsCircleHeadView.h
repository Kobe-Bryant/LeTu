//
//  FriendsCircleHeadView.h
//  LeTu
//
//  Created by DT on 14-5-7.
//
//

#import <UIKit/UIKit.h>
#import "BlogOverheadModel.h"

/**
 *  回调函数
 *
 *  @param type     类型 1:头像　2:背景
 *  @param userId   用户id
 *  @param userName 用户名
 */
typedef void (^CallUserBack) (int type,NSString *userId,NSString *userName); //Block

@interface FriendsCircleHeadView : UIView
{
    CallUserBack callBack;
    BOOL touch1,touch2,hasStop;
}
@property(nonatomic,retain) EGOImageView *bgImage;

- (id)initWithFrame:(CGRect)frame block:(CallUserBack)block;

@property(nonatomic,strong)BlogOverheadModel *model;

//注意看 scrollView 的回调
@property(nonatomic) BOOL touching;
@property(nonatomic) float offsetY;

@property(copy,nonatomic)void(^handleRefreshEvent)(void) ;
-(void)stopRefresh;

@end
