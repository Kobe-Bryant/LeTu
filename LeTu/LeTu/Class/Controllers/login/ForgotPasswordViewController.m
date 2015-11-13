//
//  ForgotPasswordViewController.m
//  AHAOrdering
//
//  Created by DT on 14-5-16.
//
//

#import "ForgotPasswordViewController.h"
#import "DTButton.h"
#import "DetailedSettingViewController.h"
#import "RegistTwoViewController.h"
#import "DejalActivityView.h"
#import "MBProgressHUD.h"


#ifdef IMPORT_LETUIM_H
#import "LeTuUserAgreementViewController.h"
#endif


@interface ForgotPasswordViewController ()
{
    NSOperationQueue *queue;
    UIView* blankView;
    MBProgressHUD* HUD;
//#ifdef IMPORT_LETUIM_H
    NSInteger _countDown;
    UILabel *_countDownLabel;
//#endif
}
@property(nonatomic,strong)UITextField *mobileTextField;
@property(nonatomic,strong)UITextField *validationTextField;
@property(nonatomic,strong)UITextField *password1TextField;
@property(nonatomic,strong)UITextField *password2TextField;
@property(nonatomic,strong)UIButton *validationButton;
@property(nonatomic,strong)UIButton *submitButton;
@property(nonatomic,strong)DTButton *autoLoginButton;
@property(nonatomic,strong) UIButton* registButton;
@property(nonatomic,strong) UIButton* delegateButton;



@end

@implementation ForgotPasswordViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.hidesBackButton = YES;
        
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    //[self setTitle:@"注册" andShowButton:YES];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 120, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"注册1/3";
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
    sureButton.tag = 2;
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:sureButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
//#ifdef IMPORT_LETUIM_H
    _countDown = 60;
