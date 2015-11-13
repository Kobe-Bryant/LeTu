//
//  MapLocationViewController.m
//  LeTu
//
//  Created by DT on 14-5-29.
//
//

#import "MapLocationViewController.h"

@interface MapLocationViewController ()<BMKMapViewDelegate,BMKSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)DTTableView *tableView;
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKSearch *search;

@property(nonatomic,strong)UIView *locationBoxView;
@property(nonatomic,strong)UIImageView *locationBoxImage;
@property(nonatomic,strong)UITextField *locationBoxField;
@property(nonatomic,strong)UIButton *sureButton;

@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,assign)int type;
@property(nonatomic,strong)NSDictionary *location;
@property(nonatomic,strong)NSDictionary *beforeLocation;

@property(nonatomic,strong)BMKPointAnnotation *pointAnnotation;
@property(nonatomic,strong)BMKAnnotationView* annotationView;
@property(nonatomic,strong)NSString *address;
//@property(nonatomic,strong)NSMutableArray *itemsArray;
@end

@implementation MapLocationViewController

-(id)initWithType:(int)type currentLocation:(NSDictionary*)currentLocation
   beforeLocation:(NSDictionary*)beforeLocation block:(CallBackLocation) block
{
    self = [super init];
    if (self) {
        self.location = currentLocation;
        self.beforeLocation = beforeLocation;
        self.type = type;
        callBack = block;
    }
    return self;
}
-(id)initWithType:(int)type location:(NSDictionary*)location block:(CallBackLocation) block;
{
    self = [super init];
    if (self) {
        self.location = location;
        self.type = type;
        callBack = block;
//        self.itemsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//键盘改变的通知
    
    if (self.type ==1) {
        [self setTitle:@"出发地" andShowButton:YES];
    }else if (self.type==2){
        [self setTitle:@"目的地" andShowButton:YES];
    }
    [self initMapView];
    [self initLocationBoxView];
    if (![[self.location objectForKey:@"address"] isEqualToString:@""]) {
        self.locationBoxField.placeholder = [self.location objectForKey:@"address"];
    }
    [self initTabelView];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.appDelegate.navigation.isSlide = NO;
//    self.mapView.showsUserLocation = YES;
	self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
//    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化输入框
 */
- (void)initLocationBoxView
{
    int height = [UIScreen mainScreen].bounds.size.height - 70;
    self.locationBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, height, FRAME_WIDTH, 50)];
    self.locationBoxView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"location_inputbox"]];
    [self.view addSubview:self.locationBoxView];
    
    self.locationBoxImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 240, 38)];
    self.locationBoxImage.image = [UIImage imageNamed:@"location_starting_inputbox_press"];
    [self.locationBoxView addSubview:self.locationBoxImage];
    
    self.locationBoxField = [[UITextField alloc] initWithFrame:CGRectMake(53, 6, 188, 38)];
    self.locationBoxField.backgroundColor = [UIColor clearColor];
    self.locationBoxField.delegate = self;
    self.locationBoxField.returnKeyType = UIReturnKeySend;
    self.locationBoxField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.locationBoxField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.locationBoxField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.locationBoxField.placeholder = @"请输入出发地址";
    self.locationBoxField.font = [UIFont systemFontOfSize:14.0f];
    [self.locationBoxView addSubview:self.locationBoxField];
    
    self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 5, 59, 40)];
    [self.sureButton setImage:[UIImage imageNamed:@"location_starting_confirm_current"] forState:UIControlStateNormal];
    [self.sureButton setImage:[UIImage imageNamed:@"location_starting_confirm_press"] forState:UIControlStateHighlighted];
    self.sureButton.tag = 1;
    [self.sureButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBoxView addSubview:self.sureButton];
    
    [self updateParameters];
}
/**
 *  根据self.type改修UI
 */
-(void)updateParameters
{
    if (self.type ==1) {
        self.locationBoxImage.image = [UIImage imageNamed:@"location_starting_inputbox_press"];
        self.locationBoxField.placeholder = @"请输入出发地地址";
        [self.sureButton setImage:[UIImage imageNamed:@"location_starting_confirm_current"] forState:UIControlStateNormal];
        [self.sureButton setImage:[UIImage imageNamed:@"location_starting_confirm_press"] forState:UIControlStateHighlighted];
        
    }else if (self.type ==2){
        self.locationBoxImage.image = [UIImage imageNamed:@"location_ending_inputbox_press"];
        self.locationBoxField.placeholder = @"请输入目的地地址";
        [self.sureButton setImage:[UIImage imageNamed:@"location_starting_confirm_current"] forState:UIControlStateNormal];
        [self.sureButton setImage:[UIImage imageNamed:@"location_ending_confirm_press"] forState:UIControlStateHighlighted];
    
    }
}
- (void)clickButton:(UIButton*)button
{
    [self.locationBoxField resignFirstResponder];
    if ([self.locationBoxField text] && ![[self.locationBoxField text] isEqualToString:@""]) {
        self.sureButton.enabled = NO;
        self.address = self.locationBoxField.text;
        [self searchLocation:self.locationBoxField.text];
    }
}
/**
 *  初始化地图
 */
