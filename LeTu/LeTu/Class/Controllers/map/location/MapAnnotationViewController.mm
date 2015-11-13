//
//  MapAnnotationViewController.m
//  LeTu
//
//  Created by DT on 14-6-6.
//
//

#import "MapAnnotationViewController.h"
#import "DTImage+Category.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface MapAnnotationViewController()<BMKMapViewDelegate,BMKSearchDelegate>

@property(nonatomic,strong)BMKSearch *search;
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSDictionary *currentLocation;
@property(nonatomic,strong)NSDictionary *otherLocation;
@end

@interface RouteAnnotation : BMKPointAnnotation

@property (nonatomic) int type; //0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@end


@implementation MapAnnotationViewController

-(id)initWithTitle:(NSString*)title currentLocation:(NSDictionary*)currentLocation otherLocation:(NSDictionary*)otherLocation
{
    self = [super init];
    if (self) {
        self.title = title;
        self.currentLocation = currentLocation;
        self.otherLocation = otherLocation;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    
    [self setTitle:self.title andShowButton:YES];
    [self initMapView];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.appDelegate.navigation.isSlide = NO;
//    self.mapView.showsUserLocation = YES; //显示定位图层
	self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
//    self.mapView.showsUserLocation = NO; //显示定位图层
    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化地图
 */
- (void)initMapView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height)];
    self.mapView.backgroundColor = [UIColor whiteColor];
//    self.mapView.showsUserLocation = NO; //显示定位图层
//    self.mapView.mapType = BMKMapTypeTrafficOn;
//    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
//    self.mapView.showsUserLocation = YES; //显示定位图层
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    CLLocationCoordinate2D currentCoordinate =
    CLLocationCoordinate2DMake([[self.currentLocation objectForKey:@"latitude"] floatValue],
                               [[self.currentLocation objectForKey:@"longitude"] floatValue]);
    CLLocationCoordinate2D otherCoordinate =
    CLLocationCoordinate2DMake([[self.otherLocation objectForKey:@"latitude"] floatValue],
                               [[self.otherLocation objectForKey:@"longitude"] floatValue]);
    
    self.mapView.zoomLevel = 14;
    [self.mapView setCenterCoordinate:self.appDelegate.currentLocation animated:YES];
    
    BMKPointAnnotation * pointAnnotation = nil;
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    pointAnnotation.coordinate = currentCoordinate;
    pointAnnotation.title = self.title;
    pointAnnotation.subtitle = [self.currentLocation objectForKey:@"route"];
    [self.mapView addAnnotation:pointAnnotation];
    
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    pointAnnotation.coordinate = otherCoordinate;
    if ([self.title isEqualToString:@"出发地"]) {
        pointAnnotation.title = @"目的地";
    }else{
        pointAnnotation.title = @"出发地";
    }
    pointAnnotation.subtitle = [self.otherLocation objectForKey:@"route"];
    [self.mapView addAnnotation:pointAnnotation];
    
    [self initDriveSearch];
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
//- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
//{
//    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
//}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
//- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
//{
//    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
//}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
//    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
//    self.mapView.showsUserLocation = NO;
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
//    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
}

/**
 *地图状态改变完成后会调用此接口
 *@param mapview 地图View
 */
- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
//    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
}
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
	}
    NSString *AnnotationViewID = @"renameMark";
    BMKAnnotationView * annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    
    if ([self.title isEqualToString:@"出发地"]) {
        CGFloat latitude = [[self.currentLocation objectForKey:@"latitude"] floatValue];
        if (latitude == annotation.coordinate.latitude) {
            annotationView.image = [UIImage imageNamed:@"location_starting"];
        }else{
            annotationView.image = [UIImage imageNamed:@"location_ending"];
        }
    }else if ([self.title isEqualToString:@"目的地"]){
        CGFloat latitude = [[self.currentLocation objectForKey:@"latitude"] floatValue];
        if (latitude == annotation.coordinate.latitude) {
            annotationView.image = [UIImage imageNamed:@"location_ending"];
        }else{
            annotationView.image = [UIImage imageNamed:@"location_starting"];
        }
        
    }
    
    return annotationView;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:{//起点
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageNamed:@"location_starting"];
//				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = true;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:{//终点
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageNamed:@"location_ending"];
//				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.2));
				view.canShowCallout = true;
			}
			view.annotation = routeAnnotation;
		}
			break;
		
		case 4:{//驾乘
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = true;
			} else {
				[view setNeedsDisplay];
			}
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:{//途经点
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = true;
			} else {
				[view setNeedsDisplay];
			}
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	return view;
}


/**
 *  初始化驾车路线
 */
-(void)initDriveSearch
{
    self.search = [[BMKSearch alloc] init];
    self.search.delegate = self;
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = CLLocationCoordinate2DMake([[self.currentLocation objectForKey:@"latitude"] floatValue],
                                          [[self.currentLocation objectForKey:@"longitude"] floatValue]);
//	start.name = [self.currentLocation objectForKey:@"route"];
//    start.cityName = self.appDelegate.address;
	BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = CLLocationCoordinate2DMake([[self.otherLocation objectForKey:@"latitude"] floatValue],
                                        [[self.otherLocation objectForKey:@"longitude"] floatValue]);
//	end.name = [self.otherLocation objectForKey:@"route"];
//    end.cityName = self.appDelegate.address;
    
	BOOL flag = [self.search drivingSearch:self.appDelegate.address startNode:start endCity:self.appDelegate.address endNode:end];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
}
/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKSearch*)searcher result:(BMKPlanResult*)result errorCode:(int)error;
{
    NSLog(@"onGetDrivingRouteResult:error:%d", error);
    if (result != nil) {
        NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
        [self.mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:self.mapView.overlays];
        [self.mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            // 添加起点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.startNode.pt;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item];
            
            // 下面开始计算路线，并添加驾车提示点
            int index = 0;
            int size = [plan.routes count];
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    index += len;
                }
            }
            
            BMKMapPoint* points = new BMKMapPoint[index];
            index = 0;
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                    memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                    index += len;
                }
                size = route.steps.count;
                for (int j = 0; j < size; j++) {
                    // 添加驾车关键点
                    BMKStep* step = [route.steps objectAtIndex:j];
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [_mapView addAnnotation:item];
                }
            }
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = @"终点";
            [_mapView addAnnotation:item];
            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                }
            }
            
            // 根究计算的点，构造并添加路线覆盖物
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
            [_mapView addOverlay:polyLine];
            delete []points;
            
            [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
        }
    }
}
/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
//        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.strokeColor = [RGBCOLOR(41, 159, 249) colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
	return nil;
}

/**
 *  获取百度地图图片库文件(mapapi.bundle)
 *
 *  @param filename 图片路径
 *
 *  @return
 */
- (NSString*)getMyBundlePath:(NSString *)filename
{
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}
@end
