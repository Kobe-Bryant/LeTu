//
//  MapSelectLocationViewController.m
//  LeTu
//
//  Created by DT on 14-7-1.
//
//

#import "MapSelectLocationViewController.h"
#import "MapLocationBottomView.h"
#import "MapLmmediateViewController.h"
#import "MapSearchLocationViewController.h"

@interface MapSelectLocationViewController ()<BMKMapViewDelegate,BMKSearchDelegate>

@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKSearch *search;

@property(nonatomic,strong)UIButton *currentStartButton;
@property(nonatomic,strong)UIButton *currentEndButton;

@property(nonatomic,strong)UILabel *titleLabel;
//1:表示设置起点 2:表示设置终点 3:确定
@property(nonatomic,assign)int start;
//@property(nonatomic,strong)NSString *address;

@property(nonatomic,strong)MapLocationBottomView *bottomView;

@end

@implementation MapSelectLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self iniNavigationController];
    self.titleLabel.text = @"出发地";
    self.start = 1;
    [self initMapView];
    [self initBottomView];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.appDelegate.navigation.isSlide = NO;
	self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
//    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化导航栏
 */
-(void)iniNavigationController
{
    UIImage *topBar = [UIImage imageNamed:@"letu_navbtn_bg"];
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(0, 0, topBar.size.width, topBar.size.height)];
    topBarImageView.image = topBar;
    [self.view addSubview:topBarImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 220, 44)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.center = topBarImageView.center ;
    [topBarImageView addSubview:self.titleLabel];
    
    UIImage *normal = [UIImage imageNamed:@"common_topbar_back_btn_normal"];
    UIImage *highlighted = [UIImage imageNamed:@"common_topbar_back_btn_press"];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:normal forState:UIControlStateNormal];
    [backBtn setImage:highlighted forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
- (void) backPressed:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  初始化底部界面
 */
-(void)initBottomView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-91;
    self.bottomView = [[MapLocationBottomView alloc] initWithFrame:CGRectMake(0, height, 320, 91)];
    [self.view addSubview:self.bottomView];
    if (![self.appDelegate.address isEqualToString:@""]) {
        self.bottomView.starLatitude = self.appDelegate.currentLocation.latitude;
        self.bottomView.starLongitude = self.appDelegate.currentLocation.longitude;
        self.bottomView.startAddress.text = self.appDelegate.address;
        self.bottomView.ensureButton.enabled = YES;
    }else{
//        self.bottomView.ensureButton.enabled = NO;
    }
    WEAKSELF
    [self.bottomView setCallBack:^(int type) {
        if (type==888) {
            if (weakSelf.start==1) {//起点
                [weakSelf addMapAnnotation];
                [weakSelf adjustmentInterfaceBottomView];
            }else if (weakSelf.start==2) {//终点
                [weakSelf addMapAnnotation];
                [weakSelf adjustmentInterfaceBottomView];
                [weakSelf.bottomView setNeedsDisplay];
                
//                [weakSelf adjustmentStylesBottomView];
                
            }else if (weakSelf.start==3){//确定
                MapLmmediateViewController *lmmediateVC = [[MapLmmediateViewController alloc] initWithStartCoordinate:CLLocationCoordinate2DMake(weakSelf.bottomView.starLatitude, weakSelf.bottomView.starLongitude) startAddress:weakSelf.bottomView.startAddress.text endCoordinate:CLLocationCoordinate2DMake(weakSelf.bottomView.endLatitude, weakSelf.bottomView.endLongitude) endAddress:weakSelf.bottomView.endAddress.text];
                [weakSelf.navigationController pushViewController:lmmediateVC animated:YES];
                [weakSelf removeFromParentViewController];
            }
        }
        else if(type==1 || type==2) {
            NSString *adrress = @"";
            if (weakSelf.start==1) {
                adrress = weakSelf.bottomView.startAddress.text;
            }else if (weakSelf.start==2){
                adrress = weakSelf.bottomView.endAddress.text;
            }
            MapSearchLocationViewController *searchVC = [[MapSearchLocationViewController alloc] initWithSearchType:type];
            searchVC.adress = adrress;
            [weakSelf presentModalViewController:searchVC animated:YES];
            [searchVC setCallBack:^(float latitude, float longitude, NSString *address) {
                if (weakSelf.start==1) {
                    weakSelf.bottomView.startAddress.text = address;
                    weakSelf.bottomView.starLatitude = latitude;
                    weakSelf.bottomView.starLongitude = longitude;
                    weakSelf.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude,longitude);

//                    [weakSelf addMapAnnotation];
//                    [weakSelf adjustmentInterfaceBottomView];
                    
                }else if (weakSelf.start==2){
                    weakSelf.bottomView.endAddress.text = address;
                    weakSelf.bottomView.endLatitude = latitude;
                    weakSelf.bottomView.endLongitude = longitude;
                    weakSelf.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude,longitude);
//                    [weakSelf addMapAnnotation];
//                    [weakSelf adjustmentInterfaceBottomView];
                }
            }];
        }else if (type==11){
            weakSelf.bottomView.ensureButton.tag = 811;
            [weakSelf.bottomView.ensureButton setImage:[UIImage imageNamed:@"location_ending_normal"] forState:UIControlStateNormal];
            [weakSelf.bottomView.ensureButton setImage:[UIImage imageNamed:@"location_ending_press"] forState:UIControlStateHighlighted];
            weakSelf.currentStartButton.hidden = NO;
            NSArray *annotationArray = [NSArray arrayWithArray:weakSelf.mapView.annotations];
            
            for (BMKPointAnnotation *annotation in annotationArray) {
                if ([annotation.title isEqualToString:@"出发地"]) {
                    [weakSelf.mapView removeAnnotation:annotation];
                }
            }
            
        }else if (type==12){
            
        }else if (type==811){
            NSLog(@"811.....");
        }
    }];
}
/**
 *  调整bottomView界面
 */
