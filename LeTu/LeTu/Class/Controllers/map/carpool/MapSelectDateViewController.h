//
//  MapSelectDateViewController.h
//  LeTu
//
//  Created by DT on 14-5-28.
//
//

#import "BaseViewController.h"

typedef void (^CallBack) (NSString *date); //Block

@interface MapSelectDateViewController : BaseViewController
{
    CallBack callBack;
}
-(id)initWithBlock:(CallBack)block;
@end
