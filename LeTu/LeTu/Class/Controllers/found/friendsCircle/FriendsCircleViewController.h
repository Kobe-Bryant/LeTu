//
//  FriendsCircleViewController.h
//  LeTu
//
//  Created by DT on 14-5-7.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

/**
 *  朋友圈ViewController
 */
@interface FriendsCircleViewController : BaseViewController

-(id)initWithIsMe:(BOOL)isMe userId:(NSString*)userId;

@end
