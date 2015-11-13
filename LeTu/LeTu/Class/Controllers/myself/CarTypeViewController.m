//
//  CarTypeViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-25.
//
//

#import "CarTypeViewController.h"
#import "CarTypeCell.h"
#import "BrandCar.h"
#import "DetailCarViewController.h"



@interface CarTypeViewController ()
{
    NSOperationQueue* queue;
    

}
@property(nonatomic,strong) TableView* tableView;
@property(nonatomic,strong) NSMutableArray* carArray;
@property(nonatomic,strong) NSMutableArray* titleArray;
@property(nonatomic,strong) NSMutableArray* ABCArray;


//获取汽车信息。
- (void)getCarInfomation;



@end

@implementation CarTypeViewController

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
    self.carArray = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    self.view.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    self.ABCArray =[NSMutableArray array];
    

    
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
    label.text = @"车型";
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
    
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(230.0, 25.0, 80.0, 40.0);
    [sureButton setTitle:@"保存" forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0);
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 2;
    [topBarImageView addSubview:sureButton];
    
}
- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
    
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else {
    
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat hight = self.view.frame.size.height - 74.0;
    
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(15,64.0+10.0, self.view.frame.size.width- 15.0*2, hight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self getCarInfomation];

    
}
#pragma mark tableViewDelegate
/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
    
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.ABCArray;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    return [CarTypeCell getCellHeight:self.carArray[indexPath.row]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CarTypeCell* cell = [[CarTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.carDelegate = self;
    [cell setCellInfomation:self.carArray[indexPath.row] title:self.titleArray[indexPath.row]];
     return cell;
}
- (void)clickCar:(BrandCar*)car
{
    DetailCarViewController* detail = [[DetailCarViewController alloc]init];
    detail.brandCar= car;
    [self.navigationController pushViewController:detail animated:YES];
}
//获取汽车信息。
- (void)getCarInfomation
{

    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar2/myCarService.jws?carBrandList", SERVERAPIURL];
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
    
    NSArray* dataDic = [data objectForKey:@"list"];
    NSMutableArray* listCarArray = [NSMutableArray array];
    NSMutableArray* countArray = [NSMutableArray array];
    
    for (NSDictionary* dic in dataDic)
    {
        
        NSDictionary* carDic = [dic objectForKey:@"data"];
        NSString* englishString = [dic objectForKey:@"indexTitle"];
       for (NSDictionary* smallDic in carDic)
          {
              if ([smallDic objectForKey:@"logo"]) {
                  
                  BrandCar* car = [[BrandCar alloc]init];
                  car.carBrandId = [smallDic objectForKey:@"carBrandId"];
                  car.carname = [smallDic objectForKey:@"name"];
                  car.carlogo = [smallDic objectForKey:@"logo"];
                  [listCarArray addObject:car];
                  [self.titleArray removeAllObjects];
                  [self.titleArray addObject:englishString];
                   [countArray addObject:self.titleArray];
                }
              
        
          }
        
        NSLog(@"%@",listCarArray);
        
        if (listCarArray.count>0) {
            
            [self.carArray addObject:listCarArray];
     
            
        }
     }
    NSLog(@"carArray = %@",self.carArray);
    
    NSLog(@"countArray = %@",countArray);
    self.ABCArray = self.titleArray;
    [self.tableView reloadData];
}

@end
