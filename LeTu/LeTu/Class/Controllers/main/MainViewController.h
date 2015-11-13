//
//  MainViewController.h
//  LeTu
//
//  Created by DT on 14-6-7.
//
//

#import "BaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ASIFormDataRequest.h"

@interface MainViewController : UIViewController

@property(nonatomic,strong)ASIFormDataRequest *request;
@property(nonatomic,strong)NSOperationQueue *queue;
//是否启动线程
@property(nonatomic,assign)BOOL is_dispatch_time_t;

@property(nonatomic,strong)UIViewController *currentViewController;

-(void)callButtonAction:(int)index;

@end