-(void)adjustmentInterfaceBottomView
{
    if (self.start==1) {
        self.start = 2;
        self.titleLabel.text = @"目的地";
        self.currentStartButton.hidden = YES;
        self.currentEndButton.hidden = NO;
        
        CGRect frame = self.bottomView.frame;
        frame.origin.y -= 40;
        frame.size.height += 40;
        self.bottomView.frame = frame;
        self.bottomView.status = 2;
        [self.bottomView.ensureButton setImage:[UIImage imageNamed:@"location_ending_normal"] forState:UIControlStateNormal];
        [self.bottomView.ensureButton setImage:[UIImage imageNamed:@"location_ending_press"] forState:UIControlStateHighlighted];
//        self.bottomView.endAddress.text = self.bottomView.startAddress.text;
//        self.bottomView.endLatitude = self.bottomView.starLatitude;
//        self.bottomView.endLongitude = self.bottomView.starLongitude;
        self.bottomView.endAddress.text = self.appDelegate.address;
        self.bottomView.endLatitude = self.appDelegate.currentLocation.latitude;
        self.bottomView.endLongitude = self.appDelegate.currentLocation.longitude;
        self.bottomView.startButton.enabled = NO;
    }else if (self.start==2) {
        self.start = 3;
        self.currentEndButton.hidden = YES;
        
        [self.bottomView.ensureButton setImage:[UIImage imageNamed:@"location_submit_normal"] forState:UIControlStateNormal];
        [self.bottomView.ensureButton setImage:[UIImage imageNamed:@"location_submit_press"] forState:UIControlStateHighlighted];
        self.bottomView.endButton.enabled = NO;
    }
}

-(void)adjustmentStylesBottomView
{
    [self.bottomView.startButton setImage:[UIImage imageNamed:@"location_edit_normal"] forState:UIControlStateNormal];
    [self.bottomView.startButton setImage:[UIImage imageNamed:@"location_edit_press"] forState:UIControlStateHighlighted];
    self.bottomView.startButton.enabled = YES;
    self.bottomView.startButton.tag = 11;
    [self.bottomView.endButton setImage:[UIImage imageNamed:@"location_edit_normal"] forState:UIControlStateNormal];
    [self.bottomView.endButton setImage:[UIImage imageNamed:@"location_edit_press"] forState:UIControlStateHighlighted];
    self.bottomView.endButton.enabled = YES;
    self.bottomView.endButton.tag = 12;
}
/**
 *  初始化地图
 */
