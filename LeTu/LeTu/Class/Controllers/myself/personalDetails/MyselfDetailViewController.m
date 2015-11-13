//
//  MyselfDetailViewController.m
//  LeTu
//
//  Created by DT on 14-5-20.
//
//

#import "MyselfDetailViewController.h"
#import "MyselfDetailCell.h"
#import "MyselfDetailPhotoCell.h"
#import "MyselfDetilUpdateViewController.h"
#import "UserDetailModel.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "FriendsCircleViewController.h"
#import "MainViewController.h"
#import "DTButton.h"
#import "FriendsCirclePermissionsViewController.h"
#import "DTImage+Category.h"

//tableView的头部试图。
#import "TableHeadView.h"
#import "ModifyPersonViewController.h"
#import "MySelfPhotoCell.h"



#ifdef IMPORT_LETUIM_H
#import "LeTuIM.h"
#endif

@interface MyselfDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSOperationQueue *queue;
}

@property(nonatomic,strong)TableView *tableView;
@property(nonatomic,strong)UIView *addView;//添加
@property(nonatomic,strong) TableHeadView* tableHeadView;


@property(nonatomic,strong)UserDetailModel *detailMode;
/** 修改前的我 */
@property(nonatomic,strong)UserModel *oldMeModel;
@property(nonatomic,strong)NSMutableArray *keyArray;
//@property(nonatomic,strong)NSArray *valueArray;

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userKey;
@property(nonatomic,assign)BOOL isMe;//表示自己或者他人
@property(nonatomic,assign)BOOL needUpdateMyAccount;
@property(nonatomic,copy)NSString *gender;

@end

