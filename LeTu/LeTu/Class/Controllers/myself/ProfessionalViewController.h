//
//  ProfessionalViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-24.
//
//

#import <UIKit/UIKit.h>
@class UserDetailModel;

@interface ProfessionalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UserDetailModel* model;


@end