- (void)initMapView
{
    self.search = [[BMKSearch alloc] init];
    self.search.delegate = self;
    
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-91;
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height)];
    self.mapView.backgroundColor = [UIColor whiteColor];
    self.mapView.delegate = self;
    //    self.mapView.showsUserLocation = YES; //显示定位图层
    [self.view addSubview:self.mapView];
    
    CLLocationCoordinate2D coordinate = self.appDelegate.currentLocation;
    self.mapView.zoomLevel = 15;
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    self.currentStartButton = [[UIButton alloc] initWithFrame:
                               CGRectMake((self.mapView.frame.size.width-31)/2,
                                          44+(self.mapView.frame.size.height-91-50)/2+29,
                                          31, 50)];
    [self.currentStartButton setImage:[UIImage imageNamed:@"location_starting"] forState:UIControlStateNormal];
    [self.currentStartButton setImage:[UIImage imageNamed:@"location_starting"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.currentStartButton];
    
    self.currentEndButton = [[UIButton alloc] initWithFrame:
                             CGRectMake((self.mapView.frame.size.width-31)/2,
                                        44+(self.mapView.frame.size.height-91-50)/2+29,
                                        31, 50)];
    [self.currentEndButton setImage:[UIImage imageNamed:@"location_ending"] forState:UIControlStateNormal];
    [self.currentEndButton setImage:[UIImage imageNamed:@"location_ending"] forState:UIControlStateHighlighted];
    self.currentEndButton.hidden = YES;
    [self.view addSubview:self.currentEndButton];
    
}
/**
 *  增加地图大头针
 */
-(void)addMapAnnotation
{
    if (self.start==1) {
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.bottomView.starLatitude, self.bottomView.starLongitude);
        pointAnnotation.title = @"出发地";
        [self.mapView addAnnotation:pointAnnotation];
    }else if (self.start==2) {
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.bottomView.endLatitude, self.bottomView.endLongitude);
        pointAnnotation.title = @"目的地";
        [self.mapView addAnnotation:pointAnnotation];
    }
}
#pragma mark implement BMKMapViewDelegate
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPointAnnotation* pointAnnotation = (BMKPointAnnotation*)annotation;
    
    NSString *AnnotationViewID = @"renameMark";
    BMKAnnotationView * annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    // 从天上掉下效果
    ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    // 设置可拖拽
    ((BMKPinAnnotationView*)annotationView).draggable = NO;
    ((BMKPinAnnotationView*)annotationView).canShowCallout = NO;
    if ([pointAnnotation.title isEqualToString:@"出发地"]) {
        annotationView.image = [UIImage imageNamed:@"location_starting"];
    }else if ([pointAnnotation.title isEqualToString:@"目的地"]) {
        annotationView.image = [UIImage imageNamed:@"location_ending"];
    }
    
    return annotationView;
}

#pragma mark implement BMKMapViewDelegate
/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    NSLog(@"regionDidChangeAnimated...");
    if (self.start==1) {
        self.bottomView.starLatitude = self.mapView.centerCoordinate.latitude;
        self.bottomView.starLongitude = self.mapView.centerCoordinate.longitude;
    }else if (self.start==2){
        self.bottomView.endLatitude = self.mapView.centerCoordinate.latitude;
        self.bottomView.endLongitude = self.mapView.centerCoordinate.longitude;
    }
    [self.search reverseGeocode:self.mapView.centerCoordinate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    self.bottomView.ensureButton.enabled = NO;
}
#pragma mark - BMKSearchDelegate
//返回地址信息搜索结果
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        if (self.start==1) {//起点
            self.bottomView.startAddress.text = result.strAddr;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }else if (self.start==2){
            self.bottomView.endAddress.text = result.strAddr;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
	}
}
@end
