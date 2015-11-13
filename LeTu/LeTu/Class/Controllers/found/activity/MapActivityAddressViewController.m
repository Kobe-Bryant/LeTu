//
//  MapActivityAddressViewController.m
//  LeTu
//
//  Created by DT on 14-7-2.
//
//

#import "MapActivityAddressViewController.h"
#import "MapLocationBottomView.h"
#import "MapSearchLocationViewController.h"

@interface MapActivityAddressViewController()<BMKMapViewDelegate,BMKSearchDelegate>

@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKSearch *search;
@property(nonatomic,strong)MapLocationBottomView *bottomView;

@property(nonatomic,strong)UIButton *currentStartButton;
//@property(nonatomic,strong)UIButton *currentEndButton;

@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;
@property(nonatomic,copy)NSString *address;
@end

@implementation MapActivityAddressViewController


-(id)initWithTitle:(NSString*)title latitude:(float)latitude longitude:(float)longitude address:(NSString*)address
{
    self = [super init];
    if (self) {
        self.titleName = title;
        self.latitude = latitude;
        self.longitude = longitude;
        self.address = address;
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        self.titleName = @"活动地址";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
//    [self setTitle:@"活动地址" andShowButton:YES];
    [self setTitle:self.titleName andShowButton:YES];
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
 *  初始化底部界面
 */
-(void)initBottomView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-91;
    self.bottomView = [[MapLocationBottomView alloc] initWithFrame:CGRectMake(0, height, 320, 91)];
    [self.view addSubview:self.bottomView];
    
    if ([self.titleName isEqualToString:@"目的地"]) {
        self.bottomView.startImageView.image = [UIImage imageNamed:@"end_blank"];
    }
    
    [self.bottomView.ensureButton setImage:[UIImage imageNamed:@"location_submit_normal"] forState:UIControlStateNormal];
    [self.bottomView.ensureButton setImage:[UIImage imageNamed:@"location_submit_press"] forState:UIControlStateHighlighted];
    
    if ([self.titleName isEqualToString:@"出发地"] || [self.titleName isEqualToString:@"目的地"]) {
        self.bottomView.starLatitude = self.latitude;
        self.bottomView.starLongitude = self.longitude;
        self.bottomView.startAddress.text = self.address;
        self.bottomView.ensureButton.enabled = YES;
    }else{
        if (![self.appDelegate.address isEqualToString:@""]) {
            self.bottomView.starLatitude = self.appDelegate.currentLocation.latitude;
            self.bottomView.starLongitude = self.appDelegate.currentLocation.longitude;
            self.bottomView.startAddress.text = self.appDelegate.address;
            self.bottomView.ensureButton.enabled = YES;
        }
    }
    WEAKSELF
    [self.bottomView setCallBack:^(int type) {
        if (type==888) {
            if (weakSelf.callBack) {
                weakSelf.callBack(weakSelf.bottomView.starLatitude,weakSelf.bottomView.starLongitude,weakSelf.bottomView.startAddress.text);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else if (type==1) {
            MapSearchLocationViewController *searchVC = [[MapSearchLocationViewController alloc] initWithSearchType:type];
            [weakSelf presentModalViewController:searchVC animated:YES];
            [searchVC setCallBack:^(float latitude, float longitude, NSString *address) {
                weakSelf.bottomView.startAddress.text = address;
                weakSelf.bottomView.starLatitude = latitude;
                weakSelf.bottomView.starLongitude = longitude;
                weakSelf.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            }];
        }
    }];
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
    CLLocationCoordinate2D coordinate;
    if ([self.titleName isEqualToString:@"出发地"] ||[self.titleName isEqualToString:@"目的地"]) {
        coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    }else{
        coordinate = self.appDelegate.currentLocation;
    }
    self.mapView.zoomLevel = 15;
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    self.currentStartButton = [[UIButton alloc] initWithFrame:
                               CGRectMake((self.mapView.frame.size.width-31)/2,
                                          44+(self.mapView.frame.size.height-91-50)/2+29,
                                          31, 50)];
    if ([self.titleName isEqualToString:@"目的地"]) {
        [self.currentStartButton setImage:[UIImage imageNamed:@"location_ending"] forState:UIControlStateNormal];
        [self.currentStartButton setImage:[UIImage imageNamed:@"location_ending"] forState:UIControlStateHighlighted];
    }else{
        [self.currentStartButton setImage:[UIImage imageNamed:@"location_starting"] forState:UIControlStateNormal];
        [self.currentStartButton setImage:[UIImage imageNamed:@"location_starting"] forState:UIControlStateHighlighted];
    }
    [self.view addSubview:self.currentStartButton];
}

#pragma mark implement BMKMapViewDelegate
/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //    NSLog(@"regionWillChangeAnimated...");
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.bottomView.starLatitude = self.mapView.centerCoordinate.latitude;
    self.bottomView.starLongitude = self.mapView.centerCoordinate.longitude;
    [self.search reverseGeocode:self.mapView.centerCoordinate];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    self.bottomView.ensureButton.enabled = NO;
}
#pragma mark - BMKSearchDelegate
//返回地址信息搜索结果
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
    self.bottomView.startAddress.text = result.strAddr;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
