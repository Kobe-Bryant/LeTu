//
//  ForgottenViewController.m
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "ForgottenViewController.h"
#import "DejalActivityView.H"


@interface ForgottenViewController ()
{
    NSOperationQueue *queue;
    NSInteger _countDown;
    UILabel *_countDownLabel;
    UIView *blankView;
    MBProgressHUD *HUD;


}
@property(nonatomic,strong)UITextField *mobileTextField;
@property(nonatomic,strong)UITextField *validationTextField;
@property(nonatomic,strong)UITextField *password1TextField;
@property(nonatomic,strong)UITextField *password2TextField;
@property(nonatomic,strong)UIButton *validationButton;
@property(nonatomic,strong)UIButton *submitButton;

@end

@implementation ForgottenViewController

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
    
    //[self setTitle:@"忘记密码" andShowButton:YES];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 120, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"忘记密码";
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
    
    
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(0.0, 0.0, 80.0, 40.0);
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0);
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 2;
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:sureButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    _countDown = 60;
}
- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
      
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"返回");
 

    }else if(bt.tag ==2){
    
        if ([[self.mobileTextField text] isEqualToString:@""]) {
            [[[[iToast makeText:@"手机号码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else if ([[self.validationTextField text] isEqualToString:@""]){
            [[[[iToast makeText:@"请先获取验证码..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else if ([[self.password1TextField text] isEqualToString:@""]){
            [[[[iToast makeText:@"密码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else if (![[self.password1TextField text] isEqualToString:[self.password2TextField text]]){
            [[[[iToast makeText:@"两次密码不相同..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else{
  
            [self resertPassword];
        }
  
        
        NSLog(@"确认");

    }else if (bt.tag ==3)
    {
        
        NSLog(@"获取验证码");

        if ([[self.mobileTextField text] isEqualToString:@""]) {
            [[[[iToast makeText:@"手机号码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else{
            //[self messageToast:@"发送验证码中"];
            
            [self startLoading];
            [self getCaptcha];
            [self countDown];

        }
         
    } else if (bt.tag ==4)
     {
        NSLog(@"确认");
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

         
         
    
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);

    
    UIImage* userImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(8.0, 10,userImage.size.width, userImage.size.height);
    imageView.image = userImage;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    UIImage* personImage = [UIImage imageNamed:@"loginPhone.png"];
    UIImageView* personImageView = [[UIImageView alloc]initWithImage:personImage];
    personImageView.frame = CGRectMake(15.0, (userImage.size.height - personImage.size.height)/2.0, personImageView.frame.size.width, personImageView.frame.size.height);
    [imageView addSubview:personImageView];
    
    
    
    self.mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personImageView.frame) + 15.0, 1.0, 250, 40)];
    self.mobileTextField.backgroundColor = [UIColor clearColor];
    self.mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mobileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.delegate = self;
    self.mobileTextField.placeholder = @"请输入您的手机号";
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
 
    self.validationTextField.backgroundColor = [UIColor clearColor];
    self.validationTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.validationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.validationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.validationTextField.delegate = self;
    self.validationTextField.text = @"";
    self.validationTextField.placeholder = @"输入验证码";
    [yanzhenImageView addSubview:self.validationTextField];
    
    
    self.validationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.validationButton.frame = CGRectMake(CGRectGetMaxX(yanzhenImageView.frame)+5, yanzhenImageView.frame.origin.y, 95, 40);
    [self.validationButton setImage:[UIImage imageNamed:@"loginBtObtainPre.png"] forState:UIControlStateNormal];
    [self.validationButton setImage:[UIImage imageNamed:@"loginBtObtain.png"] forState:UIControlStateSelected];
    [self.validationButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.validationButton.tag = 3;
    [self.view addSubview:self.validationButton];
    
    
    UIImage* firstImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* passwordView = [[UIImageView alloc]init];
    passwordView.frame = CGRectMake(8.0, CGRectGetMaxY(yanzhenImageView.frame) +16,userImage.size.width, userImage.size.height);
    passwordView.image = firstImage;
    passwordView.userInteractionEnabled = YES;
    [self.view addSubview:passwordView];
    
    
    
    UIImage* lockImage = [UIImage imageNamed:@"loginCipher.png"];
    UIImageView* lockoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0, (yanzhenImageView.frame.size.height - passwordOneImage.size.height)/2.0, passwordOneImage.size.width, passwordOneImage.size.height)];
    lockoneImageView.image = lockImage;
    [passwordView addSubview:lockoneImageView];
 
    
    self.password1TextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lockImageView.frame) + 15.0, 1.0, 250, 40)];
    self.password1TextField.backgroundColor = [UIColor clearColor];
    self.password2TextField.returnKeyType = UIReturnKeyDone;
    self.password1TextField.secureTextEntry = YES;
    self.password1TextField.delegate = self;
    self.password1TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password1TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password1TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password1TextField.text = @"";
    self.password1TextField.placeholder = @"输入密码";
    [passwordView addSubview:self.password1TextField];
    
    UIImage* secondImage = [UIImage imageNamed:@"loginInput.png"];
    UIImageView* passwordViewtwo = [[UIImageView alloc]init];
    passwordViewtwo.frame = CGRectMake(8.0, CGRectGetMaxY(passwordView.frame) +16,userImage.size.width, userImage.size.height);
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
    self.password2TextField.delegate = self;
    self.password2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password2TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password2TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password2TextField.text = @"";
    self.password2TextField.placeholder = @"再次输入密码";
    [passwordViewtwo addSubview:self.password2TextField];

    
    UIImage* submitImage = [UIImage imageNamed:@"loginBtConfirmation"];
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(8.0, CGRectGetMaxY(passwordViewtwo.frame)+21, submitImage.size.width, submitImage.size.height);
    [self.submitButton setImage:submitImage forState:UIControlStateNormal];
//    [self.submitButton setImage:[UIImage imageNamed:@"location_submit_press"] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.tag = 4;
    [self.view addSubview:self.submitButton];
    
    return;
    [self initView];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.mobileTextField resignFirstResponder];
    [self.validationTextField resignFirstResponder];
    [self.password1TextField resignFirstResponder];
    [self.password2TextField resignFirstResponder];
    return YES;
    
}
- (void)tapclick:(UITapGestureRecognizer*)tap
{
    [self.mobileTextField resignFirstResponder];
    [self.validationTextField resignFirstResponder];
    [self.password1TextField resignFirstResponder];
    [self.password2TextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化界面
 */
- (void)initView
{
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41, 320, 263.5)];
    bgView.image = [UIImage imageNamed:@"password_register"];
    [self.view addSubview:bgView];
    
    self.validationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.validationButton.frame = CGRectMake(12, 115, 95, 40);
    [self.validationButton setImage:[UIImage imageNamed:@"get_code"] forState:UIControlStateNormal];
    [self.validationButton setImage:[UIImage imageNamed:@"get_code"] forState:UIControlStateHighlighted];
    [self.validationButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.validationButton.tag = 1;
    [self.view addSubview:self.validationButton];
    
    self.mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 58, 240, 40)];
//    self.mobileTextField.backgroundColor = [UIColor colorWithRed:250/255.0 green:227/255.0 blue:82/255.0 alpha:0.5];
    self.mobileTextField.backgroundColor = [UIColor clearColor];
    self.mobileTextField.returnKeyType = UIReturnKeyDone;
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mobileTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mobileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mobileTextField.text = @"";
    [self.view addSubview:self.mobileTextField];
    
    self.validationTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 115, 185, 40)];
//    self.validationTextField.backgroundColor = [UIColor colorWithRed:250/255.0 green:227/255.0 blue:82/255.0 alpha:0.5];
    self.validationTextField.backgroundColor = [UIColor clearColor];
//    [self.validationTextField setEnabled:NO];
    self.validationTextField.returnKeyType = UIReturnKeyDone;
    self.validationTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.validationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.validationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.validationTextField.text = @"";
//    self.validationTextField.text = @"123456";
//    self.validationTextField.textColor = [UIColor grayColor];
    [self.view addSubview:self.validationTextField];
    
    self.password1TextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 172, 220, 40)];
    //    self.password1TextField.backgroundColor = [UIColor colorWithRed:250/255.0 green:227/255.0 blue:82/255.0 alpha:0.5];
    self.password1TextField.backgroundColor = [UIColor clearColor];
    self.password2TextField.returnKeyType = UIReturnKeyDone;
    self.password1TextField.secureTextEntry = YES;
    self.password1TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password1TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password1TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password1TextField.text = @"";
    [self.view addSubview:self.password1TextField];
    
    self.password2TextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 228, 220, 40)];
    //    self.password2TextField.backgroundColor = [UIColor colorWithRed:250/255.0 green:227/255.0 blue:82/255.0 alpha:0.5];
    self.password2TextField.backgroundColor = [UIColor clearColor];
    self.password2TextField.returnKeyType = UIReturnKeyDone;
    self.password2TextField.secureTextEntry = YES;
    self.password2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password2TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password2TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password2TextField.text = @"";
    [self.view addSubview:self.password2TextField];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(12, 300, 296, 36);
    [self.submitButton setImage:[UIImage imageNamed:@"location_submit_normal"] forState:UIControlStateNormal];
    [self.submitButton setImage:[UIImage imageNamed:@"location_submit_press"] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.tag = 2;
    [self.view addSubview:self.submitButton];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mobileTextField resignFirstResponder];
    [self.password1TextField resignFirstResponder];
    [self.password2TextField resignFirstResponder];
}
- (void)countDown {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] initWithFrame:self.validationButton.bounds];
        [self.validationButton addSubview:_countDownLabel];
        _countDownLabel.backgroundColor = [UIColor colorWithWhite:236/255.f alpha:1];
        _countDownLabel.font = [UIFont systemFontOfSize:15.f];
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
        _countDownLabel.textColor = [UIColor grayColor];
    }
    
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
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
     if (button.tag==1) {//获取验证码按钮
         
        if ([[self.mobileTextField text] isEqualToString:@""]) {
            [[[[iToast makeText:@"手机号码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        }else{
            
             [self startLoading];
             [self getCaptcha];
             [self countDown];

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
    }
}
/**
 *  获取验证码
 */
-(void)startLoading
{
  
    if (!blankView) {
        blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
        blankView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:blankView];
    }
    [DejalActivityView activityViewForView:blankView];
    
}
- (void)getCaptcha
{
 
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?sendCaptcha&mobile=%@", SERVERAPIURL,[self.mobileTextField text]];
   if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
/**
 *  重置密码
 */
- (void)resertPassword
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    [self textFieldResignFirstResponder];
    [self startLoading];
    self.submitButton.enabled = NO;
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?resetPassword", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.mobileTextField.text forKey:@"mobile"];
    [paramDict setObject:self.validationTextField.text forKey:@"captcha"];
    [paramDict setObject:self.password1TextField.text forKey:@"newPassword"];
    [paramDict setObject:self.password2TextField.text forKey:@"confirmPassword"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
//修改的代码。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
-(void)stopLoading{
  
 
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
        
        NSLog(@"%@",data);
        
        
        
       [self stopLoading];
       [self messageToast:@"验证码已发送手机,请输入验证码!"];
       
    

        //self.submitButton.enabled = YES;
    }else if(tag==2){
       [self stopLoading];
        self.submitButton.enabled = YES;
        [[[[iToast makeText:@"修改密码成功！"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        [self.navigationController popViewControllerAnimated:YES];
//        [self dismissModalViewControllerAnimated:YES];
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
    [self stopLoading];
    self.submitButton.enabled = YES;
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


-(void)textFieldResignFirstResponder
{
    [self.mobileTextField resignFirstResponder];
    [self.validationTextField resignFirstResponder];
    [self.password1TextField resignFirstResponder];
    [self.password2TextField resignFirstResponder];
}
@end
