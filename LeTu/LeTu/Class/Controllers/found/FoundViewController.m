//
//  FoundViewController.m
//  LeTu
//
//  Created by DT on 14-5-7.
//
//

#import "FoundViewController.h"
#import "FriendsCircleViewController.h"
#import "MapActivityViewController.h"

@interface FoundViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation FoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.title = @"发现";
    
//    frame = self.view.frame;
//    frame.origin.y -=20;
//    frame.size.height -=44;
    [self setTitle:@"发现" andShowButton:NO];
    [self initTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SHOWTABBAR;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化tableView
 */
- (void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height - STATUSBAR_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStyleGrouped];
    self.tableView.backgroundView= nil;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10.0;
    }
    return 2.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        cell.textLabel.text = @"好友动态";
        cell.imageView.image = [UIImage imageNamed:@"foundFriendDynamic.png"];
    }else if (indexPath.section==1){
        cell.textLabel.text = @"周边活动";
        cell.imageView.image = [UIImage imageNamed:@"foundNearfriend.png"];
        
    }else if (indexPath.section==2){
        
        if (indexPath.row==0) {
            cell.textLabel.text = @"附近拼友";
            cell.imageView.image = [UIImage imageNamed:@"foundPeripherals.png"];
        }
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            // section 1 row 0 朋友圈
            DTButton *button = [self.appDelegate.tabBar.buttonArray objectAtIndex:2];
            button.isRedDot = NO;
            
            FriendsCircleViewController *fcVC = [[FriendsCircleViewController alloc] initWithIsMe:NO userId:@""];
            [self.navigationController pushViewController:fcVC animated:YES];
            
        }
            break;
        case 1:
        {
            // section 1 row 0 活动
            MapActivityViewController *activityVC = [[MapActivityViewController alloc] init];
            [self.navigationController pushViewController:activityVC animated:YES];
        }
            break;
            
        default:
        {
#ifdef IMPORT_LETUIM_H
            [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此功能尚在开发, 敬请期待!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
#endif
        }
            break;
    }
//    if (indexPath.row == 0 && indexPath.section==0) {
//        
//        DTButton *button = [self.appDelegate.tabBar.buttonArray objectAtIndex:2];
//        button.isRedDot = NO;
//        
//        FriendsCircleViewController *fcVC = [[FriendsCircleViewController alloc] initWithIsMe:NO userId:@""];
//        [self.navigationController pushViewController:fcVC animated:YES];
//    }else if (indexPath.row == 0 && indexPath.section== 1) {
//        MapActivityViewController *activityVC = [[MapActivityViewController alloc] init];
//        [self.navigationController pushViewController:activityVC animated:YES];
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
