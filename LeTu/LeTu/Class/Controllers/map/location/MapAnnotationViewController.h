//
//  MapAnnotationViewController.h
//  LeTu
//
//  Created by DT on 14-6-6.
//
//

#import "BaseViewController.h"

@interface MapAnnotationViewController : BaseViewController

-(id)initWithTitle:(NSString*)title currentLocation:(NSDictionary*)currentLocation otherLocation:(NSDictionary*)otherLocation;
@end
