//
//  MyCollectViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-19.
//
//

#import "MyCollectViewController.h"
#import "MyCollectCell.h"
#import "LeTuRouteModel.h"


#define PageSize 10


@interface MyCollectViewController ()
{
    NSOperationQueue* queue;
    
}
@property(nonatomic,strong) TableView* tableView;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) NSMutableArray* dataArray;



//获取我收藏的车子信息。
- (void)getMycollectCarInfomation;


@end

@implementation MyCollectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
    self.dataArray = [NSMutableArray array];
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    self.currentPage = 0;
    
}
- (void)initUINavigationController
{
    UIImage *topBar = [UIImage imageNamed:@"navBg.png"];
    
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, FRAME_WIDTH, topBar.size.height)];
    topBarImageView.image = topBar;
    topBarImageView.userInteractionEnabled = YES;
    [self.view addSubview:topBarImageView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 20.0, 220, 44)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"我的收藏";
    label.backgroundColor = [UIColor clearColor];
    [topBarImageView addSubview:label];
    
    UIImage* backImage = [UIImage imageNamed:@"topBack.png"];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10.0, 20.0, 80.0, 40.0);
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -35.0, 0.0, 0.0);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.tag = 1;
    [backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [topBarImageView addSubview:backButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height-64.0) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self getMycollectCarInfomation];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellidenty = @"cellID";
    MyCollectCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (cell ==nil) {
        
        cell = [[MyCollectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidenty];
    }
    
    if (indexPath.row != self.dataArray.count) {
        UIView* view = [[UIView alloc]init];
        view.frame = CGRectMake(0.0, 115.0, self.view.frame.size.width, 5.0);
        view.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
        [cell.contentView addSubview:view];
    }
    [cell setCellInfomation:self.dataArray[indexPath.row]];
    
     return cell;
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ( section ==0) {
        
        return 10.0;
    }
    return 0.0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)backButtonMethod:(UIButton*)bt
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//获取收藏信息
- (void)getMycollectCarInfomation
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/carsharing/carSharingService.jws?myList", SERVERAPIURL];
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString* url = [NSString stringWithFormat:@"&l_key=%@&type=%d&page_size=%d&page_no=%d",lkey,2,PageSize,self.currentPage];
    NSString* lastUrl = [requestUrl stringByAppendingString:url];
   if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:lastUrl delegate:self];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)responseNotify:( id )sender
{
    RequestParseOperation * operation=( RequestParseOperation *)sender;
    
    NSDictionary *dictionary = operation.data;
    ErrorModel *error = [[ErrorModel alloc] initWithDataDict:[dictionary valueForKey:@"error"]];
    
    if (error == nil) {
        NSLog(@"------errCode=null---------");
    }
    if (error != nil && error.err_code != nil)
    {
        
        
        NSInteger errCode = [error.err_code  intValue];
        NSString *errMsg = error.err_msg;
        NSLog(@"------errCode-----%d----",errCode);
        
        if (errCode == -1) {
            SHOWLOGINVIEW;
        } else if (errCode < 2)
        {
            [self reponseDatas:operation.data operationTag:operation.RequestTag];
            
        }
        else {
            [self reponseFaild:operation.RequestTag];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:errMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else{
        [self messageToast:@"无法连接服务器,请检查您的网络或稍后重试"];
    }
    
}
- (void)messageToast:(NSString*)msg
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}
-( void )reponseFaild:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    NSLog(@"data = %@",data);
    
    NSArray* listArray = [data objectForKey:@"list"];
    NSLog(@"arr= %d",listArray.count);
    
    for (NSDictionary* dic  in listArray) {
        
        LeTuRouteModel* model = [[LeTuRouteModel alloc]init];
        model.applyCount = [[dic objectForKey:@"applyCount"] integerValue];
        model.carId = [[dic objectForKey:@"carId"] integerValue];
        model.carPhoto =[dic objectForKey:@"carPhoto"];
        model.carName = [dic objectForKey:@"carSeriesName"];
        model.distanceString = [dic objectForKey:@"distance"];
        model.collectCount = [[dic objectForKey:@"favoriteCount"] integerValue];
        model.fee = [[dic objectForKey:@"fee"] integerValue];
        model.free = [[dic objectForKey:@"free"] integerValue];
        model.letuId = [dic objectForKey:@"id"];
        NSString* latitudeEnd = [dic objectForKey:@"longitudeEnd"];
        NSString* latitudeStart = [dic objectForKey:@"latitudeEnd"];
        CLLocationCoordinate2D endCoordinate2D = {[latitudeEnd floatValue],[latitudeStart floatValue]};
        model.destinationLocationCoordinate2D = endCoordinate2D;
        model.loginName = [dic objectForKey:@"loginName"];
        NSString* orginlatitudestar = [dic objectForKey:@"longitudeStart"];
        NSString* orginlatitudeStart = [dic objectForKey:@"latitudeStart"];
        CLLocationCoordinate2D starCoordinate2D = {[orginlatitudestar floatValue],[orginlatitudeStart floatValue]};
        model.originLocationCoordinate2D = starCoordinate2D;
        model.payType = [[dic objectForKey:@"payType"] integerValue];
        NSString* phoneLatitude = [dic objectForKey:@"phoneLongitude"];
        NSString* phoneLongitude = [dic objectForKey:@"phoneLatitude"];
        CLLocationCoordinate2D iphoneCoordinate2D = {[phoneLatitude floatValue],[phoneLongitude floatValue]};
        model.createLocationCoordinate2D = iphoneCoordinate2D;
        model.relationType = [dic objectForKey:@"relationType"];
        model.remark = [dic objectForKey:@"remark"];
        model.routeEndPlace = [dic objectForKey:@"routeEnd"];
        model.routeStartPlace = [dic objectForKey:@"routeStart"];
        model.seatCount = [[dic objectForKey:@"seating"] integerValue];
        model.seatLeftCount = [[dic objectForKey:@"seatingLeft"] integerValue];
        model.shareType = [[dic objectForKey:@"shareType"] integerValue];
        model.startTime = [dic objectForKey:@"startTime"];
        model.status = [[dic objectForKey:@"status"] integerValue];
        model.userAge = [[dic objectForKey:@"userAge"] integerValue];
        model.userGender = [[dic objectForKey:@"userGender"] integerValue];
        model.userId = [dic objectForKey:@"userId"];
        model.userName = [dic objectForKey:@"userName"];
        model.userPhoto = [dic objectForKey:@"userPhoto"];
        model.userSign = [dic objectForKey:@"userSign"];
        model.userType = [[dic objectForKey:@"userType"] integerValue];
        [self.dataArray addObject:model];
        
    }
    
    [self.tableView reloadData];
    
    
}



@end
