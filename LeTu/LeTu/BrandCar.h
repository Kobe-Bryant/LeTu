//
//  BrandCar.h
//  LeTu
//
//  Created by mafeng on 14-9-25.
//
//

#import <Foundation/Foundation.h>

@interface BrandCar : NSObject
//carId	string	汽车Id
//carBrandLogo	string	汽车品牌logo
//carSeriesName	string	汽车系列名称
//carColor	string	汽车颜色
//carLocation	string	汽车归属地
//carNumber	string	汽车号码
@property(nonatomic,strong) NSString* carPlace;
@property(nonatomic,strong) NSString* carNumber;
@property(nonatomic,strong) NSString* carBrandId;
@property(nonatomic,strong) NSString* carname;
@property(nonatomic,strong) NSString* carlogo;
@property(nonatomic,strong) NSString* carColor;


@end
