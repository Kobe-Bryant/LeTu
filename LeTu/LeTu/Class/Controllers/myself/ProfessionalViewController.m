//
//  ProfessionalViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-24.
//
//

#import "ProfessionalViewController.h"
#import "UserDetailModel.h"

@interface ProfessionalViewController ()
{
    NSOperationQueue* queue;
    
}
@property(nonatomic,strong) UITableView* tableview;
@property(nonatomic,strong)  UIImageView* avatorImageView;
@property(nonatomic,strong) NSMutableArray* selectArray;
@property(nonatomic,strong) NSMutableArray* dataArray;

@end

@implementation ProfessionalViewController

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
    
    self.selectArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
    self.dataArray = [NSMutableArray arrayWithObjects:@"计算机/互联网/通信",@"商业/服务业/个体经营",@"金融/银行/投资/保险",@"生产/工艺/制造",@"文化/广告/传媒",@"娱乐/艺术/表演",@"医疗/护理/制药",@"公务员/事业单位",@"律师/法务",@"教育/培训,学生", nil];
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
    label.text = @"更改职业";
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
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,64.0+10, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableview.backgroundColor = RGBCOLOR(238, 238, 238);
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorColor =[UIColor clearColor];
    [self.view addSubview:self.tableview];
    
    for (NSString* occption in self.dataArray) {
        
        NSInteger index = [self.dataArray indexOfObject:occption];
         if ([occption isEqualToString:self.model.occupation]) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.selectArray addObject:indexPath];
            break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        
    }
    if (indexPath.row <self.dataArray.count) {
        
        UIImageView* lineImageView = [[UIImageView alloc]init];
        lineImageView.frame = CGRectMake(0.0, cell.frame.size.height, self.view.frame.size.width, 1);
        lineImageView.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
        [cell.contentView addSubview:lineImageView];
        
        
    }
    
    if ([self.selectArray containsObject:indexPath]) {
        
        UIImage* image = [UIImage imageNamed:@"meCheck.png"];
        self.avatorImageView = [[UIImageView alloc] init];
        self.avatorImageView.frame = CGRectMake(280.0, 15.0, image.size.width, image.size.height);
        self.avatorImageView.image = image;
        cell.accessoryView = self.avatorImageView;
        
    }else {
        
        cell.accessoryView = nil;
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
    cell.detailTextLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);
    cell.textLabel.text = self.dataArray[indexPath.row];
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
}

- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        NSIndexPath* indexPath = [self.selectArray lastObject];
        NSString* professionString = self.dataArray[indexPath.row];
        [self updateProfession:professionString];
    
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
- (void)updateProfession:(NSString*)profession
{

    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
   NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    [param setObject:lkey forKey:@"l_key"];
    
    [param setObject:@"occupation" forKey:@"item"];
    [param setObject:profession forKey:@"occupation"];
    
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
    
    UserModel *userModel = nil;
    //    if (self.isMe) {
    //        userModel = [AppDelegate sharedAppDelegate].userModel;
    //    };
   userModel = [AppDelegate sharedAppDelegate].userModel;
    NSString *string = [data objectForKey:@"obj"];
    
    self.model.occupation = string;
    [[[[iToast makeText:@"职业修改成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateCareerNotification" object:string userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
