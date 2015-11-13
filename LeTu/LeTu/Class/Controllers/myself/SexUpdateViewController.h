//
//  SexUpdateViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import <UIKit/UIKit.h>
@class UserDetailModel;

@interface SexUpdateViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UserDetailModel* model;

@end
