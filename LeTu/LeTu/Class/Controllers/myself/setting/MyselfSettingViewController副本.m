//
//  MyselfSettingViewController.m
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import "MyselfSettingViewController.h"
#import "DTButton.h"
#import "KLSwitch.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "MyselfFeedbackViewController.h"
#import "MyselfFeedbackViewController.h"
#import "DTImage+Category.h"
#import "MyselfAboutViewController.h"

#ifdef IMPORT_LETUIM_H
#import "LeTuIM.h"
#endif

@interface MyselfSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)TableView *tableView;

@end

@implementation MyselfSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self setTitle:@"设置" andShowButton:YES];
    [self initTableView];
    
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
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 110)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 15, 80, 80)];
    imageView.image = [UIImage imageNamed:@"setting_icon"];
    [tableHeaderView addSubview:imageView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 70)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(45, 15, 230, 36)];
    [button setImage:[UIImage imageNamed:@"setting_exit_btn_press"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"setting_exit_btn_normal"] forState:UIControlStateHighlighted];
    button.tag = 10;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:button];
    
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.tableFooterView = tableFooterView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else if (section==1){
        return 3;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            cell.textLabel.text = @"推送状态";
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 165, 44)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentRight;
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.text = @"请在系统通知中心开启";
            label.tag = 100;
            [cell addSubview:label];
            
            KLSwitch *button = [[KLSwitch alloc]
                                initWithFrame:CGRectMake(260, 10, 45, 25) didChangeHandler:^(BOOL isOn) {
                                    UITableViewCell *cell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                    UILabel *label = (UILabel*)[cell viewWithTag:100];
                                    if (isOn) {
                                        NSLog(@"推送开启");
                                        label.hidden = NO;
                                    }else{
                                        NSLog(@"推送不开启");
                                        label.hidden = YES;
                                    }
                                }];
            button.backgroundColor = [UIColor clearColor];
            button.contrastColor = RGBCOLOR(196, 196, 196);
            button.onTintColor = RGBCOLOR(41, 159, 249);
            [cell addSubview:button];
            
        }else if (indexPath.row==1){
            cell.textLabel.text = @"网络缓存";
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 165, 44)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentRight;
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:16.0f];
            
            float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
            NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM ",tmpSize] : [NSString stringWithFormat:@"%.2fK ",tmpSize * 1024];
            //            label.text = @"20.78MB";
            label.text = clearCacheName;
            label.tag = 1000;
            [cell addSubview:label];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(260, 10, 45, 25)];
            [button setImage:[UIImage imageNamed:@"setting_clear_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"setting_clear_press"] forState:UIControlStateHighlighted];
            button.tag = 1001;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.textLabel.text = @"意见反馈";
        }else if (indexPath.row ==1){
            cell.textLabel.text = @"给个好评";
        }else if (indexPath.row ==2){
            cell.textLabel.text = @"关于";
        }
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:{
                    MyselfFeedbackViewController *feedbackVC = [[MyselfFeedbackViewController alloc] initWithImage:nil];
                    [self.navigationController pushViewController:feedbackVC animated:YES];
                    /*
                     if (indexPath.row==0) {
                     UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"文字",@"从相册选择",nil];
                     actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
                     actionSheet.tag = 1;
                     [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
                     }
                     //*/
                    break;
                }
                case 1:
                {
//                    [[UIApplication sharedApplication] openURL:([NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", APPLE_ITUNES_APPID]])];
                }
                    break;
                case 2:{
                    MyselfAboutViewController *aboutVC = [[MyselfAboutViewController alloc] init];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    if (button.tag == 10) {//退出按钮
#ifdef IMPORT_LETUIM_H
        LeTuIM *server = [LeTuIM sharedInstance];
        server.myName = nil;
        server.myPassword = nil;
        [server disConnectServer];
#endif
        AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
        appDelegate.currentLocation = CLLocationCoordinate2DMake(0.0, 0.0);
        appDelegate.mainViewController.is_dispatch_time_t = NO;
     
        
        LoginViewController *loginVC = [[LoginViewController alloc] initToSetting:YES];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
        if (iOS_7_Above) {
            
            loginVC.edgesForExtendedLayout = UIRectEdgeNone;
            
        }
     //修改了   //[navigation setNavigationBarHidden:YES];
        NSLog(@"%@",self.navigationController);
        
        [self presentViewController:navigation animated:YES completion:^{
            
        }];
        /*}else if (button.tag == 101){//推送按钮
         DTButton *btn = (DTButton*)button;
         UITableViewCell *cell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         UILabel *label = (UILabel*)[cell viewWithTag:100];
         if ([btn isSelect]) {
         label.text = @"请在系统通知中心开启";
         btn.isSelect = ![btn isSelect];
         }else{
         label.text = @"";
         btn.isSelect = ![btn isSelect];
         }
         //*/
    }else if (button.tag == 1001){//清除按钮
        UITableViewCell *cell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UILabel *label = (UILabel*)[cell viewWithTag:1000];
        label.text = @"0.00K";
        [[SDImageCache sharedImageCache] clearDisk];
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {//文字
        MyselfFeedbackViewController *feedbackVC = [[MyselfFeedbackViewController alloc] initWithImage:nil];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else if (buttonIndex==1) {//相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
}
//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:NO];
    MyselfFeedbackViewController *feedbackVC = [[MyselfFeedbackViewController alloc] initWithImage:[image imageWithMaxImagePix:500 compressionQuality:0.5]];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

@end