//#endif
}
- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
     
        [self.navigationController popViewControllerAnimated:YES];

    }else {
    
        
//        RegistTwoViewController* registVC = [[RegistTwoViewController alloc]init];
//        [self.navigationController pushViewController:registVC animated:YES];
//        return;
        
        
        //验证验证码的接口
        [self authorCaptcha];
      

    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage* userImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(8.0,10,userImage.size.width, userImage.size.height);
    imageView.image = userImage;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    UIImage* personImage = [UIImage imageNamed:@"loginPhone.png"];
    UIImageView* personImageView = [[UIImageView alloc]initWithImage:personImage];
    personImageView.frame = CGRectMake(15.0, (userImage.size.height - personImage.size.height)/2.0, personImageView.frame.size.width, personImageView.frame.size.height);
    [imageView addSubview:personImageView];
    
    
    
    self.mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personImageView.frame) + 15.0, 1.0, 250, 40)];
    self.mobileTextField.backgroundColor = [UIColor clearColor];
    self.mobileTextField.delegate = self;
    self.mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mobileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.placeholder = @"请输入您的手机号码";
    [imageView addSubview:self.mobileTextField];
    
    
    
    UIImage* yanzhenImage = [UIImage imageNamed:@"loginInput196x41.png"];
    UIImageView* yanzhenImageView = [[UIImageView alloc]init];
    yanzhenImageView.frame = CGRectMake(8.0, CGRectGetMaxY(imageView.frame) +16,yanzhenImage.size.width, yanzhenImage.size.height);
    yanzhenImageView.image = yanzhenImage;
    yanzhenImageView.userInteractionEnabled = YES;
    [self.view addSubview:yanzhenImageView];
    
    
    
    UIImage* passwordOneImage = [UIImage imageNamed:@"loginVerificationcode.png"];
    UIImageView* lockImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0, (yanzhenImageView.frame.size.height - passwordOneImage.size.height)/2.0, passwordOneImage.size.width, passwordOneImage.size.height)];
    lockImageView.image = passwordOneImage;
    [yanzhenImageView addSubview:lockImageView];
    
    
    self.validationTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lockImageView.frame) + 15.0, 1.0, 250, 40)];
    self.validationTextField.delegate = self;
    self.validationTextField.backgroundColor = [UIColor clearColor];
    self.validationTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.validationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.validationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.validationTextField.text = @"";
    self.validationTextField.placeholder = @"输入验证码";
    [yanzhenImageView addSubview:self.validationTextField];
 
    
    self.validationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.validationButton.frame = CGRectMake(CGRectGetMaxX(yanzhenImageView.frame)+13, yanzhenImageView.frame.origin.y, 95, 40);
    [self.validationButton setImage:[UIImage imageNamed:@"loginBtObtainPre.png"] forState:UIControlStateNormal];
    [self.validationButton setImage:[UIImage imageNamed:@"loginBtObtain.png"] forState:UIControlStateHighlighted];
    [self.validationButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.validationButton.tag = 1;
    [self.view addSubview:self.validationButton];
    
    
    self.autoLoginButton = [DTButton buttonWithType:UIButtonTypeCustom];
    self.autoLoginButton.backgroundColor = [UIColor clearColor];
    self.autoLoginButton.normalImage = [UIImage imageNamed:@"loginCheck.png"];
    self.autoLoginButton.pressImage = [UIImage imageNamed:@"loginCheckPre.png"];
    self.autoLoginButton.frame = CGRectMake(8.0, CGRectGetMaxY(yanzhenImageView.frame) +15.0, 120, 22);
    self.autoLoginButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.autoLoginButton.isSelect = YES;
    //    [self.autoLoginButton setTitle:@"自动登录" forState:UIControlStateNormal];
    [self.autoLoginButton setTitle:@"已阅读并同意" forState:UIControlStateNormal];
    self.autoLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -20, 0, 0);
    self.autoLoginButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [self.autoLoginButton setTitleColor:RGBCOLOR(135, 135, 135) forState:UIControlStateNormal];
    self.autoLoginButton.tag = 10;
    [self.autoLoginButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.autoLoginButton];
    
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(30.0, self.autoLoginButton.frame.origin.y-4, 180, 30.0);
    [sureButton setTitle:@"用户协议" forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    [sureButton setTitleColor:RGBCOLOR(25, 177, 162) forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0);
    [sureButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 12;
    [self.view addSubview:sureButton];
    
    //注册按钮1
    UIImage* loginImage = [UIImage imageNamed:@"loginBtRegistern.png"];
    self.registButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, CGRectGetMaxY(self.autoLoginButton.frame) +21.0, loginImage.size.width, loginImage.size.height)];
    [self.registButton setImage:loginImage forState:UIControlStateNormal];
    //    [self.loginButton setImage:[UIImage imageNamed:@"login_btn_current"] forState:UIControlStateHighlighted];
    [self.registButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.registButton.tag = 11.0;
    [self.view addSubview:self.registButton];
    
    
    
    
    return;

    [self initView];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.mobileTextField resignFirstResponder];
    [self.validationTextField resignFirstResponder];
   
    return YES;
    
}
- (void)tapclick:(UITapGestureRecognizer*)tap
{
    [self.mobileTextField resignFirstResponder];
    [self.validationTextField resignFirstResponder];

}
/**
 *  初始化界面
 */
- (void)initView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41, 320, 263.5)];
    bgView.image = [UIImage imageNamed:@"register"];
    [self.view addSubview:bgView];
    
    self.validationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.validationButton.frame = CGRectMake(12, 113, 95, 40);
    [self.validationButton setImage:[UIImage imageNamed:@"get_code"] forState:UIControlStateNormal];
    [self.validationButton setImage:[UIImage imageNamed:@"get_code"] forState:UIControlStateHighlighted];
    [self.validationButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.validationButton.tag = 1;
    [self.view addSubview:self.validationButton];
    
    self.mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 57, 240, 40)];
