//
//  LocationUtil.h
//  AHAOrdering
//
//  Created by cyberway on 14-4-11.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class LocationUtil;

@protocol LocationUtilDelegate <NSObject>

- (void)locationUtil:(LocationUtil *)locationUtil place:(CLPlacemark *)place coordinate:(CLLocationCoordinate2D)coordinate;

@end

@interface LocationUtil : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, strong) id<LocationUtilDelegate> delegate;

- (void)startUpdatingLocation;

@end
