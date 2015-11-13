//
//  CarPoolDetailViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-22.
//
//

#import <UIKit/UIKit.h>
@class LeTuRouteModel;
#import "CarPoolDetailCell.h"


@interface CarPoolDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,clickAcceptButtonDelegate>
@property(nonatomic,strong) LeTuRouteModel* carModel;

-(id)initWithCarManagerModel:(LeTuRouteModel*)model;


@end
