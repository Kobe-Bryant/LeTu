//
//  LoginViewController.h
//  E-learning
//
//  Created by Roland on 12-6-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,strong) AppDelegate* appDelegate;
/**
 *  是否设置页面推出的
 *
 *  @param toSetting
 *
 *  @return 
 */
-(id)initToSetting:(BOOL)toSetting;
@end