@implementation MyselfDetailViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.isMe = YES;
    }
    return self;
}
-(id)initWithTitle:(NSString*)title userId:(NSString*)userId userKey:(NSString*)userKey
{
    self = [super init];
    if (self) {
        self.isMe = NO;
        self.title = title;
        self.userId = userId;
        self.userKey = userKey;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
//        self.isMe = YES;
//    }
//    if (self.isMe) {
//        self.keyArray = [[NSMutableArray alloc] initWithObjects:@"头像",@"昵称",@"乐途号",@"性别",@"年龄",@"个性签名",@"地区",@"最新照片", nil];
//        self.oldMeModel = self.appDelegate.userModel;
//    }else{
//        self.keyArray = [[NSMutableArray alloc] initWithObjects:@"头像",@"昵称",@"乐途号",@"性别",@"年龄",@"个性签名",@"地区",@"关系",@"最新照片", nil];
//    }
//    if (self.isMe) {
//        [self setTitle:@"个人资料" andShowButton:YES];
//    }else{
//        [self setTitle:self.title andShowButton:YES];
//        self.isMe = NO;
//        if (![self.userId isEqualToString:self.appDelegate.userModel.userId]) {
//            [self initRightBarButtonItem:[UIImage imageNamed:@"material_more_btn_nor"]
//                        highlightedImage:[UIImage imageNamed:@"material_more_btn_pre"]];
//        }
//    }
    [self initTableView];
    
  //  self.tableView.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.appDelegate.navigation.isSlide = NO;
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self fillData];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.view.backgroundColor = [UIColor clearColor];
    
    
#ifdef IMPORT_LETUIM_H
    if (_isMe && [[LeTuIM sharedInstance] myLeTuAccountNeedUpdate]) {
        LeTuIM *im = [LeTuIM sharedInstance];
        [im userInfomationWithLoginName:[im myName]];
    }
#endif
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  add按钮
 *
 *  @param button
 */
- (void)clickRightButton:(UIButton *)button
{
    if (self.addView) {
        if (self.addView.hidden) {
            self.addView.hidden = NO;
        }else{
            self.addView.hidden = YES;
        }
    }else{
        if ([self.detailMode.relationType intValue]==0) {
            self.addView = [[UIView alloc] initWithFrame:CGRectMake(151, 44, 159, 58)];
            self.addView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:self.addView];
            
            UIButton *button = nil;
            button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 159, 58)];
            [button setImage:[UIImage imageNamed:@"add_people_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"add_people_press"] forState:UIControlStateHighlighted];
            button.tag = 888;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.addView addSubview:button];
        }else{
            self.addView = [[UIView alloc] initWithFrame:CGRectMake(163, 44, 147, 153)];
            self.addView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:self.addView];
            
            UIButton *button = nil;
            button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 147, 58)];
            [button setImage:[UIImage imageNamed:@"material_more_setting_nor"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"material_more_setting_pre"] forState:UIControlStateHighlighted];
            button.tag = 1;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.addView addSubview:button];
            
            button = [[UIButton alloc] initWithFrame:CGRectMake(0, 57.5, 147, 48)];
            [button setImage:[UIImage imageNamed:@"material_more_blacklist_nor"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"material_more_blacklist_pre"] forState:UIControlStateHighlighted];
            button.tag = 2;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.addView addSubview:button];
            
            button = [[UIButton alloc] initWithFrame:CGRectMake(0, 105.5, 147, 48)];
            [button setImage:[UIImage imageNamed:@"material_more_delete_nor"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"material_more_delete_pre"] forState:UIControlStateHighlighted];
            button.tag = 3;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.addView addSubview:button];
        }
    }
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    if (button.tag ==1) {//设置黑名单权限按钮
        FriendsCirclePermissionsViewController *permissionsVC = [[FriendsCirclePermissionsViewController alloc] initWithUserId:self.userId];
        [self.navigationController pushViewController:permissionsVC animated:YES];
    }else if (button.tag ==2){//加入黑名单按钮
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"加入黑名单,你将不再收到对方的消息,并且你们互相看不到对方朋友圈的更新"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:@"取消",nil];
        alert.tag = 111;
        [alert show];
    }else if (button.tag ==3){//删除按钮
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:[NSString stringWithFormat:@"将联系人\"%@\"删除,同时删除与该联系人的聊天记录",self.title]
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:@"取消",nil];
        alert.tag = 222;
        [alert show];
    }else if (button.tag==888){//加为联系人
        [self applyFriend];
    }
    self.addView.hidden = YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {//确定
        if (alertView.tag==111) {//拉黑
            [self pullBlackUser];
        }else if (alertView.tag==222){//删除
            [self deleteUser];
        }
    }
}
/**
 *  初始化tableView
 */