- (void)initMapView
{
    self.search = [[BMKSearch alloc] init];
    self.search.delegate = self;
    
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height)];
    self.mapView.backgroundColor = [UIColor whiteColor];
    self.mapView.delegate = self;
//    self.mapView.showsUserLocation = YES; //显示定位图层
    [self.view addSubview:self.mapView];
    
    self.coordinate = CLLocationCoordinate2DMake([[self.location objectForKey:@"latitude"] floatValue],
                                                 [[self.location objectForKey:@"longitude"] floatValue]);
    
    BMKCoordinateRegion region;
    BMKCoordinateSpan span;
    span.latitudeDelta=0.05;
    span.longitudeDelta=0.05;
    region.span = span;
    region.center = self.coordinate;
    
    self.mapView.mapType = BMKMapTypeStandard;
    [self.mapView setRegion:region animated:NO];
    [self.mapView regionThatFits:region];
    
    if (!self.pointAnnotation) {
        self.pointAnnotation = [[BMKPointAnnotation alloc]init];
        self.pointAnnotation.coordinate = self.coordinate;
        if (self.type==1) {
            self.pointAnnotation.title = @"出发地";
        }else if (self.type==2){
            self.pointAnnotation.title = @"目的地";
        }
        self.pointAnnotation.subtitle = [self.location objectForKey:@"address"];
        [self.mapView addAnnotation:self.pointAnnotation];
        
        self.mapView.showsUserLocation = NO;
    }
}
#pragma mark UITextFieldDelegate
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
//    NSLog(@"keyboardWillChangeFrame");
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    CGRect commentBoxRect = self.locationBoxView.frame;
    commentBoxRect.origin.y += yOffset;
    
    [UIView animateWithDuration:duration animations:^{
        self.locationBoxView.frame = commentBoxRect;
    }];
}
//按下回车键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.locationBoxField resignFirstResponder];
    if ([self.locationBoxField text] && ![[self.locationBoxField text] isEqualToString:@""]) {
        self.sureButton.enabled = NO;
        self.address = self.locationBoxField.text;
        [self searchLocation:self.locationBoxField.text];
    }
    return YES;
}
#pragma mark -
#pragma mark - BMKSearchDelegate
//返回地址信息搜索结果
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
//        self.mapView.userLocation.subtitle = result.strAddr;
        self.pointAnnotation.subtitle = result.strAddr;
        self.locationBoxField.placeholder = result.strAddr;
	}
}
/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self.locationBoxField resignFirstResponder];
    
