//
//  MapHomeViewController.m
//  LeTu
//
//  Created by DT on 14-5-12.
//
//

#import "MapHomeViewController.h"
#import "MapFaceAnnotation.h"
#import "MapFaceAnnotationView.h"
#import "MapCarShareDetailViewController.h"
#import "MapHomeFilterView.h"
#import "DTGridTableView.h"
#import "MapPhotoView.h"
#import "Animations.h"
#import "MapCarSharingModel.h"
#import "MapCarpoolHomeController.h"
#import "MapLmmediateViewController.h"
#import "MapActivityViewController.h"
#import "MapTableViewCell.h"
#import "MapAnnotationView.h"
#import "MapApplyCarpoolModel.h"
#import "MapSelectLocationViewController.h"
#import "MapCarpoolApplicationCell.h"
#import "DTTableView.h"

#ifdef IMPORT_LETUIM_H
#import "LeTuIM.h"
#endif

@interface MapHomeViewController ()<BMKMapViewDelegate,BMKSearchDelegate,DTGridTableViewDatasource,DTGridTableViewDelegate,UITableViewDataSource,UITableViewDelegate,MapCarpoolApplicationCellDelegate>
{
//    UIView *_currentView;
    NSOperationQueue *queue;
    int currentIndex;
}
@property(nonatomic,strong)DTTableView *applyTableView;//拼车申请列表
@property(nonatomic,strong)NSMutableArray *applyMutableArray;

@property(nonatomic,strong)UIButton *rightBarButton;
@property(nonatomic,strong)MapHomeFilterView *filterView;//筛选
@property(nonatomic,strong)DTTableView *tableView;//列表
@property(nonatomic,strong)DTGridTableView *gridTableView;//照片
@property(nonatomic,strong)UIView *addView;//添加
@property(nonatomic,retain)BMKMapView *mapView;//地图
@property(nonatomic,retain)BMKSearch *search;
@property(nonatomic,strong)UIButton *locateButton;

@property(nonatomic,strong)BMKPointAnnotation *currentPointAnnotation;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSMutableArray *itemArray;
//@property (nonatomic,strong) NSMutableArray *annotationArray;

@property (nonatomic,assign) int sexType;//查看性别
@property (nonatomic,assign) int userType;//查看类型
@property (nonatomic,copy) NSString *usertype;
@property (nonatomic,copy) NSString *userGender;
@property (nonatomic,strong) UIButton *refreshButton;
@end

@implementation MapHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.itemArray = [[NSMutableArray alloc] init];
//    self.annotationArray = [[NSMutableArray alloc] init];
    self.applyMutableArray = [[NSMutableArray alloc] init];
    self.userType = 1;
    self.sexType = 1;
    self.usertype = @"";
    self.userGender = @"";
    
//    [self setTitle:@"搭一程" andShowButton:NO];
    UIImage *topBar = [UIImage imageNamed:@"letu_navbtn_bg1"];
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(0, 0, topBar.size.width, topBar.size.height)];
    topBarImageView.image = topBar;
    [self.view addSubview:topBarImageView];
    self.refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
    self.refreshButton.backgroundColor = [UIColor clearColor];
//    self.refreshButton.alpha = 0.5;
    self.refreshButton.tag = 999;
    [self.refreshButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshButton];
    
    
    [self initRightBarButton:[UIImage imageNamed:@"add_btn_press"]
                highlightedImage:[UIImage imageNamed:@"add_btn_current"]];
    [self initLeftBarButtonItem];
    
    //用户报名拼车通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(createCarpoolSuccess) name:@"createCarpoolSuccess" object:nil];
    
    //用户刷新头像或者性别的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(informationRevised) name:@"informationRevised" object:nil];
    //用户报名拼车通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(newCarpoolList:) name:@"newCarpoolList" object:nil];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-69, FRAME_WIDTH, 49)];
    view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
    
    [self initTabelView];
    self.tableView.pages = 30;
    [self initGridTableView];
    [self initMapView];
