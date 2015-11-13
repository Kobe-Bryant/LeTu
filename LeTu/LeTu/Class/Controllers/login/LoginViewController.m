//
//  LoginViewController.m
//  E-learning
//
//  Created by Roland on 12-6-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
//  登录

#import "LoginViewController.h"
#import "UserSql.h"
#import "UserModel.h"
#import "DTButton.h"
#import "DejalActivityView.h"
#import "ForgotPasswordViewController.h"
#import "ForgottenViewController.h"

#ifdef IMPORT_LETUIM_H
#import "LeTuIM.h"
#endif

@interface LoginViewController ()
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)MBProgressHUD *progressHUD;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UITextField *passwordTextField;
@property(nonatomic,strong)UIButton *forgotPasswordButton;
@property(nonatomic,strong)UIButton *loginButton;
//@property(nonatomic,strong)DTButton *autoLoginButton;
@property(nonatomic,strong) UIButton* autoLoginButton;
@property(nonatomic,strong)UIButton *registButton;
@property(nonatomic,assign) BOOL viewWillAppeared;


@property(nonatomic,assign)BOOL toSetting;
@end

@implementation LoginViewController

-(id)initToSetting:(BOOL)toSetting
{
    self = [super init];
    if (self) {
        self.toSetting = toSetting;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    [self initViews];
}
- (void)initViews
{
    
   UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, FRAME_WIDTH, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"登录";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
   
 
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    NSLog(@"%d",self.navigationController.navigationBarHidden);
    //设置导航栏的背景
    
    
    UIImage* navigationBarIOS7Image = [UIImage imageNamed:@"navBg.png"];
    UIImage* navigationBarIOS6Image = [UIImage imageNamed:@"nav_bg320x44.png"];
    
    
    if (iOS_7_Above) {
        [[UINavigationBar appearance] setBackgroundImage:navigationBarIOS7Image
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"Transparent.png"]];
        
    }else {
    
        [[UINavigationBar appearance] setBackgroundImage:navigationBarIOS6Image
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"Transparent.png"]];
        
    
    }
    
    
    
  
  
    
    if (self.viewWillAppeared) {
    
        return;
        
    }else {
        self.viewWillAppeared = YES;
        
    }
    
    UIImage* userImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(8.0,10,userImage.size.width, userImage.size.height);
    imageView.image = userImage;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    UIImage* personImage = [UIImage imageNamed:@"loginAccount.png"];
    UIImageView* personImageView = [[UIImageView alloc]initWithImage:personImage];
    personImageView.frame = CGRectMake(15.0, (userImage.size.height - personImage.size.height)/2.0, personImageView.frame.size.width, personImageView.frame.size.height);
    [imageView addSubview:personImageView];
    
    
    self.accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personImageView.frame) + 15.0, 3.0, 250, 40)];
    self.accountTextField.backgroundColor = [UIColor clearColor];
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
   self.accountTextField.placeholder = @"请输入您的手机号码/搭一程号";
    self.accountTextField.text = [UserDefaultsHelper getStringForKey:@"loginName"];
    [imageView addSubview:self.accountTextField];
    
    
    
    UIImage* passwordbackImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* passwordimageView = [[UIImageView alloc]init];
    passwordimageView.frame = CGRectMake(8.0, CGRectGetMaxY(imageView.frame) + 15.0,userImage.size.width, userImage.size.height);
    passwordimageView.image = passwordbackImage;
    passwordimageView.userInteractionEnabled = YES;
    [self.view addSubview:passwordimageView];
    
    
    
    UIImage* passwordImage = [UIImage imageNamed:@"loginPassword.png"];
    UIImageView* passwordbackImageView = [[UIImageView alloc]initWithImage:passwordImage];
    passwordbackImageView.frame = CGRectMake(15.0, (userImage.size.height - personImage.size.height)/2.0, passwordbackImageView.frame.size.width, passwordbackImageView.frame.size.height);
    [passwordimageView addSubview:passwordbackImageView];
    
  
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personImageView.frame) + 15.0, 3.0, 250, 40)];
    self.passwordTextField.backgroundColor = [UIColor clearColor];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.placeholder = @"输入密码";
    self.passwordTextField.text = [UserDefaultsHelper getStringForKey:@"passWord"];
    [passwordimageView addSubview:self.passwordTextField];
    
    
    
    self.forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(250, CGRectGetMaxY(passwordimageView.frame) +2.0, 70, 30)];
    self.forgotPasswordButton.backgroundColor = [UIColor clearColor];
    self.forgotPasswordButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.forgotPasswordButton setTitleColor:RGBCOLOR(149, 149, 149) forState:UIControlStateNormal];
