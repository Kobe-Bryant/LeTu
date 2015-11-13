//
//  PublishCircleFriendsViewController.h
//  LeTu
//
//  Created by DT on 14-5-19.
//
//

#import "BaseViewController.h"

typedef void (^CallBack)(int i); //Block
/**
 *  发布新帖
 */
@interface PublishCircleFriendsViewController : BaseViewController
{
    CallBack callBack;
}

-(id)initWithImage:(UIImage *)image block:(CallBack)block;
@end