//    self.mobileTextField.backgroundColor = [UIColor colorWithRed:250/255.0 green:227/255.0 blue:82/255.0 alpha:0.5];
    self.mobileTextField.backgroundColor = [UIColor clearColor];
    self.mobileTextField.returnKeyType = UIReturnKeyDone;
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mobileTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mobileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mobileTextField.text = @"";
    [self.view addSubview:self.mobileTextField];
    
    self.validationTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 113, 185, 40)];
//    self.validationTextField.backgroundColor = [UIColor colorWithRed:250/255.0 green:227/255.0 blue:82/255.0 alpha:0.5];
    self.validationTextField.backgroundColor = [UIColor clearColor];
    self.validationTextField.keyboardType = UIKeyboardTypeNumberPad;
//    [self.validationTextField setEnabled:NO];
    self.validationTextField.returnKeyType = UIReturnKeyDone;
    self.validationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.validationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.validationTextField.text = @"";
    self.validationTextField.text = @"";
//    self.validationTextField.textColor = [UIColor grayColor];
    [self.view addSubview:self.validationTextField];
    
    self.password1TextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 170, 220, 40)];
//    self.password1TextField.backgroundColor = [UIColor colorWithRed:250/255.0 green:227/255.0 blue:82/255.0 alpha:0.5];
    self.password1TextField.backgroundColor = [UIColor clearColor];
    self.password2TextField.returnKeyType = UIReturnKeyDone;
    self.password1TextField.secureTextEntry = YES;
    self.password1TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password1TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password1TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password1TextField.text = @"";
//    self.password1TextField.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.password1TextField];
    
    self.password2TextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 226, 220, 40)];
//    self.password2TextField.backgroundColor = [UIColor colorWithRed:250/255.0 green:227/255.0 blue:82/255.0 alpha:0.5];
    self.password2TextField.backgroundColor = [UIColor clearColor];
    self.password2TextField.returnKeyType = UIReturnKeyDone;
    self.password2TextField.secureTextEntry = YES;
    self.password2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password2TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password2TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password2TextField.text = @"";
//    self.password2TextField.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.password2TextField];
    
    self.autoLoginButton = [DTButton buttonWithType:UIButtonTypeCustom];
    self.autoLoginButton.backgroundColor = [UIColor clearColor];
    self.autoLoginButton.frame = CGRectMake(12, 274, 17, 17);
    self.autoLoginButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.autoLoginButton.normalImage = [UIImage imageNamed:@"login_tongyi"];
    self.autoLoginButton.pressImage = [UIImage imageNamed:@"login_tongyi_current"];
    self.autoLoginButton.isSelect = YES;
//    self.autoLoginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.autoLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.autoLoginButton.tag = 10;
    [self.autoLoginButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.autoLoginButton];

    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(12, 300, 296, 36);
    [self.submitButton setImage:[UIImage imageNamed:@"register_btn_getpin_normal"] forState:UIControlStateNormal];
    [self.submitButton setImage:[UIImage imageNamed:@"register_btn_getpin_current"] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.tag = 2;
    [self.view addSubview:self.submitButton];
#ifdef IMPORT_LETUIM_H
    UIButton *userAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:userAgreementButton];
    userAgreementButton.frame = CGRectMake(100, 274, 75, 20);
    [userAgreementButton addTarget:self action:@selector(pushUserAgreementViewController) forControlEvents:UIControlEventTouchUpInside];
#endif
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mobileTextField resignFirstResponder];
    [self.password1TextField resignFirstResponder];
    [self.password2TextField resignFirstResponder];
}
/**
 *  按钮事件
 *
 *  @param button
 */