//    [self.forgotPasswordButton setTitleColor:RGBCOLOR(15, 120, 218) forState:UIControlStateHighlighted];
    [self.forgotPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.forgotPasswordButton.tag = 1;
    [self.forgotPasswordButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgotPasswordButton];
    
    UIImage* loginImage = [UIImage imageNamed:@"loginButtonPre.png"];
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, CGRectGetMaxY(self.forgotPasswordButton.frame) +10.0, loginImage.size.width, loginImage.size.height)];
    [self.loginButton setImage:[UIImage imageNamed:@"loginButtonPre.png"] forState:UIControlStateNormal];
//    [self.loginButton setImage:[UIImage imageNamed:@"login_btn_current"] forState:UIControlStateHighlighted];
    self.loginButton.tag = 2;
    [self.loginButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.autoLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.autoLoginButton.backgroundColor = [UIColor clearColor];
    self.autoLoginButton.frame = CGRectMake(8.0, CGRectGetMaxY(self.loginButton.frame) +9.0, 100, 22);
    self.autoLoginButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.autoLoginButton setImage:[UIImage imageNamed:@"loginCheck.png"] forState:UIControlStateNormal];
    [self.autoLoginButton setTitle:@"自动登录" forState:UIControlStateNormal];
     self.autoLoginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.autoLoginButton setTitleColor:RGBCOLOR(135, 135, 135) forState:UIControlStateNormal];
    self.autoLoginButton.selected = NO;
    self.autoLoginButton.tag = 3;
    [self.autoLoginButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.autoLoginButton];
    
    self.registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registButton.backgroundColor = [UIColor clearColor];
    self.registButton.frame = CGRectMake(200, CGRectGetMaxY(self.loginButton.frame) +10.0, 115, 22);
    self.registButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.registButton setTitle:@"免费注册" forState:UIControlStateNormal];
    [self.registButton setTitleColor:RGBCOLOR(135, 135, 135) forState:UIControlStateNormal];
    self.registButton.tag = 4;
    [self.registButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registButton];
    
    UIImage* nextImage = [UIImage imageNamed:@"loginNext.png"];
    UIImageView* nextImageView = [[UIImageView alloc]init];
    nextImageView.image = nextImage;
    nextImageView.frame = CGRectMake(CGRectGetMaxX(self.registButton.frame)-20, self.registButton.frame.origin.y+3, nextImage.size.width, nextImage.size.height);
    [self.view addSubview:nextImageView];
    
    [UserDefaultsHelper setStringForKey:@"false" :@"automaticLogin"];
    
    return;
    
    
#ifndef IMPORT_LETUIM_H // 暂时隐藏未实现的功能
    //TODO: 第三方登录
    int height = [UIScreen mainScreen].bounds.size.height - 170;
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        height +=30;
    }
    UIImageView *othersLineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 1)];
    othersLineView.image = [UIImage imageNamed:@"login_others_line"];
    [self.view addSubview:othersLineView];
    
    UILabel *othersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height-10, 320, 20)];
    othersLabel.backgroundColor = [UIColor clearColor];
    othersLabel.textAlignment = UITextAlignmentCenter;
    othersLabel.textColor = [UIColor blackColor];
    othersLabel.font = [UIFont systemFontOfSize:13.0f];
    othersLabel.text = @"使用其他帐号登录";
    [self.view addSubview:othersLabel];
    
    UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboButton.backgroundColor = [UIColor clearColor];
    weiboButton.frame = CGRectMake(60, height+20, 52, 52);
    [weiboButton setImage:[UIImage imageNamed:@"login_others_xinlangweibo_normal"] forState:UIControlStateNormal];
    [weiboButton setImage:[UIImage imageNamed:@"login_others_xinlangweibo_press"] forState:UIControlStateHighlighted];
    weiboButton.tag = 5;
    [weiboButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboButton];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.backgroundColor = [UIColor clearColor];
    qqButton.frame = CGRectMake(200, height+20, 52, 52);
    [qqButton setImage:[UIImage imageNamed:@"login_others_qq_normal"] forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"login_others_qq_press"] forState:UIControlStateHighlighted];
    qqButton.tag = 6;
    [qqButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqButton];
