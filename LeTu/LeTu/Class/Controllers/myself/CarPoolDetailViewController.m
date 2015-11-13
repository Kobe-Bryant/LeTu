//
//  CarPoolDetailViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-22.
//
//

#import "CarPoolDetailViewController.h"
#import "CarPoolTableHeadView.h"
#import "CarPoolDetailCell.h"
#import "CarManagerModel.h"
#import "LeTuRouteModel.h"
#import "DejalActivityView.h"

#import "ApplyPersonModel.h"
#import "ActionButton.h"





@interface CarPoolDetailViewController ()
{
    NSOperationQueue* queue;
    MBProgressHUD* HUD;
    UIView* blankView;
    
    
}
@property(nonatomic,strong) TableView* tableView;
@property(nonatomic,strong) NSMutableArray* dataArray;
@property(nonatomic,strong)  CarPoolTableHeadView* tableHeadView;



//获取拼车信息。
- (void)getPincheInfomation;
- (void)getPincheInfomation:(ApplyPersonModel*)applyModel acceptType:(NSInteger)type;


@end

@implementation CarPoolDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    
    
    }
    return self;
}

-(id)initWithCarManagerModel:(LeTuRouteModel*)model
{
    self = [super init];
    if (self) {
    
        self.carModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
//    NSString* userID = [AppDelegate sharedAppDelegate].userModel.userId;
//    NSLog(@"USERID = %@",userID);
//    NSLog(@"model id = %@",self.carModel.userId);
//    
//    NSString* string =@"";
//
//    NSLog(@"userType = %d",self.carModel.userType);
//    if (self.carModel.userType ==1)//用户类型 1 ＝车主 2= 乘客
//    {
//        string = @"我是车主";
//        
//    }else if (self.carModel.userType ==2){
//    
//        string = @"我是乘客";
//    }
//    if ([self.carModel.userId isEqualToString:userID]) {
//      
//        string = [string stringByAppendingString:@",我发起的拼车"];
//        
//        NSLog(@"me");
//        
//        
//        
//    }else {
//        string = [string stringByAppendingString:@",我参与的拼车"];
//
//    }
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"" message:string delegate:nil cancelButtonTitle:nil otherButtonTitles:@"取消",nil];
//    [alertView show];
    
    
}
- (void)initUINavigationController
{
    
    UIImage *topBar = [UIImage imageNamed:@"meNavbg1.png"];
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, FRAME_WIDTH, topBar.size.height)];
    topBarImageView.image = topBar;
 //   topBarImageView.backgroundColor =  RGBCOLOR(15, 100, 114);
    topBarImageView.userInteractionEnabled = YES;
    [self.view addSubview:topBarImageView];
    
    NSLog(@"%f",topBar.size.height);
    
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(140.0, 20.0, 220, 44)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"拼车";
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
    
    
    UIImage* moreImage = [UIImage imageNamed:@"meMorePre.png"];
    UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(285.0, 20+(44-moreImage.size.height)/2.0, moreImage.size.width, moreImage.size.height);
    [moreButton setImage:moreImage forState:UIControlStateNormal];
    moreButton.backgroundColor = [UIColor clearColor];
    moreButton.tag = 2;
    [moreButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [topBarImageView addSubview:moreButton];
    NSLog(@"%f",self.view.frame.size.height);
    
    CGFloat height = self.view.frame.size.height - topBar.size.height;
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0,topBar.size.height, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    [self.view addSubview:self.tableView];
    
    self.tableHeadView = [[CarPoolTableHeadView alloc]init];
    UIImage* image = [UIImage imageNamed:@"meNavbg2.png"];
    _tableHeadView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, image.size.height);
    _tableHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"meNavbg2.png"]];;
    [_tableHeadView setTableHeadViewInformation:self.carModel];
    self.tableView.tableHeaderView = _tableHeadView;
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    self.dataArray = [NSMutableArray array];
    [self getPincheInfomation];

 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count+1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CarPoolTableViewCellStyle style;
    
     if (indexPath.row ==0) {
        
        style = CarPoolDetailTableViewFirstCell;
        
    }else {
     
         style = CarPoolDetailTableViewMiddleCell;
         
     }
    
    //拼车管理cell
    CarPoolDetailCell* cell = [[CarPoolDetailCell alloc]initWithStyle:UITableViewCellStyleDefault customCellStyle:style];
    cell.clickButtonDelegate = self;
    cell.model = self.carModel;
    if (self.dataArray.count >=1) {
    
        if (indexPath.row !=0) {
            cell.applyModel = self.dataArray[indexPath.row-1];
            [cell setCellInfomation:self.dataArray[indexPath.row-1]];
        }else {
        
            [cell setCellInfomation:nil];
            
        }
    
    }
    
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0 ) {
      
        return 40.0;
        
    }else
    {
    
        return 60.0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}
- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
        
     [self.navigationController popViewControllerAnimated:YES];
      
    }else {
        
        NSString* message =@"";
        NSInteger tag;
        if (self.carModel.userType ==1) {
        
          message = @"退出本次活动";
            tag = 100;
            
        }else if(self.carModel.userType==2){
        
          message = @"退出本次拼车";
            tag =101;
        }
        
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:message,nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleBlackOpaque;
        actionSheet.tag = tag;
        [actionSheet showInView:self.view];
     }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    [self backMethod];
    
    
    NSLog(@"%d",buttonIndex);
}

- (void)backMethod
{
  
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?deleteCarSharing&id=%@&l_key=%@", SERVERAPIURL,self.carModel.letuId,lkey];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 14;
    [queue addOperation :operation];


}

- (void)getPincheInfomation
{
   
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?get&id=%@&l_key=%@", SERVERAPIURL,self.carModel.letuId,lkey];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}

- (void)againGetPincheInfomation
{
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?get&id=%@&l_key=%@", SERVERAPIURL,self.carModel.letuId,lkey];
    
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 3;
    [queue addOperation :operation];
  
}
- (void)againagainGetPincheInfomation
{
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?get&id=%@&l_key=%@", SERVERAPIURL,self.carModel.letuId,lkey];
    
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 5;
    [queue addOperation :operation];
    
}

-(void)stopLoading{
    
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.removeFromSuperViewOnHide = YES;
    
    if (HUD !=nil) {
        HUD.hidden = YES;
    }
    [blankView removeFromSuperview];
    blankView = nil;
    [DejalActivityView removeView];
    
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }

    if (tag ==1) {
    
        NSLog(@"%d",self.dataArray.count);
        self.dataArray =[NSMutableArray array];
        NSDictionary* dic = [data objectForKey:@"obj"];
        LeTuRouteModel* model = [[LeTuRouteModel alloc]init];
        model.applyCount = [[dic objectForKey:@"applyCount"] integerValue];
        model.carId = [[dic objectForKey:@"carId"] integerValue];
        model.carPhoto =[dic objectForKey:@"carPhoto"];
        model.carName = [dic objectForKey:@"carSeriesName"];
        model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
        model.carLocation = [dic objectForKey:@"carLocation"];
        model.carNumber = [[dic objectForKey:@"carNumber"] integerValue];
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
        model.seatLeftCount = [[dic objectForKey:@"seatingLeft2"] integerValue];
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
        
        NSArray* applyArray = [dic objectForKey:@"applys"];
        
        for (NSDictionary* smallDic  in applyArray) {
        
            NSInteger  status = [[smallDic objectForKey:@"status"] integerValue];
            
            NSLog(@"status = %d",status);
            
            if (status !=-1  && status!= -2) {
                ApplyPersonModel* model = [[ApplyPersonModel alloc]init];
                model.favoriteCount = [[smallDic objectForKey:@"favoriteCount"] integerValue];
                model.PinCheId =[smallDic objectForKey:@"id"];
                model.newApply =[[smallDic objectForKey:@"newApply"] integerValue];
                model.relationType = [[smallDic objectForKey:@"relationType"] integerValue];
                model.status = [[smallDic objectForKey:@"status"] integerValue];
                model.userAge = [[smallDic objectForKey:@"userAge"] integerValue];
                model.userGender = [[smallDic objectForKey:@"userGender"] integerValue];
                model.userId = [smallDic objectForKey:@"userId"];
                model.userName = [smallDic objectForKey:@"userName"];
                model.userPhoto = [smallDic objectForKey:@"userPhoto"];
                model.userSign = [smallDic objectForKey:@"userSign"];
                model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
                model.carLocation = [dic objectForKey:@"carLocation"];
                model.carNumber = [dic objectForKey:@"carNumber"];
                model.carLocation = [dic objectForKey:@"carSeriesName"];
                [self.dataArray addObject:model];
            }
            
        }
        NSLog(@"self.dataArray.count = %d",self.dataArray.count);
    
        self.carModel = model;
        NSMutableArray* countArray = [NSMutableArray array];
        for (ApplyPersonModel* model in self.dataArray) {
            if (model.status ==1) {
                [countArray addObject:model];
                
            }
        }
        
        self.carModel.seatLeftCount= self.carModel.seatLeftCount -countArray.count;
        [_tableHeadView setTableHeadViewInformation:self.carModel];
        [self.tableView reloadData];
        
      }else if (tag ==2){
    
         NSLog(@"%d",tag);
         
        [self againGetPincheInfomation];
         
         
       }else if(tag ==3){
         
           NSLog(@"%d",self.dataArray.count);
           self.dataArray =[NSMutableArray array];
           NSDictionary* dic = [data objectForKey:@"obj"];
           LeTuRouteModel* model = [[LeTuRouteModel alloc]init];
           model.applyCount = [[dic objectForKey:@"applyCount"] integerValue];
           model.carId = [[dic objectForKey:@"carId"] integerValue];
           model.carPhoto =[dic objectForKey:@"carPhoto"];
           model.carName = [dic objectForKey:@"carSeriesName"];
           model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
           model.carLocation = [dic objectForKey:@"carLocation"];
           model.carNumber = [[dic objectForKey:@"carNumber"] integerValue];
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
           model.seatLeftCount = [[dic objectForKey:@"seatingLeft2"] integerValue];
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
           
           NSArray* applyArray = [dic objectForKey:@"applys"];
           
           for (NSDictionary* smallDic  in applyArray) {
               
               ApplyPersonModel* model = [[ApplyPersonModel alloc]init];
               model.favoriteCount = [[smallDic objectForKey:@"favoriteCount"] integerValue];
               model.PinCheId =[smallDic objectForKey:@"id"];
               model.newApply =[[smallDic objectForKey:@"newApply"] integerValue];
               model.relationType = [[smallDic objectForKey:@"relationType"] integerValue];
               model.status = [[smallDic objectForKey:@"status"] integerValue];
               model.userAge = [[smallDic objectForKey:@"userAge"] integerValue];
               model.userGender = [[smallDic objectForKey:@"userGender"] integerValue];
               model.userId = [smallDic objectForKey:@"userId"];
               model.userName = [smallDic objectForKey:@"userName"];
               model.userPhoto = [smallDic objectForKey:@"userPhoto"];
               model.userSign = [smallDic objectForKey:@"userSign"];
               model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
               model.carLocation = [dic objectForKey:@"carLocation"];
               model.carNumber = [dic objectForKey:@"carNumber"];
               model.carLocation = [dic objectForKey:@"carSeriesName"];
               [self.dataArray addObject:model];
               
           }
           NSLog(@"self.dataArray.count = %d",self.dataArray.count);
           
           self.carModel = model;
            NSMutableArray* countArray = [NSMutableArray array];
           for (ApplyPersonModel* model in self.dataArray) {
               if (model.status ==1) {
                [countArray addObject:model];
                   
               }
            }
           
           self.carModel.seatLeftCount= self.carModel.seatLeftCount -countArray.count;
           
           [_tableHeadView setTableHeadViewInformation:self.carModel];
          [self.tableView reloadData];
       }else if (tag ==4){
       
           [self againagainGetPincheInfomation];
           
           
       }else if (tag ==5){
       
           NSLog(@"%d",self.dataArray.count);
           self.dataArray =[NSMutableArray array];
           NSDictionary* dic = [data objectForKey:@"obj"];
           LeTuRouteModel* model = [[LeTuRouteModel alloc]init];
           model.applyCount = [[dic objectForKey:@"applyCount"] integerValue];
           model.carId = [[dic objectForKey:@"carId"] integerValue];
           model.carPhoto =[dic objectForKey:@"carPhoto"];
           model.carName = [dic objectForKey:@"carSeriesName"];
           model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
           model.carLocation = [dic objectForKey:@"carLocation"];
           model.carNumber = [[dic objectForKey:@"carNumber"] integerValue];
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
           model.seatLeftCount = [[dic objectForKey:@"seatingLeft2"] integerValue];
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
           
           NSArray* applyArray = [dic objectForKey:@"applys"];
           
           for (NSDictionary* smallDic  in applyArray) {
               NSInteger  status = [[smallDic objectForKey:@"status"] integerValue];
               
               NSLog(@"status = %d",status);
               
               if (status !=-1) {
                   ApplyPersonModel* model = [[ApplyPersonModel alloc]init];
                   model.favoriteCount = [[smallDic objectForKey:@"favoriteCount"] integerValue];
                   model.PinCheId =[smallDic objectForKey:@"id"];
                   model.newApply =[[smallDic objectForKey:@"newApply"] integerValue];
                   model.relationType = [[smallDic objectForKey:@"relationType"] integerValue];
                   model.status = [[smallDic objectForKey:@"status"] integerValue];
                   model.userAge = [[smallDic objectForKey:@"userAge"] integerValue];
                   model.userGender = [[smallDic objectForKey:@"userGender"] integerValue];
                   model.userId = [smallDic objectForKey:@"userId"];
                   model.userName = [smallDic objectForKey:@"userName"];
                   model.userPhoto = [smallDic objectForKey:@"userPhoto"];
                   model.userSign = [smallDic objectForKey:@"userSign"];
                   model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
                   model.carLocation = [dic objectForKey:@"carLocation"];
                   model.carNumber = [dic objectForKey:@"carNumber"];
                   model.carLocation = [dic objectForKey:@"carSeriesName"];
                   [self.dataArray addObject:model];
                   
               }

               
               }
         NSLog(@"self.dataArray.count = %d",self.dataArray.count);
         self.carModel = model;
           NSMutableArray* countArray = [NSMutableArray array];
           for (ApplyPersonModel* model in self.dataArray) {
               if (model.status ==1) {
                   [countArray addObject:model];
                   
               }
           }
           
           self.carModel.seatLeftCount= self.carModel.seatLeftCount -countArray.count;
           
           [_tableHeadView setTableHeadViewInformation:self.carModel];
           [self.tableView reloadData];
           
       
       }else if (tag ==6)
       {
       
           [self againTwoagainGetPincheInfomation];
           
           
       }else if (tag ==7){
           
           NSLog(@"%d",self.dataArray.count);
           self.dataArray =[NSMutableArray array];
           [self.tableView reloadData];
           [self.navigationController popViewControllerAnimated:YES];
       } else if (tag ==8){
       
           [self threeagainagainGetPincheInfomation];
           
        }else if (tag ==9){
       
            NSLog(@"%d",self.dataArray.count);
            self.dataArray =[NSMutableArray array];
            NSDictionary* dic = [data objectForKey:@"obj"];
            LeTuRouteModel* model = [[LeTuRouteModel alloc]init];
            model.applyCount = [[dic objectForKey:@"applyCount"] integerValue];
            model.carId = [[dic objectForKey:@"carId"] integerValue];
            model.carPhoto =[dic objectForKey:@"carPhoto"];
            model.carName = [dic objectForKey:@"carSeriesName"];
            model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
            model.carLocation = [dic objectForKey:@"carLocation"];
            model.carNumber = [[dic objectForKey:@"carNumber"] integerValue];
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
            model.seatLeftCount = [[dic objectForKey:@"seatingLeft2"] integerValue];
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
            
            NSArray* applyArray = [dic objectForKey:@"applys"];
            
            for (NSDictionary* smallDic  in applyArray) {
                
                ApplyPersonModel* model = [[ApplyPersonModel alloc]init];
                model.favoriteCount = [[smallDic objectForKey:@"favoriteCount"] integerValue];
                model.PinCheId =[smallDic objectForKey:@"id"];
                model.newApply =[[smallDic objectForKey:@"newApply"] integerValue];
                model.relationType = [[smallDic objectForKey:@"relationType"] integerValue];
                model.status = [[smallDic objectForKey:@"status"] integerValue];
                model.userAge = [[smallDic objectForKey:@"userAge"] integerValue];
                model.userGender = [[smallDic objectForKey:@"userGender"] integerValue];
                model.userId = [smallDic objectForKey:@"userId"];
                model.userName = [smallDic objectForKey:@"userName"];
                model.userPhoto = [smallDic objectForKey:@"userPhoto"];
                model.userSign = [smallDic objectForKey:@"userSign"];
                model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
                model.carLocation = [dic objectForKey:@"carLocation"];
                model.carNumber = [dic objectForKey:@"carNumber"];
                model.carLocation = [dic objectForKey:@"carSeriesName"];
                [self.dataArray addObject:model];
                
            }
            NSLog(@"self.dataArray.count = %d",self.dataArray.count);
            
            self.carModel = model;
            NSMutableArray* countArray = [NSMutableArray array];
            for (ApplyPersonModel* model in self.dataArray) {
                if (model.status ==1) {
                    [countArray addObject:model];
                    
                }
            }
            
            self.carModel.seatLeftCount= self.carModel.seatLeftCount -countArray.count;
            
            [_tableHeadView setTableHeadViewInformation:self.carModel];
            [self.tableView reloadData];
        } else if (tag ==10){
        
        
            [self fouragainagainGetPincheInfomation];
            
        
        }else if (tag ==11){
        
            NSLog(@"%d",self.dataArray.count);
            self.dataArray =[NSMutableArray array];
            NSDictionary* dic = [data objectForKey:@"obj"];
            LeTuRouteModel* model = [[LeTuRouteModel alloc]init];
            model.applyCount = [[dic objectForKey:@"applyCount"] integerValue];
            model.carId = [[dic objectForKey:@"carId"] integerValue];
            model.carPhoto =[dic objectForKey:@"carPhoto"];
            model.carName = [dic objectForKey:@"carSeriesName"];
            model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
            model.carLocation = [dic objectForKey:@"carLocation"];
            model.carNumber = [[dic objectForKey:@"carNumber"] integerValue];
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
            model.seatLeftCount = [[dic objectForKey:@"seatingLeft2"] integerValue];
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
            
            NSArray* applyArray = [dic objectForKey:@"applys"];
            
            for (NSDictionary* smallDic  in applyArray) {
                NSInteger  status = [[smallDic objectForKey:@"status"] integerValue];
                
                NSLog(@"status = %d",status);
                
                if (status !=-1) {
                    ApplyPersonModel* model = [[ApplyPersonModel alloc]init];
                    model.favoriteCount = [[smallDic objectForKey:@"favoriteCount"] integerValue];
                    model.PinCheId =[smallDic objectForKey:@"id"];
                    model.newApply =[[smallDic objectForKey:@"newApply"] integerValue];
                    model.relationType = [[smallDic objectForKey:@"relationType"] integerValue];
                    model.status = [[smallDic objectForKey:@"status"] integerValue];
                    model.userAge = [[smallDic objectForKey:@"userAge"] integerValue];
                    model.userGender = [[smallDic objectForKey:@"userGender"] integerValue];
                    model.userId = [smallDic objectForKey:@"userId"];
                    model.userName = [smallDic objectForKey:@"userName"];
                    model.userPhoto = [smallDic objectForKey:@"userPhoto"];
                    model.userSign = [smallDic objectForKey:@"userSign"];
                    model.carBrandLogo = [dic objectForKey:@"carBrandLogo"];
                    model.carLocation = [dic objectForKey:@"carLocation"];
                    model.carNumber = [dic objectForKey:@"carNumber"];
                    model.carLocation = [dic objectForKey:@"carSeriesName"];
                    [self.dataArray addObject:model];
                    
                }
                
                
            }
            NSLog(@"self.dataArray.count = %d",self.dataArray.count);
            self.carModel = model;
            NSMutableArray* countArray = [NSMutableArray array];
            for (ApplyPersonModel* model in self.dataArray) {
                if (model.status ==1) {
                    [countArray addObject:model];
                    
                }
            }
            
            self.carModel.seatLeftCount= self.carModel.seatLeftCount -countArray.count;
            
            [_tableHeadView setTableHeadViewInformation:self.carModel];
            [self.tableView reloadData];
        } else if (tag ==12){
        
            [self fiveagainagainGetPincheInfomation];
            
        }else if (tag ==13){
        
            NSLog(@"%d",self.dataArray.count);
            self.dataArray =[NSMutableArray array];
            [self.tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (tag ==14){
        
            [self.navigationController popViewControllerAnimated:YES];
        
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
    [self stopLoading];
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
            [self stopLoading];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:errMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        
    }else{
        [self stopLoading];
        //[self messageToast:@"无法连接服务器,请检查您的网络或稍后重试"];
    }
}
//接受调用的方法 //车主发布线路，点击接受触发的方法。
- (void)refreshTableViewHeadView:(ApplyPersonModel*)model acceptType:(NSInteger)type
{
 [self getPincheInfomation:model acceptType:type];
}
- (void)getPincheInfomation:(ApplyPersonModel *)applyModel acceptType:(NSInteger)type
{
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?updateApply&id=%@&status=%d&l_key=%@", SERVERAPIURL,applyModel.PinCheId,type,lkey];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 2;
    [queue addOperation :operation];

}

//取消调用的方法  车主发起的活动，并取消调用的方法
- (void)cancelTableViewHeadView:(ApplyPersonModel*)model cancelType:(NSInteger)type
{
    [self getPincheInfomation:model cancelType:type];
}
- (void)getPincheInfomation:(ApplyPersonModel *)applyModel cancelType:(NSInteger)type
{
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?updateApply&id=%@&status=%d&l_key=%@", SERVERAPIURL,applyModel.PinCheId,type,lkey];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 4;
    [queue addOperation :operation];

}
//取消调用的方法  车主发起的活动，乘客参与并取消调用的方法
- (void)coustomCancelTableViewHeadView:(ApplyPersonModel*)model cancelType:(NSInteger)type
{
    [self getPincheInfomation:model CoustomCancelType:type];

}
- (void)getPincheInfomation:(ApplyPersonModel*)model CoustomCancelType:(NSInteger)type
{
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?updateApply&id=%@&status=%d&l_key=%@", SERVERAPIURL,model.PinCheId,type,lkey];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 6;
    [queue addOperation :operation];

}
- (void)againTwoagainGetPincheInfomation
{
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?get&id=%@&l_key=%@", SERVERAPIURL,self.carModel.letuId,lkey];
    
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 7;
    [queue addOperation :operation];
    
}
//接受乘客调用的方法 当前为乘客发布并点击接受按钮的动作。
- (void)coustomRefreshTableViewHeadView:(ApplyPersonModel*)model coustomAcceptType:(NSInteger)type
{

    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?updateApply&id=%@&status=%d&l_key=%@", SERVERAPIURL,model.PinCheId,type,lkey];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag =8;
    [queue addOperation :operation];


}
- (void)threeagainagainGetPincheInfomation
{
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?get&id=%@&l_key=%@", SERVERAPIURL,self.carModel.letuId,lkey];
    
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 9;
    [queue addOperation :operation];
    
}

//取消调用的方法 //乘客发起活动，并取消调用的方法
- (void)coustomFAqiCancelTableViewHeadView:(ApplyPersonModel*)model cancelType:(NSInteger)type
{
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?updateApply&id=%@&status=%d&l_key=%@", SERVERAPIURL,model.PinCheId,type,lkey];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 10;
    [queue addOperation :operation];
    
    
    
}
- (void)fouragainagainGetPincheInfomation
{
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?get&id=%@&l_key=%@", SERVERAPIURL,self.carModel.letuId,lkey];
    
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 11;
    [queue addOperation :operation];
    
}


//取消调用的方法 //乘客发起活动 ，车主参与取消方法
- (void)cheZhuCancelTableViewHeadView:(ApplyPersonModel*)model cancelType:(NSInteger)type
{
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?updateApply&id=%@&status=%d&l_key=%@", SERVERAPIURL,model.PinCheId,type,lkey];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 12;
    [queue addOperation :operation];


}
- (void)fiveagainagainGetPincheInfomation
{
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?get&id=%@&l_key=%@", SERVERAPIURL,self.carModel.letuId,lkey];
    
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 13;
    [queue addOperation :operation];
    
}

@end
