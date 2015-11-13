//
//  BirthPlaceViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import "BirthPlaceViewController.h"
#import "UserDetailModel.h"

@interface BirthPlaceViewController ()
{
  
    NSOperationQueue* queue;
    

}
@property(nonatomic,strong) UITableView* leftTableview;
@property(nonatomic,strong) UITableView* rightTableview;
@property(nonatomic,strong)  UIImageView* avatorImageView;
@property(nonatomic,strong) NSMutableArray* provinceArray;
@property(nonatomic,strong) NSMutableArray* cityArray;
@property(nonatomic,strong) NSString* province;
@property(nonatomic,strong) NSString* city;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,strong)  UIButton* sureButton;
@property(nonatomic,strong) NSMutableArray* placeArray;


@property(nonatomic,strong) NSMutableArray* chosePrivceArray;
@property(nonatomic,strong) NSMutableArray* choseCityArray;




@end

@implementation BirthPlaceViewController

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
    
    self.chosePrivceArray = [NSMutableArray array];
    self.choseCityArray = [NSMutableArray array];
    self.provinceArray = [NSMutableArray array];
    self.placeArray = [NSMutableArray array];
    self.cityArray = [NSMutableArray array];
    self.selectIndex =0;
    self.view.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
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
    UIImage* navigationBarIOS6Image = [UIImage imageNamed:@"nav_bg320x44.png"];
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, FRAME_WIDTH, topBar.size.height)];
    if (iOS_7_Above) {
        topBarImageView.image = topBar;
        
        
    }else {
        topBarImageView.image = navigationBarIOS6Image;
        
    }
    topBarImageView.userInteractionEnabled = YES;
    [self.view addSubview:topBarImageView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 20.0, 220, 44)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"更改出生地";
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
    
    
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(230.0, 25.0, 80.0, 40.0);
    [_sureButton setTitle:@"保存" forState:UIControlStateNormal];
    _sureButton.backgroundColor = [UIColor clearColor];
    _sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0);
    [_sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.tag = 2;
    [topBarImageView addSubview:_sureButton];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Provineces" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSDictionary *dict in dataArray) {
        [self.provinceArray addObject:[dict objectForKey:@"ProvinceName"]];
        NSMutableArray *cicty = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [dict objectForKey:@"cities"]) {
            [cicty addObject:[dic objectForKey:@"CityName"]];
        }
        [self.cityArray addObject:cicty];
    }
    
    self.province = [self.provinceArray objectAtIndex:0];
    self.city = [[self.cityArray objectAtIndex:0] objectAtIndex:0];
    NSLog(@"%@",self.province);
    NSLog(@"%@",self.city);
    
    [self initWithTableView];
 
    NSRange range = [self.model.area rangeOfString:@" "];//判断字符串是否包含
    NSString* provice;
    NSString* scity;
    //if (range.location ==NSNotFound)//不包含
    if (range.length >0)//包含
    {
        
        NSArray* array = [self.model.area componentsSeparatedByString:@" "];
        provice =[array objectAtIndex:0];
        scity = [array objectAtIndex:1];
        
    }
    
    NSRange rangeOne = [self.model.area rangeOfString:@","];
    
    if (rangeOne.length > 0) {
        
        NSArray* array = [self.model.area componentsSeparatedByString:@","];
        provice =[array objectAtIndex:0];
        scity = [array objectAtIndex:1];
        
    }
    NSInteger indexSection;
    for (NSString* pro in self.provinceArray) {
    
      indexSection = [self.provinceArray indexOfObject:pro];
        
        if ([pro isEqualToString:provice]) {
            
            NSLog(@"index = %d",indexSection);
            
            [self.leftTableview reloadData];

               [self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexSection inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionMiddle];
            break;
            
        }
    }
    
    
    NSArray* citys = [self.cityArray objectAtIndex:indexSection];
    
    for (NSString* city in citys) {
        
        NSInteger index = [citys indexOfObject:city];
        
        if ([city isEqualToString:scity]) {
         
          
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            self.selectIndex = indexPath.row;
            [self.rightTableview reloadData];
            NSLog(@"%d",index);
            
            [self.rightTableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
    }
}

- (void)initWithTableView
{
    CGFloat Y =0.0;

    if (iOS_7_Above) {
        
        Y = 64.0;
        
    }else {
        
        Y =44;
    }
    int height = [UIScreen mainScreen].bounds.size.height -Y;
  
    self.leftTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, Y, 140, height) style:UITableViewStylePlain];
    self.leftTableview.backgroundColor = [UIColor clearColor];
    self.leftTableview.showsVerticalScrollIndicator = NO;
    self.leftTableview.dataSource = self;
    self.leftTableview.delegate = self;
    self.leftTableview.tag = 1;
    [self.view addSubview:self.leftTableview];
    
    self.rightTableview = [[UITableView alloc] initWithFrame:CGRectMake(140, Y,180, height) style:UITableViewStylePlain];
    self.rightTableview.backgroundColor = RGBCOLOR(239, 238, 244);
    self.rightTableview.showsVerticalScrollIndicator = NO;
    self.rightTableview.separatorColor = [UIColor clearColor];
    self.rightTableview.dataSource = self;
    self.rightTableview.delegate = self;
    self.rightTableview.tag = 2;

    [self.view addSubview:self.rightTableview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag ==1) {
    
       return self.provinceArray.count;
    
    }else {
    
        NSArray* array = [self.cityArray objectAtIndex:self.selectIndex];
        return array.count;
   }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
   
    if (tableView.tag ==1) {
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = self.provinceArray[indexPath.row];
        cell.textLabel.textColor = RGBCOLOR(54.0,54.0 ,54.0);
        return cell;
        
        
    }else {
    
       NSArray* array = [self.cityArray objectAtIndex:self.selectIndex];
        NSString* city = [array objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text =city;
        cell.textLabel.textColor = RGBCOLOR(54.0,54.0 ,54.0);
        
  
        return cell;
    }
    
     return nil;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 

    if (tableView.tag ==1) {
        
        self.selectIndex = indexPath.row;
        [self.rightTableview reloadData];
        self.province = [self.provinceArray objectAtIndex:indexPath.row];
        NSLog(@"%@",self.province);
        self.sureButton.enabled = NO;
     
      }else {
    
          NSArray* city = [self.cityArray objectAtIndex:self.selectIndex];
          self.city = [city objectAtIndex:indexPath.row];
          NSLog(@"%@",self.city);
          self.sureButton.enabled = YES;
        }
    
}

- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        [self.placeArray addObject:self.province];
        [self.placeArray addObject:self.city];
        NSString* place = [self.placeArray componentsJoinedByString:@","];
        [self updateBirthPlace:place];
        NSLog(@"provice = %@ city = %@",self.province,self.city);
        
        
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
- (void)updateBirthPlace:(NSString*)place
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    [param setObject:@"area" forKey:@"item"];
    [param setObject:place forKey:@"area"];
    [param setObject:lkey forKey:@"l_key"];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:param];
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

-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    
    UserModel *userModel = nil;
    //    if (self.isMe) {
    //        userModel = [AppDelegate sharedAppDelegate].userModel;
    //    };
    userModel = [AppDelegate sharedAppDelegate].userModel;
    NSString *string = [data objectForKey:@"obj"];
    
     self.model.area = string;
    userModel.area = string;
    [[[[iToast makeText:@"出生地修改成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateBirthdayNotification" object:string userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)messageToast:(NSString*)msg
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}

@end
