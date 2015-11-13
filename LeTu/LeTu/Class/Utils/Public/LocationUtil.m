//
//  LocationUtil.m
//  AHAOrdering
//
//  Created by cyberway on 14-4-11.
//
//

#import "LocationUtil.h"

@implementation LocationUtil

@synthesize delegate;

- (id)init
{
    if (self = [super init])
    {
        [self initializeLocationManager];
    }
    
    return self;
}

- (void) initializeLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];// 设置定位精度十米
    locationManager.delegate = self;
    //    locationManager.distanceFilter = kCLDistanceFilterNone;
}

- (void)startUpdatingLocation
{
    [locationManager startUpdatingLocation];
}

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"error");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"定位失败，请检查设置选项是否开启定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

// 6.0 以上调用这个函数

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
//    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    coordinate = oldCoordinate;
    [manager stopUpdatingLocation];
    
    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       CLPlacemark *nowPlace = nil;
                       for (CLPlacemark *place in placemarks) {
                           nowPlace = place;
                           
                           /*
                           NSLog(@"name,%@",place.name);                       // 位置名
                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                           NSLog(@"locality,%@",place.locality);               // 市
                           NSLog(@"subLocality,%@",place.subLocality);         // 区
                           NSLog(@"administrativeArea,%@",place.administrativeArea);  // 省
                           NSLog(@"country,%@",place.country);                 // 国家
                           //                           */
//                           NSString *theLocation = [NSString stringWithFormat:@"%@%@%@", place.administrativeArea,place.locality,place.subLocality];
//                           NSLog(@"=theLocation===%@", theLocation);
//                           break;
                       }
                       
                       if (self.delegate)
                       {
                           [self.delegate locationUtil:self place:nowPlace coordinate:coordinate];
                       }
                   }];
    
}


// 6.0 调用此函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"%@", @"ok");
    coordinate = newLocation.coordinate;
    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       CLPlacemark *place = nil;
                       for (place in placemarks) {
                           /*
                            NSLog(@"name,%@",place.name);                       // 位置名
                            NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                            NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                            NSLog(@"locality,%@",place.locality);               // 市
                            NSLog(@"subLocality,%@",place.subLocality);         // 区
                            NSLog(@"administrativeArea,%@",place.administrativeArea);  // 省
                            NSLog(@"country,%@",place.country);                 // 国家
                            */
//                           NSString *theLocation = [NSString stringWithFormat:@"%@%@%@", place.administrativeArea,place.locality,place.subLocality];
//                           break;
                       }
                       
                       if (self.delegate)
                       {
                           [self.delegate locationUtil:self place:place coordinate:coordinate];
                       }
                   }];
}

@end
