//
//  ColorSetingViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-19.
//
//

#import <UIKit/UIKit.h>
@class BrandCar;

@interface ColorSetingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) BrandCar* car;

@end
