//
//  RegistTwoViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-16.
//
//

#import "RegistTwoViewController.h"
#import "RegistThreeViewController.h"
#import "DejalActivityView.h"


@interface RegistTwoViewController ()
{
    MBProgressHUD* HUD;
    UIView* blankView;

}
@property(nonatomic,strong) UIButton* addAvatorImageButton;
@property(nonatomic,strong) UITextField* nicknameField;
@property(nonatomic,strong) UITextField* sexField;
@property(nonatomic,strong) UIButton* manButton;
@property(nonatomic,strong) UIButton* womanButton;
@property(nonatomic,strong) UITextField* password1TextField;
@property(nonatomic,strong) UITextField* password2TextField;
@property(nonatomic,strong) UIImage* avatorImage;
@property(nonatomic,strong) NSOperationQueue* queue;

@property(nonatomic,strong) NSString* mobileString;
@property(nonatomic,strong) NSString* captchaString;
@property(nonatomic,strong) NSString* fileImagePath;




@end

@implementation RegistTwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.hidesBackButton = YES;
        
    
    }
    return self;
}
- (id)initWithMobileTextfield:(NSString*)mobile captcha:(NSString*)captcha
{
    self = [super init];
    if (self) {
    
        self.mobileString = mobile;
        self.captchaString = captcha;
    }
    return self;
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));

    
    
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 120, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"注册2/3";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    
    UIImage* backImage = [UIImage imageNamed:@"topBack.png"];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 80.0, 40.0);
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -35.0, 0.0, 0.0);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.tag = 1;
    [backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIImage* nextImage = [UIImage imageNamed:@"topNext.png"];
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(0.0, 0.0, 80, 40);
    [sureButton setImage:nextImage forState:UIControlStateNormal];
    [sureButton setTitle:@"下一步" forState:UIControlStateNormal];
    sureButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 70, 0.0, 0.0);
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, -8.0, 0.0, 0.0);
    sureButton.backgroundColor = [UIColor clearColor];
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 2;
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:sureButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickViewGesture:)];
    tap.numberOfTapsRequired =1;
    tap.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:tap];
}
- (void)clickViewGesture:(UITapGestureRecognizer*)tap
{
    
    [self.password1TextField resignFirstResponder];
    [self.password2TextField resignFirstResponder];
    [self.sexField resignFirstResponder];
    [self.nicknameField resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        
    self.view.transform = CGAffineTransformIdentity;
        
        
    }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self clickViewGesture:nil];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    NSLog(@"%@",NSStringFromCGRect(self.view.frame));

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideFrame:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UIImage* userImage = [UIImage imageNamed:@"loginInput305x125.png"];
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(8.0,10,userImage.size.width, userImage.size.height);
    imageView.image = userImage;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UIImage* defaultImage = [UIImage imageNamed:@"loginDefaultAvatar.png"];
    self.addAvatorImageButton = [DTButton buttonWithType:UIButtonTypeCustom];
    self.addAvatorImageButton.backgroundColor = [UIColor clearColor];
    self.addAvatorImageButton.frame = CGRectMake((imageView.frame.size.width - defaultImage.size.width)/2.0, 15.0,defaultImage.size.width, defaultImage.size.height);
    [self.addAvatorImageButton setBackgroundImage:defaultImage forState:UIControlStateNormal];
    self.addAvatorImageButton.layer.masksToBounds    = NO;
    self.addAvatorImageButton.clipsToBounds          = YES;
    self.addAvatorImageButton.tag = 3;
    self.addAvatorImageButton.layer.cornerRadius = defaultImage.size.width/2.0;
    [self.addAvatorImageButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
   [imageView addSubview:self.addAvatorImageButton];
    
    UILabel* label = [[UILabel alloc]init];
    label.frame = CGRectMake(CGRectGetMinX(self.addAvatorImageButton.frame), CGRectGetMaxY(self.addAvatorImageButton.frame)+5, 80, 20);
    label.font = [UIFont systemFontOfSize:10.0];
    label.textColor =RGBCOLOR(135, 135, 135);
    label.text = @"点击此处添加头像";
    [imageView addSubview:label];
    
    
    
    
    
    
    UIImage* nickImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* nickImageView = [[UIImageView alloc]init];
    nickImageView.frame = CGRectMake(8.0, CGRectGetMaxY(imageView.frame) +10,nickImage.size.width, nickImage.size.height);
    nickImageView.image = nickImage;
    nickImageView.userInteractionEnabled = YES;
    [self.view addSubview:nickImageView];
    
    
    UIImage* personImage = [UIImage imageNamed:@"loginName.png"];
    UIImageView* personImageView = [[UIImageView alloc]initWithImage:personImage];
    personImageView.frame = CGRectMake(15.0, (nickImage.size.height - personImage.size.height)/2.0, personImageView.frame.size.width, personImageView.frame.size.height);
    [nickImageView addSubview:personImageView];
    
    
    
    self.nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personImageView.frame) + 15.0, 1.0, 250, 40)];
    self.nicknameField.backgroundColor = [UIColor clearColor];
    self.nicknameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nicknameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nicknameField.placeholder = @"请输入您的昵称";
    self.nicknameField.delegate = self;
    [nickImageView addSubview:self.nicknameField];
    
    
    
    UIImage* sexImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* sexImageView = [[UIImageView alloc]init];
    sexImageView.frame = CGRectMake(8.0, CGRectGetMaxY(nickImageView.frame) +10,nickImage.size.width, nickImage.size.height);
    sexImageView.image = sexImage;
    sexImageView.userInteractionEnabled = YES;
    [self.view addSubview:sexImageView];
    
  
    
    UIImage* personsexImage = [UIImage imageNamed:@"loginGender.png"];
    UIImageView* personsexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0, (sexImageView.frame.size.height - personsexImage.size.height)/2.0, personsexImage.size.width, personsexImage.size.height)];
    personsexImageView.image = personsexImage;
    [sexImageView addSubview:personsexImageView];
    
    
    
    self.sexField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personsexImageView.frame) + 15.0, 1.0, 200, 40)];
    self.sexField.backgroundColor = [UIColor clearColor];
    self.sexField.clearButtonMode = UITextFieldViewModeNever;
    self.sexField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.sexField.placeholder = @"请选择您的性别";
    self.sexField.delegate = self;

    [sexImageView addSubview:self.sexField];
    
    UIImage* manImage = [UIImage imageNamed:@"loginBoy.png"];
    UIImageView* manImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.sexField.frame)-68, self.sexField.frame.origin.y+8, manImage.size.width, manImage.size.height)];
    manImageView.image = manImage;
    [sexImageView addSubview:manImageView];
    
    UIImage* manUnselectImage = [UIImage imageNamed:@"loginCheck.png"];
    self.manButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.manButton.backgroundColor = [UIColor clearColor];
    self.manButton.frame = CGRectMake(CGRectGetMaxX(manImageView.frame)+5, manImageView.frame.origin.y,manUnselectImage.size.width, manUnselectImage.size.height);
    [self.manButton setBackgroundImage:manUnselectImage forState:UIControlStateNormal];
    self.manButton.selected = NO;
    self.manButton.tag = 4;
    [self.manButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [sexImageView addSubview:self.manButton];
    
    UIImage* womanImage = [UIImage imageNamed:@"loginGirl.png"];
    UIImageView* womanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.manButton.frame)+ 15.0, manImageView.frame.origin.y, womanImage.size.width, womanImage.size.height)];
    womanImageView.image = womanImage;
    [sexImageView addSubview:womanImageView];
    
    UIImage* womanUnselectImage = [UIImage imageNamed:@"loginCheck.png"];
    self.womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.womanButton.backgroundColor = [UIColor clearColor];
    self.womanButton.frame = CGRectMake(CGRectGetMaxX(womanImageView.frame)+8, manImageView.frame.origin.y,womanUnselectImage.size.width, womanUnselectImage.size.height);
    self.womanButton.selected = NO;
    [self.womanButton setBackgroundImage:womanUnselectImage forState:UIControlStateNormal];
    self.womanButton.tag = 5;
    [self.womanButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [sexImageView addSubview:self.womanButton];

    
    
    UIImage* firstImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* passwordView = [[UIImageView alloc]init];
    passwordView.frame = CGRectMake(8.0, CGRectGetMaxY(sexImageView.frame) +16,firstImage.size.width, firstImage.size.height);
    passwordView.image = firstImage;
    passwordView.userInteractionEnabled = YES;
    [self.view addSubview:passwordView];
    
    
    
    UIImage* lockImage = [UIImage imageNamed:@"loginCipher.png"];
    UIImageView* lockoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0, (passwordView.frame.size.height - lockImage.size.height)/2.0, lockImage.size.width, lockImage.size.height)];
    lockoneImageView.image = lockImage;
    [passwordView addSubview:lockoneImageView];
    
    
    self.password1TextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lockoneImageView.frame) + 15.0, 1.0, 250, 40)];
    self.password1TextField.backgroundColor = [UIColor clearColor];
    self.password2TextField.returnKeyType = UIReturnKeyDone;
    self.password1TextField.secureTextEntry = YES;
    self.password1TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password1TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password1TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password1TextField.text = @"";
    self.password1TextField.placeholder = @"请输入密码";
    self.password1TextField.delegate = self;
    [passwordView addSubview:self.password1TextField];
    
    
    
    UIImage* secondImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* passwordViewtwo = [[UIImageView alloc]init];
    passwordViewtwo.frame = CGRectMake(8.0, CGRectGetMaxY(passwordView.frame) +16,secondImage.size.width, secondImage.size.height);
    passwordViewtwo.image = secondImage;
    passwordViewtwo.userInteractionEnabled = YES;
    [self.view addSubview:passwordViewtwo];
    
    
    
    UIImage* lockImagetwo = [UIImage imageNamed:@"loginCipher.png"];
    UIImageView* locktwoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0, (passwordViewtwo.frame.size.height - lockImagetwo.size.height)/2.0, lockImagetwo.size.width, lockImagetwo.size.height)];
    locktwoImageView.image = lockImagetwo;
    [passwordViewtwo addSubview:locktwoImageView];
    
    
    self.password2TextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(locktwoImageView.frame) + 15.0, 1.0, 250, 40)];
    self.password2TextField.backgroundColor = [UIColor clearColor];
    self.password2TextField.returnKeyType = UIReturnKeyDone;
    self.password2TextField.secureTextEntry = YES;
    self.password2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password2TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password2TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password2TextField.text = @"";
    self.password2TextField.placeholder = @"再次输入密码";
    self.password2TextField.delegate = self;
    [passwordViewtwo addSubview:self.password2TextField];
    


}
- (void)commitData
{
    if ([[self.nicknameField text] isEqualToString:@""]) {
        [[[[iToast makeText:@"昵称不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    }else if ([[self.sexField text] isEqualToString:@""]){
        [[[[iToast makeText:@"请选择性别..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    }else if ([[self.password1TextField text] isEqualToString:@""]){
        [[[[iToast makeText:@"密码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    }else if (![[self.password1TextField text] isEqualToString:[self.password2TextField text]]){
        [[[[iToast makeText:@"两次密码不相同..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    }else{
       
        [self gotoRegister];
    }
}
- (void)gotoRegister
{
 //去提交注册的数据

    //图片
  
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?register", SERVERAPIURL];
    if (self.queue == nil)
    {
        self.queue = [[ NSOperationQueue alloc ] init ];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.nicknameField.text forKey:@"fullName"];
    if ([self.sexField.text isEqualToString:@"男"]) {
        [paramDict setObject:@"1" forKey:@"gender"];
     
    } else if ([self.sexField.text isEqualToString:@"女"])
    {
      
        [paramDict setObject:@"2" forKey:@"gender"];

    }else {
    
      [[[[iToast makeText:@"请输入正确的性别类型..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    
    }
    [paramDict setObject:self.mobileString forKey:@"mobile"];
    [paramDict setObject:self.captchaString forKey:@"captcha"];
    [paramDict setObject:@"" forKey:@"age"];
    [paramDict setObject:self.password1TextField.text forKey:@"password"];
    [paramDict setObject:self.fileImagePath forKey:@"userPhoto"];
    [paramDict setObject:@"" forKey:@"area"];

    

    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [self.queue addOperation :operation];
    
    

}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
     if(tag==5){
        
        
        NSLog(@"dic = %@",data);
        
        
        //修改了。。
        [self stopLoading];
        
        
        
        RegistThreeViewController* registVC = [[RegistThreeViewController alloc]init];
        [self.navigationController pushViewController:registVC animated:YES];
 
        
        
        
        [UserDefaultsHelper setStringForKey:self.mobileString :@"loginName"];
        [UserDefaultsHelper setStringForKey:self.password1TextField.text :@"passWord"];
        return;

        
        [[[[iToast makeText:@"注册成功！"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
//        DetailedSettingViewController *dsVC = [[DetailedSettingViewController alloc] initWithAccount:self.mobileTextField.text password:self.password1TextField.text];
//        [self.navigationController pushViewController:dsVC animated:YES];
        
        //        [self.navigationController popViewControllerAnimated:YES];
        //        [self dismissModalViewControllerAnimated:YES];
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
        }
        else if (errCode < 2)
        {
            [self reponseDatas:operation.data operationTag:operation.RequestTag];
            
            //       if (errCode ==1)
            //          [[iToast makeText:NSLocalizedString(errMsg,@"")] show];
        }
        else {
            [self reponseFaild:operation.RequestTag];
            [self stopLoading];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:errMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        
    }else{
        [self stopLoading];
        //        [self messageToast:@"无法连接服务器,请检查您的网络或稍后重试"];
    }
}
-( void )reponseFaild:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    //修改了。。
    [self stopLoading];
}

- (void)messageToast:(NSString*)msg
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}
- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if(bt.tag ==2) {
        
        
        [self commitData];
        
    } else if (bt.tag ==3){
    
     
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"相册",nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
        
    }else if (bt.tag ==4){
       UIImage* unselectImage = [UIImage imageNamed:@"loginCheck.png"];
        UIImage* selectImage = [UIImage imageNamed:@"loginCheckPre.png"];

        if (self.manButton.selected ==NO && self.womanButton.selected ==NO) {
            
          [self.manButton setBackgroundImage:selectImage forState:UIControlStateNormal];
          [self.womanButton setBackgroundImage:unselectImage forState:UIControlStateNormal];
          self.sexField.text = @"男";
        }
        if (self.manButton.selected ==NO && self.womanButton.selected ==YES) {
            
            [self.manButton setBackgroundImage:selectImage forState:UIControlStateNormal];
            [self.womanButton setBackgroundImage:unselectImage forState:UIControlStateNormal];
            self.sexField.text = @"男";
        } if (self.manButton.selected ==YES && self.womanButton.selected ==NO) {
            
            [self.manButton setBackgroundImage:unselectImage forState:UIControlStateNormal];
            self.sexField.text = @"";
        }
        
        self.manButton.selected =!self.manButton.selected;
        self.womanButton.selected = NO;
    
    }else if (bt.tag ==5)
    {
        UIImage* selectImage = [UIImage imageNamed:@"loginCheckPre.png"];
        UIImage* manUnselectImage = [UIImage imageNamed:@"loginCheck.png"];
        if (self.manButton.selected ==NO && self.womanButton.selected ==NO) {
            
            [self.womanButton setBackgroundImage:selectImage forState:UIControlStateNormal];
            [self.manButton setBackgroundImage:manUnselectImage forState:UIControlStateNormal];
            self.sexField.text = @"女";
        } if (self.womanButton.selected ==YES && self.manButton.selected ==NO) {
            
             [self.womanButton setBackgroundImage:manUnselectImage forState:UIControlStateNormal];
            self.sexField.text = @"";
        } if (self.manButton.selected ==YES && self.womanButton.selected ==NO) {
            
         
                [self.womanButton setBackgroundImage:selectImage forState:UIControlStateNormal];
               [self.manButton setBackgroundImage:manUnselectImage forState:UIControlStateNormal];
            self.sexField.text = @"女";

            
        }
        self.womanButton.selected = !self.womanButton.selected;
        self.manButton.selected = NO;
    
    }

}
- (void)stopLoading
{
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.removeFromSuperViewOnHide = YES;
    
    if (HUD !=nil) {
        HUD.hidden = YES;
    }
    [blankView removeFromSuperview];
    blankView = nil;
    [DejalActivityView removeView];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"buttonindex = %d",buttonIndex);
    if (buttonIndex ==0) {
        
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
         [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        [imagePicker setDelegate:self];
        [self presentModalViewController:imagePicker animated:YES];
    }else if (buttonIndex ==1){
    
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
        
        [imagePicker setDelegate:self];
        [self presentModalViewController:imagePicker animated:YES];
    
    } else {
    
     
    }
    
   
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *origImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"self.uploadImageViewArray %@",origImage);
   [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"completion");
        
    }];
    
    [self.addAvatorImageButton setBackgroundImage:origImage forState:UIControlStateNormal];
    self.avatorImage = origImage;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.fileImagePath]) {
        
        [fileManager removeItemAtPath:self.fileImagePath error:nil];
    }
    
    NSArray* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [documentPath objectAtIndex:0];
    NSData* data = UIImageJPEGRepresentation(self.avatorImage, 1.0);
    NSString* filePath = [path stringByAppendingPathComponent:@"image.png"];
    BOOL success =[data writeToFile:filePath atomically:YES];
    self.fileImagePath = filePath;
    NSLog(@"success = %d",success);
    
  
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.view.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardShowFrame:(NSNotification*)notification
{

    NSDictionary* dic = notification.userInfo;
    
    CGFloat duration = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"rect = %@",NSStringFromCGRect(rect));
    
    NSLog(@"%f",rect.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        
    self.view.transform = CGAffineTransformMakeTranslation(0, -(rect.size.height-146.0));
        
    }];

}
- (void)keyboardHideFrame:(NSNotification*)notification
{
    NSDictionary* dic = notification.userInfo;
    NSLog(@"%@",dic);
    
    CGFloat duration = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"rect = %@",NSStringFromCGRect(rect));
    
    NSLog(@"%f",rect.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        
        self.view.transform = CGAffineTransformIdentity;
    }];
}

@end