//    [self initAnnotationData];
//    _currentView = self.mapView;
    
//    [self fillData];
    
    
#ifdef IMPORT_LETUIM_H
    [[LeTuIM sharedInstance] startServe];
#endif
}
- (void)viewWillAppear:(BOOL)animated
{
    self.appDelegate.navigation.isSlide = NO;
    [self.mapView removeAnnotation:self.currentPointAnnotation];
    self.currentPointAnnotation = nil;
	self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.mapView.showsUserLocation = YES;
    SHOWTABBAR;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"locationLaunched"]) {//判断是否首次运行
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"locationLaunched"];
    }else{
        if ([CLLocationManager locationServicesEnabled]) {//是否开启定位
            if ([CLLocationManager locationServicesEnabled] &&
                ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
                 || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
                    //定位功能可用，开始定位
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ok" message:@"定位可以用" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    [alert show];
                }
            else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"定位不可以用" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.mapView.showsUserLocation = NO;
    self.appDelegate.navigation.isSlide = YES;
//    self.mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  导航栏左边按钮
 */
- (void)initLeftBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
    [backButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"selection_btn_current"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"selection_btn_press"] forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
}
/**
 *  导航栏右边按钮
 */
- (void)initRightBarButton:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage
{
    self.rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-normalImage.size.width-5, 0, normalImage.size.width, 44)];
    [self.rightBarButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBarButton setImage:normalImage forState:UIControlStateNormal];
    [self.rightBarButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [self.view addSubview:self.rightBarButton];
}
/**
 *  筛选按钮
 *
 *  @param button
 */
- (void)clickLeftButton:(UIButton*)button
{
    if (self.addView) {
        self.addView.hidden = YES;
    }
    
    if (self.filterView) {
        if (self.filterView.hidden) {
            self.filterView.hidden = NO;
        }else{
            self.filterView.hidden = YES;
        }
    }else{
        int height = [UIScreen mainScreen].bounds.size.height -64;
        self.filterView = [[MapHomeFilterView alloc] initWithFrame:CGRectMake(0, 64, FRAME_WIDTH, height) block:^(int oneRow, int twoRow, int threeRow, int fourRow) {
            self.filterView.hidden = YES;
            if (self.sexType!=oneRow || self.userType != twoRow) {
                self.sexType = oneRow;
                self.userType = twoRow;
                if (oneRow==1) {
                    self.userGender = @"";
                }else if (oneRow==2) {
                    self.userGender = @"1";
                }else if (oneRow==3) {
                    self.userGender = @"2";
                }
                if (twoRow==1) {
                    self.usertype = @"";
                }else if (twoRow==2) {
                    self.usertype = @"1";
                }else if (twoRow==3) {
                    self.usertype = @"2";
                }
                self.tableView.pageNumber = 0;
                [self fillData];
            }
            if (fourRow ==1) {
                if (threeRow==1){//地图
                    self.locateButton.hidden = NO;
                    self.mapView.hidden = NO;
                    self.gridTableView.hidden = YES;
                    self.tableView.hidden = YES;
                }else if (threeRow == 2){//列表
                    self.locateButton.hidden = YES;
                    self.tableView.hidden = NO;
                    self.gridTableView.hidden = YES;
                    self.mapView.hidden = YES;
                }else if (threeRow == 3){//图片
                    self.locateButton.hidden = YES;
                    self.gridTableView.hidden = NO;
                    self.mapView.hidden = YES;
                    self.tableView.hidden = YES;
                }
            }
        }];
        self.filterView.backgroundColor = RGBACOLOR(4, 4, 4, 0.4);
        [[AppDelegate sharedAppDelegate].window addSubview:self.filterView];
    }
}
/**
 *  add按钮
 *
 *  @param button
 */
