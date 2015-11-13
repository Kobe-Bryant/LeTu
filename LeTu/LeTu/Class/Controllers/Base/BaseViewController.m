//
//  BaseViewController.m
//  CBD
//
//  Created by Roland on 12-7-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "DejalActivityView.h"


@implementation BaseViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
*/

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //*
    CGRect frame = self.view.frame;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        frame.origin.y = 20;
        frame.size.height = self.view.frame.size.height - 20;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    else
    {
        frame.origin.x = 0;
    }
    self.view.frame = frame;
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"letu_bg"]];
     //*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)messageShow:(NSString *) message
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)startLoading
{
    /*
    if (HUD == nil ) 
    {
    // HUD.layer.hidden = NO;
    //CBDAppDelegate *appDelegate=(CBDAppDelegate *)[[UIApplication sharedApplication] delegate];
        
    UIViewController *rootViewController = self.navigationController;
        if (rootViewController == nil) {
            rootViewController = self.tabBarController;
        }
    HUD = [[MBProgressHUD alloc] initWithView:rootViewController.view];
        [self.navigationController.view addSubview:HUD];
        [self.navigationController.view bringSubviewToFront:HUD];
       // bringSubviewToFront
   // [self.navigationController.view addSubview:HUD];
       // HUD = [[MBProgressHUD alloc] initWithView:appDelegate.window];
      //  [appDelegate.window addSubview:HUD];

    HUD.delegate = self;
    [HUD show:YES];
     HUD.layer.hidden = NO;
        
  } 
    else {
        HUD.layer.hidden = NO;
    }
     //*/
    
    /*
    if (HUD ==nil) {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.removeFromSuperViewOnHide = YES;
    }else{
        HUD.hidden = NO;
        HUD.removeFromSuperViewOnHide = YES;
    }
    //*/
    if (!blankView) {
        blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
        blankView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:blankView];
    }
    [DejalActivityView activityViewForView:blankView];

}

