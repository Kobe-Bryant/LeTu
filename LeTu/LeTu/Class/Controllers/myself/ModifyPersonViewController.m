//
//  ModifyPersonViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import "ModifyPersonViewController.h"
#import "TableView.h"
#import "modifyPersonCell.h"
#import "SignUpdateViewController.h"
#import "NicknameUpdateViewController.h"
#import "SexUpdateViewController.h"
#import "EmotionUpdateViewController.h"
#import "BirthPlaceViewController.h"
#import "DTImage+Category.h"
#import "MyselfDetailPhotoCell.h"
#import "MyselfDetailCell.h"
#import "UserDefaultsHelper.h"
#import "LanguageViewController.h"
#import "ProfessionalViewController.h"
#import "ActionSheetView.h"

#import "UserDetailModel.h"


#define color [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]


@interface ModifyPersonViewController ()
{
    NSOperationQueue* queue;
    

}
@property(nonatomic,strong) TableView* tableView;
@property(nonatomic,strong) UIImageView* avatorImageView;
@property(nonatomic,strong) MyselfDetailCell* myCell;
@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong) ActionSheetView* sheetView;
@property(nonatomic,strong) NSIndexPath* indexPath;
@property(nonatomic,strong) UIView* blackView;






@end

@implementation ModifyPersonViewController

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
        
    
    // Do any additional setup after loading the view.
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }

    //监听签名更改的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSignMethod:) name:@"UpdateSignNotification" object:nil];
    //监听昵称更改的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNicknameMethod:) name:@"UpdateNicknameNotification" object:nil];
    //监听性别更改的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSexMethod:) name:@"UpdateSexNotification" object:nil];
    //监听出生地更改的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBirthdayMethod:) name:@"UpdateBirthdayNotification" object:nil];
    //监听语言更改的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLauangeMethod:) name:@"UpdateLauangeNotification" object:nil];
    //监听情感状态更改的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEmotionMethod:) name:@"UpdateEmotionNotification" object:nil];
    //监听职业更改的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCarerMethod:) name:@"UpdateCareerNotification" object:nil];
    
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
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 20.0, 220, 44)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"修改资料";
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
    
    self.sheetView = [[ActionSheetView alloc]initWithHeight:250.0 backColor:[UIColor whiteColor]];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIView *datePickerView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 300, 180)];
    datePickerView1.clipsToBounds = YES;
    datePickerView1.autoresizesSubviews = YES;
    datePickerView1.backgroundColor = [UIColor clearColor];
    datePickerView1.layer.cornerRadius = 8;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [datePickerView1 addSubview:self.datePicker];
    [self.sheetView addView:datePickerView1];
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(10.0, 205, 300, 40);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:color];
    [sureButton addTarget:self action:@selector(sureMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addView:sureButton];
}
- (void)sureMethod:(UIButton*)bt
{
    [self.blackView removeFromSuperview];
    NSDate* date =  self.datePicker.date;
    NSDateFormatter* formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"YYYY-MM-dd"];
    NSString* birthDate = [formate stringFromDate:date];
    UITableViewCell* cell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexPath.row inSection:self.indexPath.section]];
    cell.detailTextLabel.text = birthDate;
    [self.sheetView showOrHidden:self.tableView indexPath:self.indexPath isHidden:YES];
    [self updateBirthDate:birthDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    //self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tag =22;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3.0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
    //        return 8;
    //    }
    //    return 9;
    if (section ==0) {
        return 4;
    }else if (section ==1)
    {
        return 3;
    }
    return 2;
    
    //return [self.keyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //  if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
    if (indexPath.section ==0) {
        
     if (indexPath.row==0) {
          static NSString *CellIdentifier = @"Cell";
          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          if (!cell) {
              cell = [[MyselfDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
              cell.tag = 100;
          }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;

          MyselfDetailCell *detailCell = (MyselfDetailCell*) cell;
          detailCell.key = @"头像";
         self.myCell = detailCell;
            //读接口
         NSString* imageUrl = [NSString stringWithFormat:@"%@%@",SERVERimageURL,self.model.userPhoto];
         detailCell.faceUrl = imageUrl;
         return detailCell;
         
          
     } else if (indexPath.row ==1) {
         
         static NSString *CellIdentifier = @"Cell";
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         if (!cell) {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
         }
         
         cell.detailTextLabel.textColor = RGBCOLOR(160, 160, 160);
         cell.textLabel.textColor = RGBCOLOR(54, 54, 54);
         cell.textLabel.text = @"个性签名";
         cell.detailTextLabel.text =self.model.sign;
         
         UIImage* image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
         UIImageView* imageView = [[UIImageView alloc]init];
         imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
         imageView.image = image;
         cell.accessoryView = imageView;
         
         
         return cell;
         
     
      }else if (indexPath.row ==2)
        {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UIImage* image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
            UIImageView* imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
            imageView.image = image;
            cell.accessoryView = imageView;
            cell.detailTextLabel.textColor = RGBCOLOR(160, 160, 160);
            cell.textLabel.textColor = RGBCOLOR(54, 54, 54);
            
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text =self.model.fullName;
            return cell;

         }else {
             static NSString *CellIdentifier = @"Cell";
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
             if (!cell) {
                 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
             }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;

             UIImage* image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
             UIImageView* imageView = [[UIImageView alloc]init];
             imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
             imageView.image = image;
             cell.accessoryView = imageView;
             cell.detailTextLabel.textColor = RGBCOLOR(160, 160, 160);
             cell.textLabel.textColor = RGBCOLOR(54, 54, 54);
             cell.textLabel.text = @"性别";
             if (self.model.gender ==1) {
                 cell.detailTextLabel.text = @"男";
             }else {
             
                 cell.detailTextLabel.text = @"女";

             }
             
             
             return cell;
         }
    }
    
        if (indexPath.section ==1)
        
        {
            
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UIImage* image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
            UIImageView* imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
            imageView.image = image;
            cell.accessoryView = imageView;
            cell.detailTextLabel.textColor = RGBCOLOR(160, 160, 160);
            cell.textLabel.textColor = RGBCOLOR(54, 54, 54);
        

            if (indexPath.row ==0) {
              
                cell.textLabel.text = @"出生日期";
                NSString* date = [self.model.birthDay substringToIndex:10];
                cell.detailTextLabel.text = date;
                
    
            }else if (indexPath.row ==1)
            {
                cell.textLabel.text = @"出生地";
               cell.detailTextLabel.text = self.model.area;
        

       
            }else {
                cell.textLabel.text =@"语言";
                cell.detailTextLabel.text =self.model.userLanguage;
                
                
           }
            return cell;

            
        }
    
    if (indexPath.section ==2)
        {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImage* image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
            UIImageView* imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
            imageView.image = image;
            cell.accessoryView = imageView;
            cell.detailTextLabel.textColor = RGBCOLOR(160, 160, 160);
            cell.textLabel.textColor = RGBCOLOR(54, 54, 54);
            if (indexPath.row==0) {
                cell.textLabel.text =@"情感状态";
                cell.detailTextLabel.text =self.model.emotionalState;
                
         
          }else {
              cell.textLabel.text =@"职业";
              cell.detailTextLabel.text =self.model.occupation;
              
     
             }
            return cell;

            
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
   
    if ( section ==1 || section==2 || section ==3) {
        
        return 12.0;
    }
    return 0.1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            
            return 60.0;
   
        }
        
        return 40.0;
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
    if (indexPath.section ==0) {
        
        if (indexPath.row ==0) {
         
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍照",@"相册",nil];
            actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
            actionSheet.tag = 1;
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            
            
        }else if(indexPath.row ==1){
        
            SignUpdateViewController* sign = [[SignUpdateViewController alloc]init];
            sign.model = self.model;
            [self.navigationController pushViewController:sign animated:YES];
            
      }else if (indexPath.row ==2)
        {
            NicknameUpdateViewController* sign = [[NicknameUpdateViewController alloc]init];
            sign.model = self.model;
            [self.navigationController pushViewController:sign animated:YES];
            
            
        }else {
            
            SexUpdateViewController* sign = [[SexUpdateViewController alloc]init];
            sign.model = self.model;
            [self.navigationController pushViewController:sign animated:YES];
            

        
        }
    }
    
    if (indexPath.section ==1) {
        
        if (indexPath.row ==0) {
            
        self.indexPath = indexPath;
            self.blackView = [[UIView alloc]init];
            self.blackView.frame = CGRectMake(0.0, 64.0, 320.0, self.view.frame.size.height - 64.0);
            self.blackView.backgroundColor = [UIColor blackColor];
            self.blackView.alpha = 0.7;
            [self.view addSubview:self.blackView];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
            tap.numberOfTapsRequired = 1;
            [self.blackView addGestureRecognizer:tap];
            
         [self.sheetView showOrHidden:self.tableView indexPath:indexPath isHidden:NO];
            
        }else if (indexPath.row ==1)
        {
       
            BirthPlaceViewController* sign = [[BirthPlaceViewController alloc]init];
            sign.model = self.model;
           [self.navigationController pushViewController:sign animated:YES];
        }else {
            
            LanguageViewController* sign = [[LanguageViewController alloc]init];
            sign.model = self.model;
            [self.navigationController pushViewController:sign animated:YES];
        }
        
    }
    if (indexPath.section ==2) {
        
        if (indexPath.row ==0) {
        
            
            EmotionUpdateViewController* sign = [[EmotionUpdateViewController alloc]init];
            sign.model = self.model;
            [self.navigationController pushViewController:sign animated:YES];
            
      }else {
        
          ProfessionalViewController* sign = [[ProfessionalViewController alloc]init];
          sign.model = self.model;
          [self.navigationController pushViewController:sign animated:YES];
       
        
        }
        
        
    }
}
- (void)clickTap:(UITapGestureRecognizer*)tap
{
    [self.sheetView showOrHidden:self.tableView indexPath:nil isHidden:YES];
    [self.blackView removeFromSuperview];
    

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
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];

    [self.tableView reloadData];
    
    MyselfDetailCell *cell = (MyselfDetailCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
   cell.headImgView.image = [image imageWithMaxImagePix:500 compressionQuality:0.5];
 
  //上传头像。
   [self upLoadSalesBigImage:[image imageWithMaxImagePix:500 compressionQuality:0.5]];
}
// 修改头像
- (void)upLoadSalesBigImage:(UIImage*)image
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:@"userPhoto" forKey:@"item"];
    NSString* lkey =[UserDefaultsHelper getStringForKey:@"key"];
        
    [request setPostValue:lkey forKey:@"l_key"];
    
    [request setData:UIImagePNGRepresentation(image) forKey:@"userPhoto"];
    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:120];
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"%d",request.tag);
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    JSONDecoder *decoder = [JSONDecoder decoder];
    NSDictionary *dict = [decoder objectWithData:request.responseData];
    NSString* message = [dict objectForKey:@"err_msg"];
    NSLog(@"message = %@",message);
    
    
    NSString *picUrl = [dict objectForKey:@"obj"];
        [UserDefaultsHelper setStringForKey:picUrl :@"userPhoto"];
    
  //  if (self.isMe) {
        UserModel *userModel = [AppDelegate sharedAppDelegate].userModel;
        userModel.userPhoto = picUrl;
        self.model.userPhoto = picUrl;
  //  }
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