- (void)clickRightButton:(UIButton *)button
{
    if (self.filterView) {
        self.filterView.hidden = YES;
    }
    
    if (self.addView) {
        if (self.addView.hidden) {
            self.addView.hidden = NO;
        }else{
            self.addView.hidden = YES;
        }
    }else{
        self.addView = [[UIView alloc] initWithFrame:CGRectMake(163, 44, 147, 154)];
        self.addView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.addView];
        
        UIButton *button = nil;
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 147, 58)];
        [button setImage:[UIImage imageNamed:@"add_now_current"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"add_now_press"] forState:UIControlStateHighlighted];
        button.tag = 1;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.addView addSubview:button];
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 58, 147, 48)];
        [button setImage:[UIImage imageNamed:@"add_reserve_now_current"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"add_reserve_now_press"] forState:UIControlStateHighlighted];
        button.tag = 2;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.addView addSubview:button];
        /*
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 106, 147, 48)];
        [button setImage:[UIImage imageNamed:@"add_activity_current"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"add_activity_press"] forState:UIControlStateHighlighted];
        button.tag = 3;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.addView addSubview:button];
         //*/
    }
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    self.addView.hidden = YES;
//    MapCarpoolHomeController *carpoolVC = [[MapCarpoolHomeController alloc] initWithType:button.tag];
//    [self.navigationController pushViewController:carpoolVC animated:YES];
    if (button.tag ==1) {//即时按钮
        
        MapSelectLocationViewController *slVC = [[MapSelectLocationViewController alloc] init];
        [self.navigationController pushViewController:slVC animated:YES];
        
//        MapLmmediateViewController *lmmediateVC = [[MapLmmediateViewController alloc] init];
//        [lmmediateVC setCallBack:^{
//            [self fillData];
//        }];
//        [self.navigationController pushViewController:lmmediateVC animated:YES];
    }else if (button.tag ==2){//预约按钮
        MapCarpoolHomeController *carpoolVC = [[MapCarpoolHomeController alloc] initWithType:button.tag];
        [self.navigationController pushViewController:carpoolVC animated:YES];
    
    }else if (button.tag ==3){//活动按钮
        MapActivityViewController *activityVC = [[MapActivityViewController alloc] init];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else if (button.tag==999) {//刷新按钮
        self.tableView.pageNumber = 0;
        [self fillData];
    }
}
/**
 *  初始化照片墙View
 */
-(void)initGridTableView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT;
    if (self.gridTableView) {
        self.gridTableView.hidden = NO;
    }else{
        self.gridTableView = [[DTGridTableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, FRAME_WIDTH, height)];
        self.gridTableView.backgroundColor = [UIColor whiteColor];
        self.gridTableView.datasource = self;
        self.gridTableView.delegate = self;
        [self.view addSubview:self.gridTableView];
    }
    
    WEAKSELF
    [self.gridTableView.tableView addHeaderWithTimekey:@"mapTimeKey" Callback:^{
        weakSelf.tableView.pageNumber = 0;
        [weakSelf fillData];
//        [weakSelf.gridTableView.tableView headerEndRefreshing];
    }];
    
    [self.gridTableView.tableView addFooterWithCallback:^{
        [weakSelf fillData];
//        [weakSelf.gridTableView.tableView footerEndRefreshing];
    }];
}
-(void)initTabelView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT;
    if (self.tableView) {
        self.gridTableView.hidden = NO;
    }else{
        self.tableView = [[DTTableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, FRAME_WIDTH, height)];
        self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
        self.tableView.rowHeight = 74;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tag = 1;
        [self.view addSubview:self.tableView];
    }
    WEAKSELF
    [self.tableView addHeaderWithTimekey:@"mapTimeKey" Callback:^{
        weakSelf.tableView.pageNumber = 0;
        [weakSelf fillData];
//        [weakSelf.tableView headerEndRefreshing];
    }];
    
    [self.tableView addFooterWithCallback:^{
        [weakSelf fillData];
//        [weakSelf.tableView footerEndRefreshing];
    }];
}
/**
 *  初始化地图
 */
- (void)initMapView
{
    self.search = [[BMKSearch alloc] init];
    self.search.delegate = self;
    
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT;
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height)];
    self.mapView.backgroundColor = [UIColor whiteColor];
    self.mapView.overlookEnabled = NO;
    self.mapView.rotateEnabled = NO;
