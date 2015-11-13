//
//  ColorSetingViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-19.
//
//

#import "ColorSetingViewController.h"
#import "view.h"
#import "BrandCar.h"




@interface ColorSetingViewController ()
{
    NSOperationQueue* queue;
    

}
@property(nonatomic,strong) TableView* tableView;
@property(nonatomic,strong) NSMutableArray* selectArray;
@property(nonatomic,strong) NSMutableArray* colorArray;






@end

@implementation ColorSetingViewController

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
    
    self.selectArray = [NSMutableArray array];
    self.colorArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    self.colorArray = [NSMutableArray arrayWithObjects:@"黑色",@"白色",@"银灰",@"红色",@"蓝色",@"黄色",@"其他", nil];
    
    for (NSString* color in self.colorArray) {
       
        NSInteger index = [self.colorArray indexOfObject:color];
        if ([color isEqualToString:self.car.carColor]) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.selectArray addObject:indexPath];
            break;
        }
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
    label.text = @"颜色";
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    //self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
}
#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellidenty = @"cellID";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
    
    if (cell ==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidenty];
        
        view* viewOne = [[view alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.textLabel.frame)+58, 14, 15, 15)];//初始化、坐标
        viewOne.backgroundColor = [UIColor clearColor];//要透明的
        viewOne.tag = 10;
        [cell.contentView addSubview:viewOne];//添加

    }
    
    cell.textLabel.textColor =RGBCOLOR(54.0, 54.0, 54.0);
    if ([self.selectArray containsObject:indexPath]) {
        
        UIImage* image = [UIImage imageNamed:@"meCheck.png"];
        UIImageView* avatorImageView = [[UIImageView alloc] init];
        avatorImageView.frame = CGRectMake(280.0, 15.0, image.size.width, image.size.height);
        avatorImageView.image = image;
        cell.accessoryView = avatorImageView;
        
    }else {
        
        cell.accessoryView = nil;
        
        
    }
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row ==0) {
        
        cell.textLabel.text = self.colorArray[indexPath.row];
        view* viewOne = (view*)[cell.contentView viewWithTag:10];
        viewOne.type =0;

         return cell;
        
    }else if(indexPath.row ==1){
        
        cell.textLabel.text = self.colorArray[indexPath.row];
        view* viewOne = (view*)[cell.contentView viewWithTag:10];
        viewOne.type =1;
        return cell;

        
    }else if(indexPath.row ==2){
        
        cell.textLabel.text = self.colorArray[indexPath.row];
        view* viewOne = (view*)[cell.contentView viewWithTag:10];
        viewOne.type =2;
        return cell;

        
    }else if(indexPath.row ==3){
        
        cell.textLabel.text = self.colorArray[indexPath.row];
        view* viewOne = (view*)[cell.contentView viewWithTag:10];
        viewOne.type =3;
        return cell;

        
    }else if(indexPath.row ==4){
        
        cell.textLabel.text = self.colorArray[indexPath.row];
        view* viewOne = (view*)[cell.contentView viewWithTag:10];
        viewOne.type =4;
        return cell;

        
    }else if(indexPath.row ==5){
        
        cell.textLabel.text = self.colorArray[indexPath.row];
        view* viewOne = (view*)[cell.contentView viewWithTag:10];
        viewOne.type =5;
        return cell;

        
    }else if(indexPath.row ==6){
        
        cell.textLabel.text = self.colorArray[indexPath.row];
        view* viewOne = (view*)[cell.contentView viewWithTag:10];
        viewOne.type =6;

        return cell;

    }
    return nil;
    
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section ==0) {
        
        return 10.0;
    }
    return 0.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.selectArray containsObject:indexPath]) {
       
        [self.selectArray removeAllObjects];
        [self.selectArray addObject:indexPath];
        [self.tableView reloadData];
        
    }
}

- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
        
    [self.navigationController popViewControllerAnimated:YES];
  
        
    }else {
    
        NSIndexPath* indexPath =(NSIndexPath*)[self.selectArray lastObject];
        NSString* color;
        
        switch (indexPath.row) {
            case 0:
             
                color = @"黑色";
                
             break;
            case 1:
                color = @"白色";
     
            break;
            case 2:
                color = @"银灰";

            break;
                
            case 3:
                color = @"红色";
  
            break;
            case 4:
                color = @"蓝色";
    
            break;
            case 5:
                color = @"黄色";
  
            break;
            case 6:
                color = @"其他";
                
                break;
            default:
                break;
        }
      [self updateMyCarColorInfomation:color];
    }
}
- (void)updateMyCarColorInfomation:(NSString*)color
{
    
   // http://localhost:8080/myCar2/myCarService.jws?changeMyCar&carColor=&carLocation= &carNumber=&carSeriesId=&l_key=
    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar2/myCarService.jws?changeMyCar", SERVERAPIURL];
    
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
   NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:color forKey:@"carColor"];
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
    
   [[[[iToast makeText:@"颜色设置成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
 
    
    [self.navigationController popViewControllerAnimated:YES];
}
-( void )reponseFaild:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
}
@end
