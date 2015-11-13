//
//  CarInformationViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import "CarInformationViewController.h"
#import "ColorSetingViewController.h"
#import "CarNumberViewController.h"
#import "CarTypeViewController.h"
#import "BrandCar.h"
#import "CarInfomationCell.h"



@interface CarInformationViewController ()
{
    NSOperationQueue* queue;
}
@property(nonatomic,strong) TableView* tableView;

//获取用户汽车信息接口
- (void)getMyCarInfomation;

@end

@implementation CarInformationViewController

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
    
    NSLog(@"%@",self.navigationController);
    
    
    // Do any additional setup after loading the view.
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
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
    label.text = @"车辆信息";
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
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    //self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self getMyCarInfomation];
    
    
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3.0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    if (indexPath.section ==0) {
        
        NSString* cellidenty = @"cellID";
        
        CarInfomationCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
        
        if (cell ==nil) {
            
            cell = [[CarInfomationCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidenty];
            
        }
        
        cell.textLabel.textColor =RGBCOLOR(54.0, 54.0, 54.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"车型";
     
        
        if ([self.brandCar.carlogo isEqualToString:@"(null)"] ||[self.brandCar.carlogo isEqualToString:@""]||self.brandCar.carlogo ==nil ||[self.brandCar.carname isEqualToString:@"(null)"] ||self.brandCar.carname ==nil ||[self.brandCar.carname isEqualToString:@""]) {
            
           // [cell setcellInfomation:self.brandCar.carname carlogo:self.brandCar.carlogo];
            
            
        }else {
        
            
            [cell setcellInfomation:self.brandCar.carname carlogo:self.brandCar.carlogo];
        }
      
        return cell;


        
    }else if(indexPath.section ==1){
        
        NSString* cellidenty = @"cellID";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
        
        if (cell ==nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidenty];
            
        }
        
        cell.textLabel.textColor =RGBCOLOR(54.0, 54.0, 54.0);
        cell.detailTextLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);
        UIImage* arrImage = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        UIImageView* arrimageview = [[UIImageView alloc]init];
        arrimageview.frame = CGRectMake(300.0, 10.0,arrImage.size.width , arrImage.size.height);
        arrimageview.image = arrImage;
        cell.accessoryView = arrimageview;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = @"颜色";
        if ([self.brandCar.carColor isEqualToString:@""] ||[self.brandCar.carColor isEqualToString:@"(null)"] ||self.brandCar.carColor==nil) {
            
           cell.detailTextLabel.text = @"暂无";
            
        }else {
            cell.detailTextLabel.text = self.brandCar.carColor;
         }
        return cell;

        
    }else {
        NSString* cellidenty = @"cellID";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
        
        if (cell ==nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidenty];
            
        }
        
        cell.textLabel.textColor =RGBCOLOR(54.0, 54.0, 54.0);
        cell.detailTextLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);
        UIImage* arrImage = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        UIImageView* arrimageview = [[UIImageView alloc]init];
        arrimageview.frame = CGRectMake(300.0, 10.0,arrImage.size.width , arrImage.size.height);
        arrimageview.image = arrImage;
        cell.accessoryView = arrimageview;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

        cell.textLabel.text = @"车牌号";
        if ([self.brandCar.carPlace isEqualToString:@""] ||[self.brandCar.carNumber isEqualToString:@""] ||[self.brandCar.carPlace isEqualToString:@"(null)"] ||self.brandCar.carPlace==nil ||[self.brandCar.carNumber isEqualToString:@"(null)"] ||self.brandCar.carNumber ==nil) {
        cell.detailTextLabel.text = @"暂无";
            
        }else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",self.brandCar.carPlace,self.brandCar.carNumber];
        
        }
        
        return cell;

      }
    
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ( section ==0) {
        
        return 0.1;
    }
    return 4.0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        
        CarTypeViewController* colorSeting = [[CarTypeViewController alloc]init];
        [self.navigationController pushViewController:colorSeting animated:YES];
   
        
    }else if (indexPath.section ==1)
    {
    
        ColorSetingViewController* colorSeting = [[ColorSetingViewController alloc]init];
        colorSeting.car = self.brandCar;
        [self.navigationController pushViewController:colorSeting animated:YES];
        
    }else
    {
        CarNumberViewController* colorSeting = [[CarNumberViewController alloc]init];
        colorSeting.car = self.brandCar;
        [self.navigationController pushViewController:colorSeting animated:YES];
    }
}
- (void)backButtonMethod:(UIButton*)bt
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getMyCarInfomation
{
 // http://localhost:8080/myCar2/myCarService.jws?myCarDetail&l_key=
    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar2/myCarService.jws?myCarDetail", SERVERAPIURL];
    
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString* url = [NSString stringWithFormat:@"&l_key=%@",lkey];
    
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
-( void )reponseFaild:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
}
- (void)messageToast:(NSString*)msg
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    
    BrandCar* car = [[BrandCar alloc]init];
    NSDictionary* dic = [data objectForKey:@"obj"];
    car.carlogo = [dic objectForKey:@"carBrandLogo"];
    car.carname = [dic objectForKey:@"carSeriesName"];
    car.carBrandId = [dic objectForKey:@"carId"];
    car.carColor = [dic objectForKey:@"carColor"];
    car.carPlace = [dic objectForKey:@"carLocation"];
    car.carNumber = [dic objectForKey:@"carNumber"];
    self.brandCar = car;
    [self.tableView reloadData];
   
}





@end