//    self.mapView.showMapScaleBar = YES;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES; //显示定位图层
    
    [self.view addSubview:self.mapView];
    
//    self.coordinate = CLLocationCoordinate2DMake(23.169848,113.442844);
    
    self.locateButton = [[UIButton alloc] initWithFrame:CGRectMake(268, self.mapView.frame.size.height+44-32-20, 32, 32)];
    [self.locateButton setImage:[UIImage imageNamed:@"location_btn_current"] forState:UIControlStateNormal];
    [self.locateButton setImage:[UIImage imageNamed:@"location_btn_press"] forState:UIControlStateHighlighted];
    [self.locateButton addTarget:self action:@selector(clicLocateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.locateButton];
    
    
//    BMKCoordinateRegion region;
//    BMKCoordinateSpan span;
//    span.latitudeDelta=0.05;
//    span.longitudeDelta=0.05;
//    region.span = span;
//    region.center = self.coordinate;
//    
//    self.mapView.mapType = BMKMapTypeStandard;
//    [self.mapView setRegion:region animated:NO];
//    [self.mapView regionThatFits:region];
    
    /*
    MapFaceAnnotation* item = [[MapFaceAnnotation alloc]init];
    item.coordinate = CLLocationCoordinate2DMake(23.159848, 113.442844);
    item.title = @"尼玛的";
    item.sex =1;
    [self.mapView addAnnotation:item];
     //*/
}
-(void)clicLocateButton:(UIButton*)button
{
    [self.mapView removeAnnotation:self.currentPointAnnotation];
    self.currentPointAnnotation = nil;
    
    BMKCoordinateRegion region = BMKCoordinateRegionMake(self.appDelegate.currentLocation, BMKCoordinateSpanMake(0.05, 0.05));
    [self.mapView setRegion:region animated:YES];
    
    self.mapView.showsUserLocation = YES;
    if ([self.tableView.tableArray count]==0) {
        self.tableView.pageNumber = 0;
        [self fillData];
    }
}
#pragma mark - BMKMapViewDelegate
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@",error);
    self.mapView.showsUserLocation = YES;
}
//用户位置更新后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"GEHomeMapViewController::mapView:didUpdateUserLocation - [%f,%f]",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
//    self.mapView.userLocation.subtitle = userLocation.location.s
    
    //获取坐标地址
    [self.search reverseGeocode:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)];
//    NSLog(@"定位%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//    NSLog(@"系统%f,%f",self.appDelegate.currentLocation.latitude,self.appDelegate.currentLocation.longitude);
    if (userLocation.coordinate.latitude >0) {
//        self.mapView.showsUserLocation = NO;
//        if (!self.currentPointAnnotation) {
//            self.currentPointAnnotation = [[BMKPointAnnotation alloc]init];
//            CLLocationCoordinate2D coordinate =
//            CLLocationCoordinate2DMake(userLocation.coordinate.latitude-0.004, userLocation.coordinate.longitude);
//            self.currentPointAnnotation.coordinate = coordinate;
//            self.currentPointAnnotation.title = @"我的位置";
//            [self.mapView addAnnotation:self.currentPointAnnotation];
//        }
        if (self.appDelegate.currentLocation.latitude<=0) {
            self.mapView.showsUserLocation = NO;
            BMKCoordinateRegion region = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.05, 0.05));
            [self.mapView setRegion:region animated:YES];
            
            self.appDelegate.currentLocation = userLocation.location.coordinate;
            self.tableView.pageNumber = 0;
            [self fillData];
        }
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error){
            for (CLPlacemark *placemark in place) {
                NSString *cityName=placemark.locality;//获取城市名
                self.appDelegate.locality = cityName;
                break;
            }
        };
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        
        [geocoder reverseGeocodeLocation:loc completionHandler:handler];
    }
}
#pragma mark -
#pragma mark - BMKPoiSearchDelegate
//返回地址信息搜索结果
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        self.mapView.userLocation.subtitle = result.strAddr;
        self.appDelegate.address = result.strAddr;
	}
}