//#ifdef IMPORT_LETUIM_H
// 添加用户协议
/*
- (void)pushUserAgreementViewController {
    [self.navigationController pushViewController:[[LeTuUserAgreementViewController alloc] init] animated:YES];
}
*/
- (void)countDown {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] initWithFrame:self.validationButton.bounds];
        [self.validationButton addSubview:_countDownLabel];
        _countDownLabel.backgroundColor = [UIColor colorWithWhite:236/255.f alpha:1];
        _countDownLabel.font = [UIFont systemFontOfSize:15.f];
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
        _countDownLabel.textColor = [UIColor grayColor];
    }
    
    NSLog(@"_countDown = %d",_countDown);
    
    if (_countDown) {
        _countDownLabel.text = [NSString stringWithFormat:@"重新获取 %2d", _countDown];
        _countDown -=1;
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
    } else {
        [_countDownLabel removeFromSuperview];
        _countDownLabel = nil;
        _countDown = 60;
        self.validationButton.enabled = YES;
    }
}
//#endif
- (void)startLoading
{

    if (!blankView) {
        blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
        blankView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:blankView];
    }
    [DejalActivityView activityViewForView:blankView];

}
- (void)clickButton:(UIButton*)button
{
    if (button.tag==1) {//获取验证码按钮
        if ([[self.mobileTextField text] isEqualToString:@""]) {
            [[[[iToast makeText:@"手机号码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else{
//            int one = arc4random() % 10;
//            int two = arc4random() % 10;
//            int three = arc4random() % 10;
//            int four = arc4random() % 10;
//            self.validationTextField.text = [NSString stringWithFormat:@"%i%i%i%i",one,two,three,four];
            if ([self checkTel:[self.mobileTextField text]]) {
                
                
                [self startLoading];
                [self getCaptcha];
//#ifdef IMPORT_LETUIM_H
                [self countDown];
                self.validationButton.enabled = NO;
//#endif
            }
//            self.validationTextField.text = @"4836";
        }
    }else if (button.tag==2){//提交按钮
        if ([[self.mobileTextField text] isEqualToString:@""]) {
            [[[[iToast makeText:@"手机号码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else if ([[self.validationTextField text] isEqualToString:@""]){
            [[[[iToast makeText:@"请先获取验证码..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else if ([[self.password1TextField text] isEqualToString:@""]){
            [[[[iToast makeText:@"密码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else if (![[self.password1TextField text] isEqualToString:[self.password2TextField text]]){
            [[[[iToast makeText:@"两次密码不相同..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else{
//            [[[[iToast makeText:@"修改密码成功..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
//            [self.navigationController popViewControllerAnimated:YES];
            [self resertPassword];
        }
    }else if (button.tag==10){
        self.autoLoginButton.isSelect = ![self.autoLoginButton isSelect];
        if ([self.autoLoginButton isSelect]) {
            self.submitButton.enabled = YES;
        }else{
            self.submitButton.enabled = NO;
        }
        
    } else if (button.tag ==11)//注册按钮响应方法
    {
        RegistTwoViewController* registVC = [[RegistTwoViewController alloc]init];
        [self.navigationController pushViewController:registVC animated:YES];
    } else if (button.tag ==12)
    {
        
       // [self pushUserAgreementViewController];
        
     
        
    }
}
/**
 *  获取验证码
 */

- (void)authorCaptcha
{
    
    [self startLoading];

      NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?checkCaptcha&mobile=%@&captcha=", SERVERAPIURL,[self.mobileTextField text]];
    NSString* string = self.validationTextField.text;
    NSString* lastUrl = [requestUrl stringByAppendingString:string];
    if (queue==nil) {
        
        queue = [[NSOperationQueue alloc]init];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:lastUrl delegate:self];
    operation.RequestTag = 5;
    [queue addOperation :operation];
}

- (void)getCaptcha
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?sendCaptchaByRegister&mobile=%@", SERVERAPIURL,[self.mobileTextField text]];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
/**
 *  注册
 */
- (void)resertPassword
{
   
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    [self textFieldResignFirstResponder];
    
    
    
     //修改了。。
    [self startLoading];
    self.submitButton.enabled = NO;
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?register", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.mobileTextField.text forKey:@"fullName"];
    [paramDict setObject:@"1" forKey:@"gender"];
    [paramDict setObject:self.mobileTextField.text forKey:@"mobile"];
    [paramDict setObject:self.password1TextField.text forKey:@"password"];
    [paramDict setObject:self.validationTextField.text forKey:@"captcha"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
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
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    if (tag==1) {
        
        
    //
        [self stopLoading];
    //
        [self messageToast:@"验证码已发送手机,请输入验证码!"];
    
    
        
        
        
        
//        NSString *validation = [data objectForKey:@"obj"];
//        self.validationTextField.text = validation;
//        [[[[iToast makeText:@"发送成功！"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    }else if(tag==5){
        
        
        NSLog(@"dic = %@",data);
        
        
     //修改了。。
        [self stopLoading];
        
        
        RegistTwoViewController* registVC = [[RegistTwoViewController alloc]initWithMobileTextfield:self.mobileTextField.text captcha:self.validationTextField.text];
        [self.navigationController pushViewController:registVC animated:YES];
        
        
        return;
        
        self.submitButton.enabled = YES;
        
        [UserDefaultsHelper setStringForKey:self.mobileTextField.text :@"loginName"];
        [UserDefaultsHelper setStringForKey:self.password1TextField.text :@"passWord"];
        [self requestLogin:self.mobileTextField.text password:self.password1TextField.text];
        
        [[[[iToast makeText:@"注册成功！"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        DetailedSettingViewController *dsVC = [[DetailedSettingViewController alloc] initWithAccount:self.mobileTextField.text password:self.password1TextField.text];
        [self.navigationController pushViewController:dsVC animated:YES];
        
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


- (void)messageToast:(NSString*)msg
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
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
    
    
    
    self.submitButton.enabled = YES;
}
-(void)textFieldResignFirstResponder
{
    [self.mobileTextField resignFirstResponder];
    [self.validationTextField resignFirstResponder];
    [self.password1TextField resignFirstResponder];
    [self.password2TextField resignFirstResponder];
}
/**
 *  验证手机号码
 *
 *  @param str 手机号码
 *
 *  @return
 */
- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data_null_prompt", nil) message:NSLocalizedString(@"tel_no_null", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
        
    }
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-1,5-9]))\\d{8}$"; // 支持 181
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        
       //修改了。。
        [self messageToast:@"请输入正确的手机号码"];
        
        
        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        return NO;
        
    }
    return YES;
    
}

/**
 *  用户登录
 */
- (void)requestLogin:(NSString*)account password:(NSString*)password
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?login", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:account forKey:@"login_name"];
    [request setPostValue:password forKey:@"password"];
    
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
    
    JSONDecoder *decoder=[JSONDecoder decoder];
    NSDictionary *dict=[decoder objectWithData:request.responseData];
    NSDictionary *error = [dict objectForKey:@"error"];
    if ([[error objectForKey:@"err_code"] intValue] == 2) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[error objectForKey:@"err_msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary *objDict = [dict objectForKey:@"obj"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"key"] :@"key"];
    [UserDefaultsHelper setStringForKey:[objDict objectForKey:@"id"] :@"userId"];
    
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
    userModel.gender = [objDict objectForKey:@"gender"];
    userModel.mobile = [objDict objectForKey:@"mobile"];
    userModel.registerDate = [objDict objectForKey:@"registerDate"];
    userModel.sign = [objDict objectForKey:@"sign"];
    userModel.userPhoto = [objDict objectForKey:@"userPhoto"];
    userModel.carPhoto = [objDict objectForKey:@"carPhoto"];
    
    [AppDelegate sharedAppDelegate].userModel = userModel;
    [AppDelegate sharedAppDelegate].currentLocation = CLLocationCoordinate2DMake(0.0, 0.0);
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    

}
@end
