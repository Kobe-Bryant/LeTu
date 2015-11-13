//
//  EmotionUpdateViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import <UIKit/UIKit.h>
@class UserDetailModel;

@interface EmotionUpdateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UserDetailModel* model;

@end