-(void)stopLoading{
    /*
     if (HUD != nil ) {
         [HUD hide:YES];
     }
    for(UIView *subview in [self.navigationController.view subviews])
    {
    if ([subview isKindOfClass:[MBProgressHUD class]]) {
        subview.layer.hidden = YES;
    }
    }
     //*/
    
    if (HUD !=nil) {
        HUD.hidden = YES;
    }
    [blankView removeFromSuperview];
    blankView = nil;
    [DejalActivityView removeView];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud 
{
    // Remove HUD from screen when the HUD was hidded
    HUD.layer.hidden = YES;
   // [HUD removeFromSuperview];
   // [HUD release];
	//HUD = nil;
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
    
}
/**
-(void)showRemindMessage:(int)messageType
{
    if (messageView != nil) {
        [messageView removeFromSuperview];
        messageView = nil;
    }
    messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    UIImage *bgImage = [UIImage imageNamed:@"CBD_upgrade_bg"];
   UIImageView	*bgView = [[UIImageView alloc] initWithImage:bgImage];
	CGRect rect = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
	bgView.layer.frame = rect;
	[messageView addSubview:bgView];
    if (messageType == 4) {
           
        UIImage *mesImage = [UIImage imageNamed:sysMessageModel.stationpic];
        CGRect rect = CGRectMake(26, 0, mesImage.size.width, mesImage.size.height); 
        UIImageView	*mesView = [[UIImageView alloc] initWithImage:mesImage];
        
        mesView.layer.frame = rect;
        [messageView addSubview:mesView];
 
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(235, 310, 150, 30)];
        label.text = [NSString stringWithFormat:@"%@",sysMessageModel.points];
        label.textColor = [Utility colorWithHexString:@"222222"];
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.numberOfLines = 1;
        [label setBackgroundColor:[UIColor clearColor]];
        [messageView addSubview:label];

     sysMessageModel.stationpic=@"";

    }
   else if (messageType == 5) {
        UIImage *mesImage = [UIImage imageNamed:sysMessageModel.levelpic];
        UIImageView	*mesView = [[UIImageView alloc] initWithImage:mesImage];
        CGRect rect = CGRectMake(26, 0, mesImage.size.width, mesImage.size.height);
        mesView.layer.frame = rect;
        [messageView addSubview:mesView];
       
       UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(230, 312, 150, 30)];
       label.text = [NSString stringWithFormat:@"%@",sysMessageModel.points];
       label.textColor = [Utility colorWithHexString:@"ffffff"];
       label.adjustsFontSizeToFitWidth = YES;
       label.font = [UIFont boldSystemFontOfSize:12];
       label.numberOfLines = 1;
       [label setBackgroundColor:[UIColor clearColor]];
       [messageView addSubview:label];
       sysMessageModel.levelpic=@"";

       
    }
   else if (messageType == 6) {
       UIImage *mesImage = [UIImage imageNamed:sysMessageModel.gradepic];
       UIImageView	*mesView = [[UIImageView alloc] initWithImage:mesImage];
       CGRect rect = CGRectMake(26, 0, mesImage.size.width, mesImage.size.height);
       mesView.layer.frame = rect;
       [messageView addSubview:mesView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(216, 290, 150, 30)];
      
       label.text = [NSString stringWithFormat:@"%@",sysMessageModel.points];
       label.textColor = [Utility colorWithHexString:@"ffffff"];
       label.adjustsFontSizeToFitWidth = YES;
       label.font = [UIFont boldSystemFontOfSize:12];
       label.numberOfLines = 1;
       [label setBackgroundColor:[UIColor clearColor]];
       [messageView addSubview:label];
       sysMessageModel.gradepic=@"";
       
   }
    
   else if (messageType == 7) {
       UIImage *mesImage = [UIImage imageNamed:sysMessageModel.graduatepic];
       UIImageView	*mesView = [[UIImageView alloc] initWithImage:mesImage];
       CGRect rect = CGRectMake(26, 0, mesImage.size.width, mesImage.size.height);
       mesView.layer.frame = rect;
       [messageView addSubview:mesView];
       
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(235, 310, 150, 30)];
       
       label.text = [NSString stringWithFormat:@"%@",sysMessageModel.points];
       label.textColor = [Utility colorWithHexString:@"222222"];
       label.adjustsFontSizeToFitWidth = YES;
       label.font = [UIFont boldSystemFontOfSize:12];
       label.numberOfLines = 1;
       [label setBackgroundColor:[UIColor clearColor]];
       [messageView addSubview:label];
       
       label = [[UILabel alloc] initWithFrame:CGRectMake(140, 170, 50, 30)];
       
       label.text = [NSString stringWithFormat:@"%@",sysMessageModel.username];
       label.textColor = [Utility colorWithHexString:@"0e318f"];
       label.adjustsFontSizeToFitWidth = YES;
       label.font = [UIFont boldSystemFontOfSize:12];
       label.numberOfLines = 1;
       [label setBackgroundColor:[UIColor clearColor]];
       [messageView addSubview:label];
       
        sysMessageModel.graduatepic=@"";
       
   }

    
    UIImage *image = [UIImage imageNamed:@"CBD_upgrade_ok1"];
	UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom] ;
    UIImage *act = [UIImage imageNamed:@"CBD_upgrade_ok2"];
    [but setImage:act forState:UIControlStateHighlighted];
    [but setFrame:CGRectMake(123, 351, image.size.width, image.size.height)];
    [but setImage:image forState:UIControlStateNormal];
    [but addTarget:self action:@selector(removeMessageView:)forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:but];
    
    [self.view addSubview:messageView];
    
}

- (void) removeMessageView: (UIControl *) c
{
    if (messageView != nil) {
        [messageView removeFromSuperview];
        messageView = nil;
    }
    if (sysMessageModel != nil) {
    if (sysMessageModel.stationpic != nil && ![sysMessageModel.stationpic isEqualToString:@""]) {
        [self showRemindMessage:4];
    }
    else if (sysMessageModel.levelpic != nil && ![sysMessageModel.levelpic isEqualToString:@""]) {
        [self showRemindMessage:5];
    }
    else if (sysMessageModel.gradepic != nil && ![sysMessageModel.gradepic isEqualToString:@""]) {
        [self showRemindMessage:6];
    }
    else if (sysMessageModel.graduatepic != nil && ![sysMessageModel.graduatepic isEqualToString:@""]) {
        [self showRemindMessage:7];
    }
    }

    
    
}
**/
-( void )reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    CGRect frame = self.view.frame;
    if (iOS_7_Above) {
        frame.origin.y = 20;
        frame.size.height = self.view.frame.size.height - 20;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        frame.origin.x = 0;
    }
    self.view.frame = frame;
    //*/
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"letu_bg"]];
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    if (iOS_7_Above) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    self.appDelegate = [AppDelegate sharedAppDelegate];
    