#endif
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.view.backgroundColor = [UIColor clearColor];

}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    if (button.tag == 1) {//忘记密码
        
        NSLog(@"忘记密码");
        ForgottenViewController *forgottenVC = [[ForgottenViewController alloc] init];
        if (iOS_7_Above) {
            
            forgottenVC.edgesForExtendedLayout = UIRectEdgeNone;
        }
        [self.navigationController pushViewController:forgottenVC animated:YES];
        
        
    }else if (button.tag ==2){//登录
        [self.accountTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        //        [self initProgressHUD];
        if (self.accountTextField==nil || [self.accountTextField.text isEqualToString:@""]) {
            //修改了。。。。。。。。。。。

          [self messageToast:@"请输入帐号!"];
            return;
        }
        if (self.passwordTextField==nil || [self.passwordTextField.text isEqualToString:@""]) {
            //修改了。。。。。。。。。。。
         [self messageToast:@"请输入密码!"];
            return;
        }
        [DejalActivityView activityViewForViewWithTitle:@"" addToView:self.view];
        [self requestLogin];
    }else if (button.tag ==3){//自动登录
        UIImage* selectImage =[UIImage imageNamed:@"loginCheckPre.png"];

        NSLog(@"%d",self.autoLoginButton.selected);
        
        self.autoLoginButton.selected = !self.autoLoginButton.selected;

        if (self.autoLoginButton.selected) {
            
       [self.autoLoginButton setImage:selectImage forState:UIControlStateNormal];
            
        }else {
        
      [self.autoLoginButton setImage:[UIImage imageNamed:@"loginCheck.png"] forState:UIControlStateNormal];
        }
//        self.autoLoginButton.isSelect = ![self.autoLoginButton isSelect];
//        NSLog(@"%d",self.autoLoginButton.isSelect);

        NSLog(@"自动登录");
    }else if (button.tag ==4){//免费注册
        NSLog(@"免费注册");
        ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc] init];
        NSLog(@"%@",self.navigationController);
        [self.navigationController pushViewController:vc animated:YES];
        //        [self presentModalViewController:vc animated:YES];
    }else if (button.tag ==5){//微博登录
        NSLog(@"微博登录");
    }else if (button.tag ==6){//qq登录
        NSLog(@"qq登录");
    }

}
- (void)messageToast:(NSString*)msg
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}
/**
 *  初始化加载等待框
 */
- (void)initProgressHUD
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.progressHUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    self.progressHUD.removeFromSuperViewOnHide = YES;
}
/**
 *  用户登录
 */
- (void)requestLogin
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    /*
     NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?login", SERVERAPIURL];
     if (queue == nil)
     {
     queue = [[ NSOperationQueue alloc ] init];
     }
     
     NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
     [paramDict setObject:self.accountTextField.text forKey:@"login_name"];
     [paramDict setObject:self.passwordTextField.text forKey:@"password"];
     
     RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
     operation.RequestTag = 1;
     [queue addOperation :operation];
     //*/
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?login", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:self.accountTextField.text forKey:@"login_name"];
    [request setPostValue:self.passwordTextField.text forKey:@"password"];
    
    NSLog(@"%@",self.accountTextField.text);
    NSLog(@"%@",self.passwordTextField.text);

    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:60];
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [DejalActivityView removeView];
    //    self.progressHUD.hidden = YES;
    [UserDefaultsHelper setStringForKey:@"yes" :@"automaticLogin"];
    
    [UserDefaultsHelper setStringForKey:self.accountTextField.text :@"loginName"];
    if (self.autoLoginButton.selected) {
        [UserDefaultsHelper setStringForKey:@"yes" :@"automaticLogin"];

       // [UserDefaultsHelper setStringForKey:self.passwordTextField.text :@"passWord"];
    }else{
        [UserDefaultsHelper setStringForKey:@"false" :@"automaticLogin"];

    //    [UserDefaultsHelper setStringForKey:@"" :@"passWord"];
    }
    
    JSONDecoder *decoder=[JSONDecoder decoder];
    NSDictionary *dict=[decoder objectWithData:request.responseData];
    NSDictionary *error = [dict objectForKey:@"error"];
    if ([[error objectForKey:@"err_code"] intValue] == 2) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[error objectForKey:@"err_msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary *objDict = [dict objectForKey:@"obj"];
    
    NSLog(@"%@",[objDict objectForKey:@"key"]);
                 
    NSLog(@"%@",[objDict objectForKey:@"fullName"]);
    NSLog(@"%@",[objDict objectForKey:@"sign"]);
    NSLog(@"%@",[objDict objectForKey:@"userPhoto"]);

    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"key"] :@"key"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"id"] :@"userId"];
    [UserDefaultsHelper setStringForKey:self.passwordTextField.text :@"passWord"];
    
    //    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"loginName"] :@"loginName"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"fullName"] :@"fullName"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"age"] :@"age"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"area"] :@"area"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"gender"] :@"gender"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"mobile"] :@"mobile"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"registerDate"] :@"registerDate"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"sign"] :@"sign"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"userPhoto"] :@"userPhoto"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"carPhoto"] :@"carPhoto"];
    
    UserModel *userModel = [[UserModel alloc] init];
    userModel.userId = [objDict objectForKey:@"id"];
    userModel.loginName = [objDict objectForKey:@"loginName"];
    userModel.fullName = [objDict objectForKey:@"fullName"];
    userModel.age = [objDict objectForKey:@"age"];
    userModel.area = [objDict objectForKey:@"area"];
    userModel.gender = [[objDict objectForKey:@"gender"] integerValue];
    userModel.mobile = [objDict objectForKey:@"mobile"];
    userModel.registerDate = [objDict objectForKey:@"registerDate"];
    userModel.sign = [objDict objectForKey:@"sign"];
    userModel.userPhoto = [objDict objectForKey:@"userPhoto"];
    userModel.carPhoto = [objDict objectForKey:@"carPhoto"];
    