#pragma mark -
#pragma mark - BMKMapViewDelegate
/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (self.addView) {
        self.addView.hidden = YES;
    }
}
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (self.addView) {
        self.addView.hidden = YES;
    }
}
/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if (self.addView) {
        self.addView.hidden = YES;
    }
}

#pragma mark - BMKMapViewDelegate - annotation
//点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MapFaceAnnotation class]]) {
        MapFaceAnnotation *faceAnnotation = (MapFaceAnnotation*)view.annotation;
        [self.mapView deselectAnnotation:faceAnnotation animated:NO];
        
        MapCarShareDetailViewController *detailVC = [[MapCarShareDetailViewController alloc]
                                                     initWithModel:faceAnnotation.model];
        [self.navigationController pushViewController:detailVC animated:YES];
        HIDETABBAR;
    }
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
//    NSLog(@"MapHomeViewController : viewForAnnotation..");
    if ([annotation isKindOfClass:[MapFaceAnnotation class]]) {
        MapFaceAnnotation* faceAnnotation = (MapFaceAnnotation*)annotation;
        return [self getRouteAnnotationView:mapView viewForAnnotation:faceAnnotation];
    }else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        NSString *AnnotationViewID = @"center";
        BMKAnnotationView * annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
        ((BMKPinAnnotationView*)annotationView).canShowCallout = false;
        annotationView.image = [UIImage imageNamed:@"map_center_point"];
        return annotationView;
    }
    return nil;
}
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(MapFaceAnnotation*)faceAnnotation
{
//	BMKAnnotationView* view = nil;
    MapAnnotationView *view = nil;
    
	view = (MapAnnotationView*)[mapview dequeueReusableAnnotationViewWithIdentifier:@"face"];
    if (view == nil) {
        view = [[MapAnnotationView alloc] initWithAnnotation:faceAnnotation reuseIdentifier:@"face"];
        view.canShowCallout = YES;
    }
//    ((BMKPinAnnotationView*)view).animatesDrop = YES;
    if ([faceAnnotation.model.userGender intValue] ==1) {//男
        view.image = [UIImage imageNamed:@"male_location"];
    }else{
        view.image = [UIImage imageNamed:@"female_location"];
    }
    view.facePath = [NSString stringWithFormat:@"%@%@", SERVERImageURL,faceAnnotation.model.userPhoto];
    view.tag = faceAnnotation.tag;
    view.annotation = faceAnnotation;
    
    //显示气泡
    MapFaceAnnotationView *paopaoView = [[MapFaceAnnotationView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    paopaoView.headPortrait = faceAnnotation.model.userPhoto;
    paopaoView.name = faceAnnotation.model.userName;
    paopaoView.userType = [faceAnnotation.model.userType intValue];
    paopaoView.free = [faceAnnotation.model.free intValue];
    
    view.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
    
    return view;
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag ==1) {
        return [self.tableView.tableArray count];
    }else if (tableView.tag==2) {
        return [self.applyMutableArray count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        static NSString *CellIdentifier = @"Cell0";
        MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (! cell) {
            cell = [[MapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row < [self.tableView.tableArray count]) {
            MapFaceAnnotation *annotation = [self.tableView.tableArray objectAtIndex:indexPath.row];
            cell.model =annotation.model;
        }
        return cell;
    }else if (tableView.tag==2){
        static NSString *CellIdentifier = @"appleCell";
        MapCarpoolApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (! cell) {
            cell = [[MapCarpoolApplicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
        if (indexPath.row < [self.applyMutableArray count]) {
            MapApplyCarpoolModel *model = [self.applyMutableArray objectAtIndex:indexPath.row];
            cell.model = model;
        }
        return cell;
    }
    return nil;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        MapFaceAnnotation *annotation = [self.tableView.tableArray objectAtIndex:indexPath.row];
        MapCarShareDetailViewController *detailVC = [[MapCarShareDetailViewController alloc]initWithModel:annotation.model];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark DTGridTableViewDatasource;
- (NSInteger)numberOfGridsInRow
{
    return 3;
}
- (NSInteger)numberOfGrids
{
    return [self.tableView.tableArray count];
}
- (UIView*)viewAtIndex:(NSInteger)index size:(CGSize)size
{
    MapPhotoView *view = [[MapPhotoView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)
                                                       block:^(int index) {
                                                           MapFaceAnnotation *annotation = [self.tableView.tableArray objectAtIndex:index];
                                                           MapCarShareDetailViewController *detailVC =
                                                           [[MapCarShareDetailViewController alloc]initWithModel:annotation.model];
                                                           [self.navigationController pushViewController:detailVC animated:YES];
                                                           HIDETABBAR;
                                                           
                                                       }];
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 0.2;
    
    CALayer *l = [view layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    
    return view;
}
#pragma mark DTGridTableViewDelegate;
- (void)gridView:(UIView*)gridView gridViewForRowAtIndexPath:(int)index;
{
    MapPhotoView *grid = (MapPhotoView*)gridView;
    if (index < [self.tableView.tableArray count]) {
        MapFaceAnnotation *annotation = [self.tableView.tableArray objectAtIndex:index];
        grid.index = index;
        grid.model = annotation.model;
    }
}
-(void)fadeOutAnimation:(UIView*)view showView:(UIView*)showView;
{
    [view setAlpha:1.0];
    [UIView animateWithDuration:1 animations:^{
        [view setAlpha:0.0];
    } completion:^(BOOL finished) {
//        _currentView = showView;
        [self.view bringSubviewToFront:showView];
        view.alpha = 1.0;
    }];
}
/**
 *  填充数据
 */
- (void)fillData
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    CGFloat latitude = [AppDelegate sharedAppDelegate].currentLocation.latitude;
    CGFloat longitude = [AppDelegate sharedAppDelegate].currentLocation.longitude;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?list", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"latitude"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"longitude"];
    [paramDict setObject:@"100" forKey:@"range"];//辐射范围，单位千米
    [paramDict setObject:self.usertype forKey:@"userType"];//用户类型，1=车主，2=乘客
    [paramDict setObject:self.userGender forKey:@"userGender"];//性别，1=男，2=女
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",self.tableView.pages] forKey:@"page_size"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",self.tableView.pageNumber] forKey:@"page_no"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag == 1) {
        NSDictionary *objDict = [data objectForKey:@"list"];
        self.itemArray = [[NSMutableArray alloc] init];
        MapCarSharingModel *model = nil;
        MapFaceAnnotation *annotation = nil;
        
        if (self.tableView.pageNumber==0) {
            [self.tableView.tableArray removeAllObjects];
            // 清楚屏幕中所有的annotation
            NSArray* annotationArray = [NSArray arrayWithArray:self.mapView.annotations];
            [self.mapView removeAnnotations:annotationArray];
            for (NSDictionary *dict in objDict) {
                model = [[MapCarSharingModel alloc] initWithDataDict:dict];
                annotation = [[MapFaceAnnotation alloc]init];
                annotation.model = model;
                [self.itemArray addObject:annotation];
            }
            
            [self.tableView addFirstArray:self.itemArray];
//            [self.gridTableView.tableView addFirstArray:self.itemArray];
            self.tableView.pageNumber++;
            [self.tableView headerEndRefreshing];
            [self.gridTableView.tableView headerEndRefreshing];
            [self refreshData];
        }else{
            if ([objDict count]==0) {
                [self.tableView footerEndRefreshing];
                [self.gridTableView.tableView footerEndRefreshing];
            }else{
                for (NSDictionary *dict in objDict) {
                    model = [[MapCarSharingModel alloc] initWithDataDict:dict];
                    annotation = [[MapFaceAnnotation alloc]init];
                    annotation.model = model;
                    [self.itemArray addObject:annotation];
                }
                [self.tableView addMoreArray:self.itemArray];
//                [self.gridTableView.tableView addMoreArray:self.itemArray];
                self.tableView.pageNumber++;
                [self.tableView footerEndRefreshing];
                [self.gridTableView.tableView footerEndRefreshing];
                [self refreshData];
            }
        }
    }else if (tag==2) {
        [self.applyMutableArray removeObjectAtIndex:currentIndex];
        if ([self.applyMutableArray count]==0) {
            [self.applyTableView removeFromSuperview];
            self.applyTableView = nil;
        }else{
            [self.applyTableView reloadData];
        }
        [self messageToast:@"提交成功"];
    }
}
/**
 *  刷新数据
 */
- (void)refreshData
{
    for (MapFaceAnnotation *annotation in self.itemArray) {
//        annotation.coordinate = CLLocationCoordinate2DMake([annotation.model.longitudeStart floatValue],
//                                                           [annotation.model.latitudeStart floatValue]);
        annotation.coordinate = CLLocationCoordinate2DMake([annotation.model.phoneLatitude floatValue],
                                                           [annotation.model.phoneLongitude floatValue]);
        annotation.title = annotation.model.userName;
        [self.mapView addAnnotation:annotation];
    }
    [self.gridTableView reloadData];
//    [self.tableView reloadData];
    [self clicLocateButton:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.mapView.showsUserLocation = YES;
}
/**
 *  修改头像和性别成功后调用的通知
 */
-(void)informationRevised
{
    self.mapView.showsUserLocation = NO;
    self.tableView.pageNumber = 0;
    [self fillData];
}

/**
 *  用户报名拼车列表
 */
-(void)newCarpoolList:(NSNotification *)notification
{
    //*
    NSDictionary *info = [notification userInfo];
//    NSLog(@"MapHomeViewController count:%@",info);
    if (!self.applyTableView && [info count] >0) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.applyMutableArray removeAllObjects];
        
        MapApplyCarpoolModel *model = nil;
        for (NSDictionary *dict in info) {
            model = [[MapApplyCarpoolModel alloc] initWithDataDict:dict];
            [self.applyMutableArray addObject:model];
        }
        int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT;
        self.applyTableView = [[DTTableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, FRAME_WIDTH, height)];
//        self.applyTableView.backgroundColor = RGBCOLOR(239, 238, 244);
        self.applyTableView.backgroundColor = [UIColor clearColor];
        self.applyTableView.separatorColor = [UIColor clearColor];
        self.applyTableView.rowHeight = 150;
        self.applyTableView.dataSource = self;
        self.applyTableView.delegate = self;
        self.applyTableView.tag = 2;
        [self.view addSubview:self.applyTableView];
    }
     //*/
}
#pragma mark - MapCarpoolApplicationCellDelegate
- (void)carpoolApplicationCell:(MapCarpoolApplicationCell*)carpoolApplicationCell clickButtonAtIndex:(NSInteger)index;
{
    MapApplyCarpoolModel *model = [self.applyMutableArray objectAtIndex:carpoolApplicationCell.tag];
    currentIndex = carpoolApplicationCell.tag;
    if (index==1) {//接受
        [self modifyCarpoolApplication:model.mId accept:@"1"];
    }else if (index==2){//拒绝
        [self modifyCarpoolApplication:model.mId accept:@"-1"];
    }
}
/**
 *  创建拼车成功
 */
-(void)createCarpoolSuccess
{
    self.mapView.showsUserLocation = NO;
    self.tableView.pageNumber = 0;
    [self fillData];
}
/**
 *  修改拼车申请
 *
 *  @param carpoolId 拼车id
 *  @param accept    状态 1:接受 -1:拒绝
 */
-(void)modifyCarpoolApplication:(NSString*)carpoolId accept:(NSString*)accept
{
//    self.applyTableView.scrollEnabled = NO;
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?updateApply", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:carpoolId forKey:@"id"];
    [paramDict setObject:accept forKey:@"status"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
@end
