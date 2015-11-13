//
//  MyselfDetailViewController.h
//  LeTu
//
//  Created by DT on 14-5-20.
//
//

#import "BaseViewController.h"

#import "TableHeadView.h"

/**
 *  个人资料ViewController
 */
@interface MyselfDetailViewController : UIViewController<clickButtonDelegate>

-(id)initWithTitle:(NSString*)title userId:(NSString*)userId userKey:(NSString*)userKey;
@end