- (void)initTableView
{
  //  int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    
    
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, 0.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
   
        
    UIImage* backImage = [UIImage imageNamed:@"meBgPersonaldata.png"];
    TableHeadView* headView = [[TableHeadView alloc]init];
    headView.frame = CGRectMake(0.0, 0.0, backImage.size.width, backImage.size.height);
    [headView setBackGroundImage:backImage];
    headView.model = self.detailMode;
    self.tableHeadView = headView;
    headView.headDelegate = self;
    self.tableView.tableHeaderView = self.tableHeadView;
    [self.view addSubview:self.tableView];
 
    
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 8.0;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
//        return 8;
//    }
//    return 9;
    return 1;
    
    //return [self.keyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
    if (indexPath.section ==0) {
    
        if (indexPath.row==0) {
            static NSString *CellIdentifier = @"Cell";
            MyselfDetailPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (! cell) {
                cell = [[MyselfDetailPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.userInteractionEnabled = YES;
            MyselfDetailPhotoCell *photoCell = (MyselfDetailPhotoCell*)cell;
            photoCell.keyLabel.textColor = [UIColor blackColor];
            NSArray *photosArray =[self.detailMode.lastestPhotos componentsSeparatedByString:NSLocalizedString(@",", nil)];
            photoCell.photosArray = photosArray;
            return photoCell;
            
            
        }
   }
    
    if (indexPath.section >0) {
        
        
        NSString* cellidenty = @"cellID";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
        
        if (cell ==nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidenty];
            
        }
        cell.textLabel.textColor =RGBCOLOR(54.0, 54.0, 54.0);
        cell.detailTextLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);
        cell.userInteractionEnabled = NO;
        if (indexPath.section ==1) {
       
       cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        //读接口。
        cell.textLabel.text = @"情感状态";
            NSLog(@"%@",self.detailMode.emotionalState);
            
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.detailMode.emotionalState];
      
            return cell;
            
      } else if (indexPath.section ==2)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"职业";
        //读接口。
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.detailMode.occupation];
        return cell;

    }else if (indexPath.section ==3)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"出生日期";

        
        NSString* date = [self.detailMode.birthDay substringToIndex:10];
        //读接口。
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", date];
        return cell;

    } else if (indexPath.section ==4)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"出生地";
        
        //读接口。
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.detailMode.area];
        return cell;

      
    }else if (indexPath.section ==5)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"语言";
        //读接口。
           cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.detailMode.userLanguage];
        return cell;

     
    } else if (indexPath.section ==6)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"手机号";
        //读接口。
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.detailMode.mobile];
        return cell;

      
    }else if (indexPath.section ==7)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = @"搭一程号";
        //读接口。
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.detailMode.loginName];
        return cell;

        }
        
}
    
    /*
        else{
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (! cell) {
                cell = [[MyselfDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            MyselfDetailCell *detailCell = (MyselfDetailCell*)cell;
            detailCell.key = [self.keyArray objectAtIndex:indexPath.row];
            detailCell.valueLabel.textAlignment = NSTextAlignmentRight;
            detailCell.keyLabel.textColor = [UIColor blackColor];
            detailCell.valueLabel.textColor = [UIColor grayColor];
            switch (indexPath.row) {
                case 0:{
                    detailCell.faceUrl = self.detailMode.userPhoto;
                    break;
                }
                case 1:{
                    //                detailCell.value = self.detailMode.alias;
                    detailCell.value = self.detailMode.fullName;
                    break;
                }case 2:{
                    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    detailCell.arrowHide = YES;
                    detailCell.value = self.detailMode.loginName;
                    break;
                }case 3:{
                    if ([self.detailMode.gender intValue]==1) {
                        detailCell.value = @"男";
                    }else if ([self.detailMode.gender intValue]==2){
                        detailCell.value = @"女";
                    }
                    break;
                }case 4:{
                    detailCell.value = [NSString stringWithFormat:@"%i",[self.detailMode.age intValue]];
                    break;
                }case 5:{
                    detailCell.value = self.detailMode.sign;
                    break;
                }case 6:{
                    detailCell.value = self.detailMode.area;
                    break;
                }
                default:
                    break;
            }
            if (!self.isMe) {
                detailCell.arrowHide = YES;
                detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return detailCell;
        }
 
        if (indexPath.row==8) {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (! cell) {
                cell = [[MyselfDetailPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            MyselfDetailPhotoCell *photoCell = (MyselfDetailPhotoCell*)cell;
            NSArray *photosArray =[self.detailMode.lastestPhotos componentsSeparatedByString:NSLocalizedString(@",", nil)];
            photoCell.photosArray = photosArray;
            return photoCell;
        }else{
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (! cell) {
                cell = [[MyselfDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            MyselfDetailCell *detailCell = (MyselfDetailCell*)cell;
            detailCell.key = [self.keyArray objectAtIndex:indexPath.row];
            detailCell.valueLabel.textAlignment = NSTextAlignmentRight;
            detailCell.keyLabel.textColor = [UIColor blackColor];
            detailCell.valueLabel.textColor = [UIColor grayColor];
            switch (indexPath.row) {
                case 0:{
                    detailCell.faceUrl = self.detailMode.userPhoto;
                    break;
                }
                case 1:{
                    //                detailCell.value = self.detailMode.alias;
                    detailCell.value = self.detailMode.fullName;
                    break;
                }case 2:{
                    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    detailCell.arrowHide = YES;
                    detailCell.value = self.detailMode.loginName;
                    break;
                }case 3:{
                    if ([self.detailMode.gender intValue]==1) {
                        detailCell.value = @"男";
                    }else if ([self.detailMode.gender intValue]==2){
                        detailCell.value = @"女";
                    }
                    break;
                }case 4:{
                    detailCell.value = [NSString stringWithFormat:@"%i",[self.detailMode.age intValue]];
                    break;
                }case 5:{
                    detailCell.value = self.detailMode.sign;
                    break;
                }case 6:{
                    detailCell.value = self.detailMode.area;
                    break;
                }case 7:{
                    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    detailCell.arrowHide = YES;
                    detailCell.value = self.detailMode.relationName;
                    break;
                }
                default:
                    break;
            }
            if (!self.isMe) {
                detailCell.arrowHide = YES;
                detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
          
            return detailCell;
        }
   // }
     */
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0 || section ==1 || section==3 || section ==6) {
        
        return 10.0;
    }
    return 3.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        return 60.0;
        
        
    }
    return 40.0;
    
    
