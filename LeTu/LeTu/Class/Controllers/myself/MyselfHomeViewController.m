//
//  MyselfHomeViewController.m
//  LeTu
//
//  Created by DT on 14-5-18.
//
//

#import "MyselfHomeViewController.h"
#import "MyselfHomeTableHeaderView.h"
#import "MyselfDetailViewController.h"
#import "MyselfWalletViewController.h"
#import "MyselfSettingViewController.h"
#import "MyselfSignedViewController.h"
#import "UserModel.h"
#import "MySelfCarViewController.h"
#import "MyselfBlacklistViewController.h"
#import "MyselfCollectViewController.h"
#import "FriendsCircleBlacklistViewController.h"
#import "FriendsCircleBlacklistAddViewController.h"
#import "MyCarViewController.h"



#import "AddressViewController.h"
#import "CarInformationViewController.h"
#import "MyCollectViewController.h"
#import "CarPoolViewController.h"



@interface MyselfHomeViewController ()<UITableViewDataSource,UITableViewDelegate,MyselfHomeTableHeaderViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)MyselfHomeTableHeaderView *tableHeaderView;

@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,assign)BOOL isRedDot;
//@property(nonatomic,strong)UIImageView *image;
@end

@implementation MyselfHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    
    [self setTitle:@"我的" andShowButton:NO];
//    
//    [self initRightBarButtonItem:[UIImage imageNamed:@"meIconSetup.png"] highlightedImage:nil];
    
    [self initRightBarButtonItem:@"设置"];
    
    
    
    
    //[self initUINavigationController];
    self.isRedDot = NO;

    
    [self initTableView];
    
//    //用户报名拼车通知
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(hasNewApply) name:@"hasNewApply" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    self.userModel = [AppDelegate sharedAppDelegate].userModel;
    self.tableHeaderView.userModel = self.userModel;
    NSLog(@"%@",self.userModel.userPhoto);
    
    SHOWTABBAR;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化导航栏
 */
- (void)initUINavigationController
{
    UIImage *topBar = [UIImage imageNamed:@"letu_navbtn_bg"];
    
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, FRAME_WIDTH, NAVBAR_HEIGHT)];
    topBarImageView.image = topBar;
    [self.view addSubview:topBarImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 220, 44)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.titleLabel.textColor = [UIColor redColor];
    self.titleLabel.text = @"我的";
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.center = topBarImageView.center ;
    [topBarImageView addSubview:self.titleLabel];
}
/**
 *  设置按钮事件
 *
 *  @param button
 */
