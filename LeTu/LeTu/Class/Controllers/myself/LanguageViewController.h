//
//  LanguageViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-23.
//
//

#import <UIKit/UIKit.h>
@class UserDetailModel;

@interface LanguageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UserDetailModel* model;

@end
