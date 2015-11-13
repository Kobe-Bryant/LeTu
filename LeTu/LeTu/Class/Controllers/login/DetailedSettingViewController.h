//
//  DetailedSettingViewController.h
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "BaseViewController.h"

@interface DetailedSettingViewController : BaseViewController

/**
 *  初始化方法
 *
 *  @param account  帐号
 *  @param password 密码
 *
 *  @return
 */
-(id)initWithAccount:(NSString *)account password:(NSString*)password;

@end