#ifdef IMPORT_LETUIM_H
    NSString *loginName = objDict[@"loginName"];
    NSString *loginPW = _passwordTextField.text;
    
    LeTuIM *im = [LeTuIM sharedInstance];
    [im setMyName:loginName];
    [im setMyPassword:loginPW];
    
    [NSUserDefaults setObjectInStandardUserDefaults:loginName forKey:MY_CHATUSER_NAME];
    [NSUserDefaults setObjectInStandardUserDefaults:loginPW forKey:MY_CHATUSER_PASSWORD];
    
    LeTuUser *user = [[LeTuIM sharedInstance] findUserWithName:loginName update:NO];
    [user updateInfomationWithDictionary:objDict];
    user.relationship = RELATIONSHIP_MYSELF;
    [LeTuUser updateUserInfomationWithUser:user];
#endif
    
    [AppDelegate sharedAppDelegate].userModel = userModel;
    [AppDelegate sharedAppDelegate].currentLocation = CLLocationCoordinate2DMake(0.0, 0.0);
    
    //    [self.progressHUD hide:YES];
    
    
    self.appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.appDelegate showMainView];
    
    
    
    //    if (self.toSetting) {
    //        [self dismissViewControllerAnimated:YES completion:^{
    //
    //        }];
    //    }else{
    //        [self dismissModalViewControllerAnimated:NO];
    //    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    self.progressHUD.hidden = YES;
    [DejalActivityView removeView];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (request.tag==888)
    {
        //修改了
        [self messageShow:@"网络繁忙，请稍后在试！"];
        if (iOS_7_Above) {
            CGRect frame = self.view.frame;
            frame.size.height = [UIScreen mainScreen].bounds.size.height;
            self.view.frame = frame;
        }
        
    }
}
-(void)messageShow:(NSString *) message
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
/*
 -(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
 {
 if (tag==1) {//登录
 [UserDefaultsHelper setStringForKey:self.accountTextField.text :@"loginName"];
 if ([self.autoLoginButton isSelect]) {
 [UserDefaultsHelper setStringForKey:self.passwordTextField.text :@"passWord"];
 }else{
 [UserDefaultsHelper setStringForKey:@"" :@"passWord"];
 }
 
 NSDictionary *objDict = [data objectForKey:@"obj"];
 [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"key"] :@"key"];
 [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"id"] :@"userId"];
 
 UserModel *userModel = [[UserModel alloc] init];
 userModel.loginName = [objDict objectForKey:@"loginName"];
 userModel.fullName = [objDict objectForKey:@"fullName"];
 userModel.age = [objDict objectForKey:@"age"];
 userModel.area = [objDict objectForKey:@"area"];
 userModel.gender = [objDict objectForKey:@"gender"];
 userModel.mobile = [objDict objectForKey:@"mobile"];
 userModel.registerDate = [objDict objectForKey:@"registerDate"];
 userModel.sign = [objDict objectForKey:@"sign"];
 userModel.userPhoto = [objDict objectForKey:@"userPhoto"];
 userModel.carPhoto = [objDict objectForKey:@"carPhoto"];
 
 [AppDelegate sharedAppDelegate].userModel = userModel;
 
 [self.progressHUD hide:YES];
 if (self.toSetting) {
 [self dismissViewControllerAnimated:YES completion:^{
 
 }];
 }else{
 //            SHOWTABVIEW;
 [self dismissModalViewControllerAnimated:NO];
 }
 }
 }
 -( void )reponseFaild:(NSInteger)tag
 {
 self.progressHUD.hidden = YES;
 }
 //*/


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
