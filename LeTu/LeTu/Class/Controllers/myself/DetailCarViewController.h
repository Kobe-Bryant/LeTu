//
//  DetailCarViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-25.
//
//

#import <UIKit/UIKit.h>
@class BrandCar;

@interface DetailCarViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) BrandCar* brandCar;

@end