//    NSLog(@"latitude:%f",mapView.centerCoordinate.latitude);
//    NSLog(@"latitude:%f",mapView.centerCoordinate.longitude);
//    self.pointAnnotation.coordinate = mapView.centerCoordinate;
    
}
/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    [self.locationBoxField resignFirstResponder];
    [mapView removeAnnotation:self.pointAnnotation];
    self.pointAnnotation = [[BMKPointAnnotation alloc]init];
    self.pointAnnotation.coordinate = coordinate;
    if (self.type==1) {
        self.pointAnnotation.title = @"出发地";
    }else if (self.type==2){
        self.pointAnnotation.title = @"目的地";
    }
    [self.mapView addAnnotation:self.pointAnnotation];
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    [self.search reverseGeocode:coordinate];
}
#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
//    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//    if (annotationView == nil) {
//        NSLog(@"chushi weikong:%@",annotationView);
        BMKAnnotationView * annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 从天上掉下效果
		((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
        // 设置可拖拽
		((BMKPinAnnotationView*)annotationView).draggable = YES;
        
        ((BMKPinAnnotationView*)annotationView).canShowCallout = TRUE;
        if (self.type==1) {
            annotationView.image = [UIImage imageNamed:@"location_starting"];
        }else if (self.type ==2){
            annotationView.image = [UIImage imageNamed:@"location_ending"];
        }
//    }
    return annotationView;
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPointAnnotation *anotation = (BMKPointAnnotation*)view.annotation;
        
        if (callBack) {
            callBack(self.type,[NSString stringWithFormat:@"%f",anotation.coordinate.latitude] ,
                     [NSString stringWithFormat:@"%f",anotation.coordinate.longitude],anotation.subtitle);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
/**
 *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
 *@param mapView 地图View
 *@param view annotation view
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState
{
    self.pointAnnotation = view.annotation;
    if (self.type==1) {
        self.pointAnnotation.title = @"出发地";
    }else if (self.type==2){
        self.pointAnnotation.title = @"目的地";
    }
    [self.search reverseGeocode:CLLocationCoordinate2DMake(self.pointAnnotation.coordinate.latitude, self.pointAnnotation.coordinate.longitude)];
}

/**
 *  填充数据
 *  调用的是百度地图Place API
 */
- (void)searchLocation:(NSString*)address
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?ak=%@&output=json&query=%@&page_size=20&page_num=%i&scope=1&region=%@",
                            SERVERAK,
                            [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            self.tableView.pageNumber,
                            [[AppDelegate sharedAppDelegate].locality stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    
    /*
     NSString *requestUrl = @"http://api.map.baidu.com/place/v2/search?";
     
    [request setPostValue:SERVERAK forKey:@"ak"];
    [request setPostValue:@"json" forKey:@"output"];
    [request setPostValue:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"query"];
    [request setPostValue:@"20" forKey:@"page_size"];
    [request setPostValue:@"0" forKey:@"page_num"];
    [request setPostValue:@"1" forKey:@"scope"];
    [request setPostValue:[self.appDelegate.locality stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"region"];
    //*/
    
    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:120];
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *error = [request error];
    if (!error){
        //发送消息
        if (request.tag==888){
            JSONDecoder *decoder=[JSONDecoder decoder];
            NSDictionary *dict=[decoder objectWithData:request.responseData];
            NSString *jsonString = [dict JSONString];
            
            NSDictionary * root = [jsonString objectFromJSONString];
            NSArray *entries = [root objectForKey:@"results"];
            
            if (self.tableView.pageNumber==0) {
                [self.tableView addFirstArray:[NSMutableArray arrayWithArray:entries]];
                self.tableView.pageNumber++;
                
                self.sureButton.enabled = YES;
                self.locationBoxField.text = @"";
            }else{
                [self.tableView addMoreArray:[NSMutableArray arrayWithArray:entries]];
                self.tableView.pageNumber++;
                [self.tableView footerEndRefreshing];
            }
            /*
            // 清楚屏幕中所有的annotation
            NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
            [self.mapView removeAnnotations:array];
            
            BMKPointAnnotation* item = nil;
            for (int i=0; i<[entries count]; i++) {
                NSDictionary* entry = [entries objectAtIndex:i];
                NSDictionary *location = [entry objectForKey:@"location"];
                NSString * name = [entry objectForKey:@"name"];
                NSString * address = [entry objectForKey:@"address"];
                NSString * lat = [location objectForKey:@"lat"];
                NSString * lng = [location objectForKey:@"lng"];
                NSLog(@"address:%@",address);
                
                item = [[BMKPointAnnotation alloc]init];
                item.coordinate = CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]);
                item.title = name;
                item.subtitle = address;
                [self.mapView addAnnotation:item];
                if (i ==0) {
                    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]) animated:YES];
                 }
             }
             //*/
            
        }
        self.locationBoxView.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            CGRect mapViewFrame = self.mapView.frame;
            mapViewFrame.size.height = 150;
            self.mapView.frame = mapViewFrame;
            
            CGRect tableViewFrame = self.tableView.frame;
            tableViewFrame.origin.y = 44+150;
            self.tableView.frame = tableViewFrame;
            
            
        }];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (request.tag==888){
        [self messageShow:@"网络繁忙，请稍后在试！"];
        self.sureButton.enabled = YES;
    }
}
/**
 *  初始化tabelView
 */
-(void)initTabelView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-150;
    self.tableView = [[DTTableView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, FRAME_WIDTH, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.separatorColor = RGBACOLOR(229, 229, 229, 0.5);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.pageNumber = 0;
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView addFooterWithCallback:^{
        [weakSelf searchLocation:weakSelf.address];
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableView.tableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary* entry = [self.tableView.tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [entry objectForKey:@"name"];
    cell.detailTextLabel.text = [entry objectForKey:@"address"];
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* entry = [self.tableView.tableArray objectAtIndex:indexPath.row];
    NSDictionary *location = [entry objectForKey:@"location"];
    
    [self.mapView removeAnnotation:self.pointAnnotation];
    self.pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue],[[location objectForKey:@"lng"] floatValue]);
    self.pointAnnotation.coordinate = coordinate;
    self.pointAnnotation.title = [entry objectForKey:@"name"];
    /*
    if (self.type==1) {
        self.pointAnnotation.title = @"出发地";
    }else if (self.type==2){
        self.pointAnnotation.title = @"目的地";
    }
     //*/
    [self.mapView addAnnotation:self.pointAnnotation];
//    self.mapView.zoomLevel = 14;
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    [self.search reverseGeocode:coordinate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (scrollView.contentOffset.y < -64) {
        [UIView animateWithDuration:0.25 animations:^{
            int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
            CGRect mapViewFrame = self.mapView.frame;
            mapViewFrame.size.height = height;
            self.mapView.frame = mapViewFrame;
            CGRect tableViewFrame = self.tableView.frame;
            tableViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
            self.tableView.frame = tableViewFrame;
        }completion:^(BOOL finished) {
            self.tableView.pageNumber = 0;
            self.locationBoxView.hidden = NO;
        }];
    }
}
@end
