//
//  CBDAppDelegate.m
//  CBD
//
//  Created by Roland on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "ScrollViewController.h"
#import "BackgroundRunner.h"
#import "FoundViewController.h"
#import "MessageBoxViewController.h"
#import "MapHomeViewController.h"
#import "MyselfHomeViewController.h"
#import "MainViewController.h"

@implementation AppDelegate


@synthesize window;

@synthesize tabBarController;

@synthesize sessionKey;

@synthesize isNewUser;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //*
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:MAPAK generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //*/
    
    /*
     if (! locationUtil){
     locationUtil = [[LocationUtil alloc] init];
     locationUtil.delegate = self;
     }
     [locationUtil startUpdatingLocation];
     //*/
    
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    //
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
    //    {
    //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //        self.window =  [ [ UIWindow alloc ] initWithFrame: CGRectMake(0, 20, screenBounds.size.width, screenBounds.size.height - 20) ];
    //    }
    //    else
    //    {
    self.window =  [ [ UIWindow alloc ] initWithFrame: screenBounds ];
    if (iOS_7_Above) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    self.window.backgroundColor = RGBCOLOR(247, 247, 247);
    //    }
    
    
    //    if ([UserDefaultsHelper getBoolForKey:@"isNotFirst"]){
    //       [self showLoginView];
    //    }else{
    //        [self showGuideView];
    //    }
    //    [self showLoginView];
    //    [self showTabView];
    /*
     MainViewController *mainVC = [[MainViewController alloc] init];
     self.navigation = [[DTNavigationController alloc] initWithRootViewController:mainVC];
     [self.navigation setNavigationBarHidden:YES];
     self.window.rootViewController = self.navigation;
     //*/
    //    [self showLoginView];
    //    [self showMainView];
    
    
    
    NSString *loginName = [UserDefaultsHelper getStringForKey:@"loginName"];
    NSString *passWord = [UserDefaultsHelper getStringForKey:@"passWord"];
    if ([[UserDefaultsHelper getStringForKey:@"automaticLogin"] isEqualToString:@"yes"]) {
        if (loginName !=nil && ![loginName isEqualToString:@""])
        {
            
            if (passWord !=nil && ![passWord isEqualToString:@""])
            {
                UserModel *userModel = [[UserModel alloc] init];
                userModel.userId = [UserDefaultsHelper getStringForKey:@"userId"];
                userModel.loginName = [UserDefaultsHelper getStringForKey:@"loginName"];
                userModel.fullName = [UserDefaultsHelper getStringForKey:@"fullName"];
                userModel.age = [UserDefaultsHelper getStringForKey:@"age"];
                userModel.area = [UserDefaultsHelper getStringForKey:@"area"];
                userModel.gender = [UserDefaultsHelper getStringForKey:@"gender"];
                userModel.mobile = [UserDefaultsHelper getStringForKey:@"mobile"];
                userModel.registerDate = [UserDefaultsHelper getStringForKey:@"registerDate"];
                userModel.sign = [UserDefaultsHelper getStringForKey:@"sign"];
                userModel.userPhoto = [UserDefaultsHelper getStringForKey:@"userPhoto"];
                userModel.carPhoto = [UserDefaultsHelper getStringForKey:@"carPhoto"];
                self.userModel = userModel;
                [self showMainView];
            } else {
                [self showLoginView];
            }
        }else{
            [self showLoginView];
        }
    }else{
        [self showLoginView];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"locationLaunched"];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"locationLaunched"];
    }
    if (iOS_7_Above) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.window makeKeyAndVisible];
  //  [self showMainView];
  [self showLoginView];
    return YES;
}

-(void)checkNetworkMessage
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"连接失败，请检查您的网络！"
                                                 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });

}


-(void)sessionKeyMessage
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请重新登录!"
                                                 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//检测更新
- (void)updateMessage:(int)code
{
    UIAlertView *alert;
    if (code == 0)
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"发现新版本." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"安装", nil];
    }
    alert.tag = 4;
    [alert show];
    
}

//注销登录
- (void)logoutMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要注销吗？"
                                                   delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 3;
    [alert show];
    
}
//注销登录UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3 && buttonIndex == 1) {
        
        //向服务器发出注销请求
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@?method=fyclass.logout",INTERFACEURL] ];
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
        request.delegate=self;
        [request startSynchronous];
        NSLog(@"---%@---",[request responseString]);
        //删除sessionKey
        self.sessionKey = nil;
        
        [self showLoginView];
        
    }
    else if (alertView.tag == 4 && buttonIndex == 1) {
        if (alertView.numberOfButtons == 2 && buttonIndex == 0)
        {
            return;
        }
        NSString *plistURL = [UserDefaultsHelper getStringForKey:@"FilePath"];
        NSString *url = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", plistURL];
        
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)hideTabBar{
    [tabBarController hideBaseTabBar:YES];
}

- (void)showTabBar{
    [tabBarController hideBaseTabBar:NO];
}