- (void)updateBirthDate:(NSString*)date
{
  
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    NSString* url = [NSString stringWithFormat:@"&l_key=%@&item=birthday&birthday=%@",lkey,date];
    NSString* lastUrl = [requestUrl stringByAppendingString:url];
    
    NSLog(@"%@",lastUrl);
    
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:lastUrl delegate:self];
    operation.RequestTag = 1;
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
    
    NSString *string = [data objectForKey:@"obj"];
    
    // self.detailModel.sign = string;
    userModel.sign = string;
    [[[[iToast makeText:@"出生日期修改成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    [self.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
    
    
    
}
- (void)backButtonMethod:(UIButton*)bt
{
    
    [self.sheetView showOrHidden:nil indexPath:nil isHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//NSNOTIFICATION METHOD
- (void)updateSignMethod:(NSNotification*)notification
{
    NSString* sign = notification.object;
    self.model.sign = sign;
    [self.tableView reloadData];
}
- (void)updateNicknameMethod:(NSNotification*)notification
{
    NSString* nickname = notification.object;
    self.model.fullName = nickname;
    [self.tableView reloadData];
}
- (void)updateSexMethod:(NSNotification*)notification
{
    NSString* Sex = notification.object;
    if ([Sex isEqualToString:@"1"]) {
        
        self.model.gender =1;
    }else {
     
        self.model.gender = 2;
    }
    [self.tableView reloadData];
}
- (void)updateBirthdayMethod:(NSNotification*)notification
{
    NSString* area = notification.object;
    self.model.area = area;
    [self.tableView reloadData];
}
- (void)updateLauangeMethod:(NSNotification*)notification
{
    NSString* lauange = notification.object;
    self.model.userLanguage = lauange;
    [self.tableView reloadData];
}

- (void)updateEmotionMethod:(NSNotification*)notification
{
    NSString* emotion = notification.object;
    self.model.emotionalState = emotion;
    [self.tableView reloadData];
}
- (void)updateCarerMethod:(NSNotification*)notification
{
    NSString* carer = notification.object;
    self.model.occupation = carer;
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
