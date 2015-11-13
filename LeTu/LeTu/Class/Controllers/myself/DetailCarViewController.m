//
//  DetailCarViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-25.
//
//

#import "DetailCarViewController.h"
#import "BrandCar.h"
#import "CarInformationViewController.h"
#import "PublicCell.h"


@interface DetailCarViewController ()
{
    NSOperationQueue* queue;
    

}
@property(nonatomic,strong) UITableView* tableview;
@property(nonatomic,strong) NSMutableArray*  carSeriesArray;
@property(nonatomic,strong) NSMutableArray* carNameArray;
@property(nonatomic,strong) NSMutableArray* selectArray;
@property(nonatomic,strong) UIImageView* avatorImageView;
@property(nonatomic,strong) NSString* carId;
@end

@implementation DetailCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@",self.navigationController);
    self.carNameArray = [NSMutableArray array];
    self.carSeriesArray = [NSMutableArray array];
    
    self.view.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
    // Do any additional setup after loading the view.
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    self.selectArray =[NSMutableArray array];
    
    
}
- (void)initUINavigationController
{
    UIImage *topBar = [UIImage imageNamed:@"navBg.png"];
    
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, FRAME_WIDTH, topBar.size.height)];
    topBarImageView.image = topBar;
    topBarImageView.userInteractionEnabled = YES;
    [self.view addSubview:topBarImageView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 20.0, 220, 44)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"选择车辆";
    label.backgroundColor = [UIColor clearColor];
    [topBarImageView addSubview:label];
    
    UIImage* backImage = [UIImage imageNamed:@"topBack.png"];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 20.0, 80.0, 40.0);
    [backButton setImage:backImage forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -40.0, 0, 0);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.tag = 1;
    [backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [topBarImageView addSubview:backButton];
    
    
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(230.0, 25.0, 80.0, 40.0);
    [sureButton setTitle:@"保存" forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0);
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 2;
    [topBarImageView addSubview:sureButton];
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.tableview.backgroundColor = RGBCOLOR(238, 238, 238);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorColor =[UIColor clearColor];
    [self.view addSubview:self.tableview];
    
    [self getDetailCarInfomation];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carNameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   static NSString *CellIdentifier = @"Cell";
    PublicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[PublicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.selectArray containsObject:indexPath]) {
        
        UIImage* image = [UIImage imageNamed:@"meCheck.png"];
        self.avatorImageView = [[UIImageView alloc] init];
        self.avatorImageView.frame = CGRectMake(280.0, 15.0, image.size.width, image.size.height);
        self.avatorImageView.image = image;
        cell.accessoryView = self.avatorImageView;
        
    }else {
        
        cell.accessoryView = nil;
        
        
    }
  
    
    cell.textLabel.text = self.carNameArray[indexPath.row];
       return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.selectArray containsObject:indexPath]) {
        
        [self.selectArray removeAllObjects];
        
        [self.selectArray addObject:indexPath];
        
        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableview reloadData];
    }
    
    if (self.selectArray.count > 0) {
        
        self.carId = self.carSeriesArray[indexPath.row];
    }
    
}

- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {

        CarInformationViewController* vc = [self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:vc animated:YES];
     }else {
 
         if (self.carId !=nil) {
          
             [self updateCarname:self.carId];
             
         }else {
         
             [self messageToast:@"请选择您的汽车名"];
 
             
         }
         
         
      }
}
- (void)updateCarname:(NSString*)carSeriousId
{
  
    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar2/myCarService.jws?changeMyCar", SERVERAPIURL];
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:carSeriousId forKey:@"carSeriesId"];
    [param setObject:lkey forKey:@"l_key"];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:param];
    [queue addOperation :operation];
}

-( void )reponseFaild:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
}
- (void)getDetailCarInfomation
{

    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar2/myCarService.jws?carSeriesList", SERVERAPIURL];
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString* url = [NSString stringWithFormat:@"&carBrandId=%@&l_key=%@",self.brandCar.carBrandId,lkey];
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
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    
    if (tag ==1) {
        
        NSArray* listArray = [data objectForKey:@"list"];
        for (NSDictionary* dic  in listArray) {
            NSString* carname = [dic objectForKey:@"name"];
            NSString* carSeriesId = [dic objectForKey:@"carSeriesId"];
            [self.carNameArray addObject:carname];
            [self.carSeriesArray addObject:carSeriesId];
        }
        [self.tableview reloadData];
        
    }else {
    
        [self messageToast:@"车名信息修改成功"];
      
        
      CarInformationViewController* carVC = [self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:carVC animated:YES];
    
   }
    
 
    

}


@end