//    [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector: @selector(stopLoading)
//                                   userInfo:nil repeats:YES];
    
    
}
/**
-(void)viewWillAppear:(BOOL)animated
{
    if (HUD != nil ) {
        [HUD hide:YES];
    }
    
}
 **/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (iOS_7_Above) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setTitleImage:(UIImage *)titleImage andShowButton:(BOOL)show
{
//    UIImage *topBar = [UIImage imageNamed:@"top_bar"];
//    
//    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame:
//                                    CGRectMake(0, 0, topBar.size.width, topBar.size.height)];
//    
//    NSLog(@"topBar.size.width = %f, topBar.size.height = %f", topBar.size.width, topBar.size.height);
//    topBarImageView.image = topBar;
//    [self.view addSubview:topBarImageView];
//    
//    CGFloat x = 160 - titleImage.size.width / 2;
//    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, titleImage.size.width, titleImage.size.height)];
//    titleImageView.image = titleImage;
//    [topBarImageView addSubview:titleImageView];
//    /*
//    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 12, 170, 20)];
//    topLabel.backgroundColor = [UIColor clearColor];
//    topLabel.text = title;
//    topLabel.textColor = [UIColor whiteColor];
//
//    topLabel.font = [UIFont boldSystemFontOfSize:20];
//    topLabel.textAlignment = UITextAlignmentCenter;
//    //    topLabel.adjustsFontSizeToFitWidth = true;
//    [self.view addSubview:topLabel];
//     */
//    
//    if (show == YES) {
//        UIImage *normal = [UIImage imageNamed:@"back_btn"];
//        UIImage *highlighted = [UIImage imageNamed:@"back_btn_act"];
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = CGRectMake(10, 8, normal.size.width, normal.size.height);
//        [backBtn setBackgroundImage:normal forState:UIControlStateNormal];
//        [backBtn setBackgroundImage:highlighted forState:UIControlStateHighlighted];
//        [backBtn addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:backBtn];
//    }
}

- (void)setTitle:(NSString *)title andShowButton:(BOOL)show
{
    
    
    UIImage *topBar = [UIImage imageNamed:@"letu_navbtn_bg"];
    
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(0, 0, topBar.size.width, topBar.size.height)];
    topBarImageView.image = topBar;
    [self.view addSubview:topBarImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    //    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    titleLabel.center = topBarImageView.center ;
    [topBarImageView addSubview:titleLabel];
    
    if (show)
    {
        UIImage *normal = [UIImage imageNamed:@"common_topbar_back_btn_normal"];
        UIImage *highlighted = [UIImage imageNamed:@"common_topbar_back_btn_press"];
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 44, 44);
        [backBtn setImage:normal forState:UIControlStateNormal];
        [backBtn setImage:highlighted forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        /*
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(paningGestureReceive:)];
        [recognizer delaysTouchesBegan];
        [self.view addGestureRecognizer:recognizer];
         //*/
        
    }

}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication]keyWindow]];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        startTouch = touchPoint;
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        if (touchPoint.x - startTouch.x > 50){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void) backPressed:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  导航栏右边按钮 -- 图片类型
 *
 *  @param normalImage      普通图片
 *  @param highlightedImage 高亮图片
 */
- (void)initRightBarButtonItem:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage
{
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-normalImage.size.width-10, 0, normalImage.size.width, 44)];
    [backButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:normalImage forState:UIControlStateNormal];
    [backButton setImage:highlightedImage forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
}
/**
 *  导航栏右边按钮 -- 文字类型
 *
 *  @param text 按钮内容
 */
- (void)initRightBarButtonItem:(NSString*)text
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 7, 40, 30)];
    [backButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:text forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
   // [backButton setTitleColor:RGBCOLOR(155, 155, 155) forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBCOLOR(51, 160, 246) forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
}
- (void)clickRightButton:(UIButton *)button
{
    
}
- (void)messageToast:(NSString*)msg
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}
@end
