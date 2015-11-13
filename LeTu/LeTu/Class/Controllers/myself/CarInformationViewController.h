//
//  CarInformationViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import <UIKit/UIKit.h>

@class BrandCar;

@interface CarInformationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) BrandCar* brandCar;


@end