-(void)showMainView
{
//#ifdef IMPORT_LETUIM_H
//    [[LeTuIM sharedInstance] queryMyLeTuBuddies];
//    
//    if ([LeTuIM startServe])
//        [[LeTuIM sharedInstance] updateMydialogInfomation];
//    else
//        if (DEBUG)
//            [UILabel showTipsLabelWithTips:@"启动聊天服务失败"];
//#endif
    if (loginViewController!=nil) {
        [loginViewController.view removeFromSuperview];
        loginViewController = nil;
    }
    self.mainViewController = [[MainViewController alloc] init];
    self.navigation = [[DTNavigationController alloc] initWithRootViewController:self.mainViewController];
    [self.navigation setNavigationBarHidden:YES];
    self.window.rootViewController = self.navigation;
    
}
-(void)showLoginView{
    if (self.mainViewController !=nil) {
        [self.mainViewController.view removeFromSuperview];
        self.mainViewController = nil;
    }
    loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    if (isIOS7) {
        
        navigation.edgesForExtendedLayout = UIRectEdgeNone;
    }
   // [navigation setNavigationBarHidden:YES];
    
    self.window.rootViewController = navigation;
    /*
     if (tabBarController != nil) {
     [tabBarController.view removeFromSuperview];
     tabBarController = nil;
     
     }
     
     if (loginViewController != nil) {
     
     [loginViewController.view removeFromSuperview];
     loginViewController = nil;
     }
     
     loginViewController = [[LoginViewController alloc] init];
     [self.window addSubview:loginViewController.view];
     //*/
    
    
    /**
     else
     {
     rootViewController.view.layer.hidden = NO;
     }
     **/
    
	//[rootViewController viewDidLoad];
	
}


- (void)showGuideView
{
    
    if (tabBarController != nil) {
        [tabBarController.view removeFromSuperview];
    }
    loginViewController = nil;
    guideController = [[ScrollViewController alloc] init];
    guideController.modelFrom = 0;
    [self.window addSubview:guideController.view];
}


-(void)showTabView
{
    [loginViewController.view removeFromSuperview];
    loginViewController = nil;
    
    //    tabBarController = [[TabBarController alloc] init];
    if (isNewUser)
    {
        if (tabBarController != nil)
        {
            [tabBarController removeFromParentViewController];
            
            tabBarController = nil;
        }
        tabBarController = [[TabBarController alloc] init];
        [self setupViewControllers];
    }
    else
    {
        if (tabBarController == nil)
        {
            tabBarController = [[TabBarController alloc] init];
            [self setupViewControllers];
        }
    }
    
    [window addSubview:tabBarController.view];
    
    //tabBarController.view.hidden = YES;
    
    
    
    //    tabBarController.selectedIndex = 1;
}
- (void)currentTab:(int)currentIndex
{
    if (tabBarController == nil) {
        [self showTabView];
    }
    [tabBarController currentTab:currentIndex];
    
}


-(void)setupViewControllers
{
    NSMutableArray* viewControllers =  [[NSMutableArray alloc] init];
    BaseViewController *viewController;
    
    UINavigationController *navViewController;
    
    UIImage *image1 = [UIImage imageNamed:@"monitor_title"];
    UIImage *image2 = [UIImage imageNamed:@"record_title"];
    UIImage *image4 = [UIImage imageNamed:@"setting_title"];
    
    viewController = [[MapHomeViewController alloc] init];
    //    viewController = [[LoginViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = true;
    [viewController setTitleImage:image1 andShowButton:NO];
    navViewController= [[UINavigationController alloc] initWithRootViewController: viewController];
    [navViewController setNavigationBarHidden:YES];
    [viewControllers addObject:navViewController];
    
    viewController = [[MessageBoxViewController alloc] init];
    //    [viewController setTitleImage:image2 andShowButton:NO];
    viewController.hidesBottomBarWhenPushed = true;
    navViewController= [[UINavigationController alloc] initWithRootViewController:viewController ];
    [navViewController setNavigationBarHidden:YES];
    [viewControllers addObject:navViewController];
    
    viewController = [[FoundViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = true;
    navViewController= [[UINavigationController alloc] initWithRootViewController:viewController  ];
    [navViewController setNavigationBarHidden:YES];
    [viewControllers addObject:navViewController];
    
    viewController = [[MyselfHomeViewController alloc] init];
    [viewController setTitleImage:image4 andShowButton:NO];
    viewController.hidesBottomBarWhenPushed = true;
    navViewController= [[UINavigationController alloc] initWithRootViewController:viewController ];
    [navViewController setNavigationBarHidden:YES];
    
    [viewControllers addObject:navViewController];
    
    tabBarController.viewControllers = viewControllers;
	
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (void)locationUtil:(LocationUtil *)locationUtil place:(CLPlacemark *)place coordinate:(CLLocationCoordinate2D)coordinate
{
    self.currentLocation = coordinate;
    self.locality = place.locality;
}

+ (AppDelegate*) sharedAppDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