//    if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
//        if (indexPath.row==0 || indexPath.row==7) {
//            return 70.0f;
//        }
//        return 44.0f;
//    }else{
//        if (indexPath.row==0 || indexPath.row==8) {
//            return 70.0f;
//        }
//        return 44.0f;
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@",self.userId);
    
    
    FriendsCircleViewController *fcVC = [[FriendsCircleViewController alloc] initWithIsMe:YES userId:self.userId];
    [self.navigationController pushViewController:fcVC animated:YES];
    
    return;
    
    
    if (indexPath.row==[self.keyArray count]-1) {//最新照片
        if (self.isMe) {
            FriendsCircleViewController *fcVC = [[FriendsCircleViewController alloc] initWithIsMe:YES userId:self.userId];
            [self.navigationController pushViewController:fcVC animated:YES];
        }else{
            if ([self.detailMode.relationType intValue]==1) {
                FriendsCircleViewController *fcVC = [[FriendsCircleViewController alloc] initWithIsMe:YES userId:self.userId];
                [self.navigationController pushViewController:fcVC animated:YES];
            }else{
                if ([self.detailMode.relationType intValue]==0) {
              //      [self messageToast:@"你还不是对方的好友,请先添加为好友!"];
                }else if ([self.detailMode.relationType intValue]==2) {
                 //   [self messageToast:@"你已把对方拉黑为黑名单,不能进入朋友圈"];
                }
            }
        }
    }
    if (self.isMe) {
        if (indexPath.row==0) {//头像
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍照",@"相册",nil];
            actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
            actionSheet.tag = 1;
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }else if (indexPath.row==1){//昵称
            MyselfDetilUpdateViewController *updateVC = [[MyselfDetilUpdateViewController alloc] initWithContent:self.detailMode.fullName type:@"0" isMe:self.isMe detailModel:self.detailMode block:^(UserDetailModel *detailModel) {
                self.detailMode = detailModel;
                //            CGRect frame = self.titleLabel.frame;
                //            frame.size.width = 100;
                //            self.titleLabel.frame = frame;
                //            self.titleLabel.text = detailModel.fullName;
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:updateVC animated:YES];
        }else if (indexPath.row==3){//性别
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"男",@"女",nil];
            actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
            actionSheet.tag = 2;
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }else if (indexPath.row==4){//年龄
//            MyselfDetilUpdateViewController *updateVC = [[MyselfDetilUpdateViewController alloc] initWithContent:[NSString stringWithFormat:@"%i",[self.detailMode.age intValue]] type:@"3" isMe:self.isMe detailModel:self.detailMode block:^(UserDetailModel *detailModel) {
//                self.detailMode = detailModel;
//                [self.tableView reloadData];
          //  }];
          //  [self.navigationController pushViewController:updateVC animated:YES];
        }else if (indexPath.row==5){//个性签名
            MyselfDetilUpdateViewController *updateVC = [[MyselfDetilUpdateViewController alloc] initWithContent:self.detailMode.sign type:@"1" isMe:self.isMe detailModel:self.detailMode block:^(UserDetailModel *detailModel) {
                self.detailMode = detailModel;
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:updateVC animated:YES];
        }else if (indexPath.row==6){//地区
            MyselfDetilUpdateViewController *updateVC = [[MyselfDetilUpdateViewController alloc] initWithContent:self.detailMode.area type:@"2" isMe:self.isMe detailModel:self.detailMode block:^(UserDetailModel *detailModel) {
                self.detailMode = detailModel;
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:updateVC animated:YES];
        }
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {//头像
        if (buttonIndex==0) {//拍照
            //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];//进入照相界面
        }else if (buttonIndex==1){//相册
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker animated:YES];
        }
    }else if (actionSheet.tag==2){//性别
        MyselfDetailCell *cell = (MyselfDetailCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        if (buttonIndex==0) {//男
            cell.valueLabel.text = @"男";
            self.gender = @"1";
            [self updateSex:self.gender];
        }else if (buttonIndex==1){//女
            cell.valueLabel.text = @"女";
            self.gender = @"2";
            [self updateSex:self.gender];
        }
    }
}
//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    
    MyselfDetailCell *cell = (MyselfDetailCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [cell.headImgView setImage:[image imageWithMaxImagePix:500 compressionQuality:0.5] forState:UIControlStateNormal];
    cell.headImgView.image = [image imageWithMaxImagePix:500 compressionQuality:0.5];
    
    [self upLoadSalesBigImage:[image imageWithMaxImagePix:500 compressionQuality:0.5]];
}
/**
 *  填充数据
 */
- (void)fillData
{
    //[self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?get", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    self.isMe = YES;
    if (self.isMe) {
        self.userId = [UserDefaultsHelper getStringForKey:@"userId"];
        [paramDict setObject:[UserDefaultsHelper getStringForKey:@"userId"] forKey:@"userId"];
        [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    }else{
        [paramDict setObject:self.userId forKey:@"userId"];
        [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)responseNotify:( id )sender
{
    RequestParseOperation * operation=( RequestParseOperation *)sender;
    
    NSLog(@"dic = %@",operation.data);
    
    
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
    if (tag ==1) {//查询用户信息
        self.detailMode = [[UserDetailModel alloc] init];
        NSDictionary *objDict = [data objectForKey:@"obj"];

         self.detailMode.loginName = [objDict objectForKey:@"loginName"];
        self.detailMode.fullName = [objDict objectForKey:@"fullName"];
        self.detailMode.alias = [objDict objectForKey:@"alias"];
        self.detailMode.age = [[objDict objectForKey:@"age"] intValue];
        self.detailMode.area = [objDict objectForKey:@"area"];
        self.detailMode.gender = [[objDict objectForKey:@"gender"] integerValue];
        self.detailMode.mobile = [objDict objectForKey:@"mobile"];
        self.detailMode.registerDate = [objDict objectForKey:@"registerDate"];
        self.detailMode.relationType = [objDict objectForKey:@"relationType"];
        self.detailMode.sign = [objDict objectForKey:@"sign"];
        self.detailMode.userPhoto = [objDict objectForKey:@"userPhoto"];
        self.detailMode.lastestPhotos = [objDict objectForKey:@"lastestPhotos"];
        self.detailMode.emotionalState = [objDict objectForKey:@"emotionalState"];
        self.detailMode.userLanguage = [objDict objectForKey:@"userLanguage"];
        self.detailMode.occupation = [objDict objectForKey:@"occupation"];
        self.detailMode.constellation = [[objDict objectForKey:@"constellation"] integerValue];
        self.detailMode.birthDay = [objDict objectForKey:@"birthday"];
        
        
//        if (!self.isMe) {
//            if ([self.detailMode.relationType intValue]==0 || [self.detailMode.relationType intValue]==2) {
//                [self.keyArray removeLastObject];
//            }
//        }
        
    //    [self stopLoading];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        self.tableHeadView.model = self.detailMode;
        [self.tableHeadView setInfomation:self.detailMode];
//        if (![self.userId isEqualToString:self.appDelegate.userModel.userId]) {
//            if ([self.detailMode.relationType intValue]==1) {
//                [self initRightBarButtonItem:[UIImage imageNamed:@"material_more_btn_nor"]
//                            highlightedImage:[UIImage imageNamed:@"material_more_btn_pre"]];
//            }
//        }

    }else if (tag==2){//删除联系人
        [[[[iToast makeText:@"联系人删除成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
    }else if (tag==3){//拉黑联系人
        [[[[iToast makeText:@"加入黑名单，你将不再收到对方的消息"] setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
    }else if (tag==4){//修改性别
      //  UserModel *model = self.appDelegate.userModel;
        self.detailMode.gender = self.gender;
     //   model.gender = self.gender;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"informationRevised" object:nil];
      //  [self messageToast:@"性别修改成功"];
#ifdef IMPORT_LETUIM_H
        [[LeTuIM sharedInstance] setMyLeTuAccountNeedUpdate:YES];
#endif
    }else if (tag==5){
       // [self messageToast:@"申请添加联系人成功"];
    }
}
// 修改头像
- (void)upLoadSalesBigImage:(UIImage*)image
{
//    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:@"userPhoto" forKey:@"item"];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setData:UIImagePNGRepresentation(image) forKey:@"userPhoto"];
    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:120];
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
//请求成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    JSONDecoder *decoder = [JSONDecoder decoder];
    NSDictionary *dict = [decoder objectWithData:request.responseData];
    NSString *picUrl = [dict objectForKey:@"obj"];
//    [UserDefaultsHelper setStringForKey:picUrl :@"userPhoto"];
    
    if (self.isMe) {
        UserModel *userModel = [AppDelegate sharedAppDelegate].userModel;
        userModel.userPhoto = picUrl;
        self.detailMode.userPhoto = picUrl;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"informationRevised" object:nil];
    
//    [self stopLoading];
    [[[[iToast makeText:@"修改头像成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
    
#ifdef IMPORT_LETUIM_H
    [[LeTuIM sharedInstance] setMyLeTuAccountNeedUpdate:YES];
#endif
}

//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"=====requestFailed");
    //    [[[[iToast makeText:@"修改失败！"] setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
    JSONDecoder *decoder = [JSONDecoder decoder];
    NSDictionary *dict = [decoder objectWithData:request.responseData];
    NSDictionary *errorDict = [dict objectForKey:@"error"];
    NSString *msg = [errorDict objectForKey:@"err_msg"];
    
  //  [self stopLoading];
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
}
/**
 *  删除联系人
 */
-(void)deleteUser
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?update", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:@"0" forKey:@"action"];//1:添加 0:删除
    [paramDict setObject:self.userId forKey:@"userIds"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
/**
 *  拉黑联系人
 */
-(void)pullBlackUser
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?updateBlacklist", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:_userId forKey:@"userIds"];
    [paramDict setObject:@"1" forKey:@"action"];//操作 1:添加 0:移出
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 3;
    [queue addOperation :operation];
}

/**
 *  修改性别
 *
 *  @param gender 性别类型 1:男 2:女
 */
-(void)updateSex:(NSString*)gender
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:@"gender" forKey:@"item"];
    [paramDict setObject:gender forKey:@"gender"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 4;
    [queue addOperation :operation];
}
/**
 *  申请添加好友
 */
-(void)applyFriend
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?applyFriend", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.detailMode.loginName forKey:@"loginName"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 5;
    [queue addOperation :operation];
}

#pragma mark clickButtonDelegate
- (void)clickAvatorButton:(NSInteger)tag
{
    if (tag ==1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
   
        
        ModifyPersonViewController* modifyVC = [[ModifyPersonViewController alloc]init];
        modifyVC.model =self.detailMode;
        [self.navigationController pushViewController:modifyVC animated:YES];
        
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor clearColor];

}

@end