- (void)clickRightButton:(UIButton *)button
{
    MyselfSettingViewController *settingVC = [[MyselfSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
    HIDETABBAR;
}
/**
 *  初始化tableView
 */
- (void)initTableView
{
    
    self.tableHeaderView = [[MyselfHomeTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 90)];
   // self.tableHeaderView.backgroundColor = [UIColor clearColor];
      self.tableHeaderView.backgroundColor  = RGBCOLOR(238, 238, 238);

    self.tableHeaderView.userModel = self.userModel;
    self.tableHeaderView.delegate = self;
    
    
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT-10;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+10, self.view.frame.size.width, height) style:UITableViewStyleGrouped];
    self.tableView.backgroundView= nil;
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    if (iOS_7_Above) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}
#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 15;
    }
    if (section ==1 || section ==2 || section ==3) {
        
        return 3;
        
    }
    if (section ==4) {
        
        return 15.0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==4) {
        
        return 3;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
 
     
            cell.textLabel.text = @"常用地址";
            cell.imageView.image = [UIImage imageNamed:@"meIconUsedAdd.png"];
        
      }
    if (indexPath.section ==1) {
        
        cell.textLabel.text = @"拼车管理";
        cell.imageView.image = [UIImage imageNamed:@"meIconSupervise.png"];
        
      
        
    }
    if (indexPath.section ==2) {
        
        
        cell.textLabel.text = @"车辆信息";
        cell.imageView.image = [UIImage imageNamed:@"meIconCarMessages.png"];
        
   
    }
    if (indexPath.section ==3) {
        
        
        cell.textLabel.text = @"我的收藏";
        cell.imageView.image = [UIImage imageNamed:@"meIconCollect.png"];
        
    
    }
    
    if (indexPath.section ==4) {
        if (indexPath.row ==0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"隐私设置";
            cell.imageView.image = [UIImage imageNamed:@"meIconSetup.png"];
            

            
            
        }else if (indexPath.row ==1){
        
            cell.textLabel.text = @"黑名单的";
            cell.imageView.image = [UIImage imageNamed:@"meIconNo.png"];
            
        }else {
            cell.textLabel.text = @"不让他(她看朋友圈)";
            cell.imageView.image = [UIImage imageNamed:@"meIconSee.png"];
            
        
        }
        
        
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        
        //常用地址
        AddressViewController* addressVC = [[AddressViewController alloc]init];
        [self.navigationController pushViewController:addressVC animated:YES];
        
     }else if (indexPath.section ==1){
    
         //拼车管理
         CarPoolViewController* addressVC = [[CarPoolViewController alloc]init];
         [self.navigationController pushViewController:addressVC animated:YES];
         
         
    }else if (indexPath.section ==2)
    {
    //车辆信息
        CarInformationViewController* addressVC = [[CarInformationViewController alloc]init];
        [self.navigationController pushViewController:addressVC animated:YES];
        
        
    }else if (indexPath.section ==3)
    {
        //我的收藏
        MyCollectViewController* addressVC = [[MyCollectViewController alloc]init];
        [self.navigationController pushViewController:addressVC animated:YES];
        

    }else if (indexPath.section ==4)
    {
        if (indexPath.row==1) {//黑名单
            MyselfBlacklistViewController *blacklistVC = [[MyselfBlacklistViewController alloc] init];
            [self.navigationController pushViewController:blacklistVC animated:YES];
        }else if (indexPath.row==2){//朋友圈
            FriendsCircleBlacklistViewController *blacklistVC = [[FriendsCircleBlacklistViewController alloc] init];
            [self.navigationController pushViewController:blacklistVC animated:YES];
        }

    
    
    }
    
    return;
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:{
                //常用地址
                AddressViewController* addressVC = [[AddressViewController alloc]init];
                [self.navigationController pushViewController:addressVC animated:YES];
                
                
                break;
            }case 1:{//我发起的
                MyselfSignedViewController *singnedVC = [[MyselfSignedViewController alloc] initWithType:1];
                [self.navigationController pushViewController:singnedVC animated:YES];
                break;
            }case 2:{//我报名的
                MyselfSignedViewController *singnedVC = [[MyselfSignedViewController alloc] initWithType:2];
                [self.navigationController pushViewController:singnedVC animated:YES];
                self.isRedDot = NO;
                DTButton *button = [self.appDelegate.tabBar.buttonArray objectAtIndex:3];
                button.isRedDot = NO;
                [self.tableView reloadData];
                break;
            }case 3:{//我收藏的
                MyselfCollectViewController *collectVC = [[MyselfCollectViewController alloc] initWithType:2];
                [self.navigationController pushViewController:collectVC animated:YES];
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section==1){//黑名单
        if (indexPath.row==0) {//黑名单
            MyselfBlacklistViewController *blacklistVC = [[MyselfBlacklistViewController alloc] init];
            [self.navigationController pushViewController:blacklistVC animated:YES];
        }else if (indexPath.row==1){//朋友圈
            FriendsCircleBlacklistViewController *blacklistVC = [[FriendsCircleBlacklistViewController alloc] init];
            [self.navigationController pushViewController:blacklistVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark MyselfHomeTableHeaderViewDelegate
- (void)tableHeaderView:(MyselfHomeTableHeaderView*)tableHeaderView didClickToView:(NSInteger)tag;
{
    MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] init];
  
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)hasNewApply
{
    self.isRedDot = YES;
    [self.tableView reloadData];
}
@end
