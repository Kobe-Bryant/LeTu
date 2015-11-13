
//
//  MainViewController.m
//  LeTu
//
//  Created by DT on 14-6-7.
//
//
//
// ┏ ┓　　　┏ ┓
//┏┛ ┻━━━━━┛ ┻┓
//┃　　　　　　 ┃
//┃　　　━　　　┃
//┃　┳┛　  ┗┳　┃
//┃　　　　　　 ┃
//┃　　　┻　　　┃
//┃　　　　　　 ┃
//┗━┓　　　┏━━━┛
//  ┃　　　┃   神兽保佑
//  ┃　　　┃   代码无BUG！
//  ┃　　　┗━━━━━━━━━┓
//  ┃　　　　　　　    ┣┓
//  ┃　　　　         ┏┛
//  ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//    ┃ ┫ ┫   ┃ ┫
//    ┗

#import "MainViewController.h"
#import "DTButton.h"
#import "DTTabBar.h"
#import "DTTabBarItem.h"
#import "MapHomeViewController.h"
#import "MessageBoxViewController.h"
#import "FoundViewController.h"
#import "MyselfHomeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

static double delayInSeconds = 5.0;

@interface MainViewController()<DTTabBarDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)DTTabBar *tabBar;
@property(nonatomic,strong)AppDelegate *appDelegate;
@property(nonatomic,strong)MapHomeViewController *mapVC;
@property(nonatomic,strong)MessageBoxViewController *messageVC;
@property(nonatomic,strong)FoundViewController *foundVC;
@property(nonatomic,strong)MyselfHomeViewController *myselfVC;
@property(nonatomic,strong)NSMutableArray* array;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    if (iOS_7_Above) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    self.appDelegate = [AppDelegate sharedAppDelegate];
    self.array = [[NSMutableArray alloc] init];
//    self.view.backgroundColor = [UIColor blackColor];
    if (iOS_7_Above) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [DTTabBarItem itemWithNormalImageName:@"letu_navbtn_letu_normal" highlightImageName:@"letu_navbtn_letu_press"],
                      [DTTabBarItem itemWithNormalImageName:@"letu_navbtn_message_normal" highlightImageName:@"letu_navbtn_message_press"],
                      [DTTabBarItem itemWithNormalImageName:@"letu_navbtn_find_normal" highlightImageName:@"letu_navbtn_find_press"],
                      [DTTabBarItem itemWithNormalImageName:@"letu_navbtn_my_normal" highlightImageName:@"letu_navbtn_my_pressl"], nil];
    
    int y = [UIScreen mainScreen].bounds.size.height -TABBAR_HEIGHT;
    if (!iOS_7_Above) {
        y -=20;
    }
    self.tabBar = [[DTTabBar alloc] initWithFrame:CGRectMake(0,y,320,TABBAR_HEIGHT) array:array];
    self.tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"letu_nav_bg"]];
    self.tabBar.shadeButton.hidden = YES;
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
    self.appDelegate.tabBar = self.tabBar;
    
    UIView *view = [[UIView alloc] initWithFrame:self.tabBar.frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:self.tabBar];
   
    DTButton *button = nil;
    button = [self.tabBar.buttonArray objectAtIndex:0];
    [button redDotNormal:[UIImage imageNamed:@"letu_normal"] redDotPress:[UIImage imageNamed:@"letu_press"]];
//    button.isRedDot = YES;
    
    
    button = [self.tabBar.buttonArray objectAtIndex:1];
    [button redDotNormal:[UIImage imageNamed:@"message_normal"] redDotPress:[UIImage imageNamed:@"message_press"]];
//    button.isRedDot = YES;
    
    
    button = [self.tabBar.buttonArray objectAtIndex:2];
    [button redDotNormal:[UIImage imageNamed:@"find_normal"] redDotPress:[UIImage imageNamed:@"find_press"]];
//    button.isRedDot = YES;
    
    button = [self.tabBar.buttonArray objectAtIndex:3];
    [button redDotNormal:[UIImage imageNamed:@"my_normal"] redDotPress:[UIImage imageNamed:@"my_pressl"]];
//    button.isRedDot = YES;
    
    CGRect frame = self.view.frame;
    frame.size.height -=TABBAR_HEIGHT;
    if (!iOS_7_Above) {
        frame.origin.y -=20;
    }
    self.mapVC = [[MapHomeViewController alloc] init];
    self.mapVC.view.frame = frame;
    [self addChildViewController:self.mapVC];
    [self.array addObject:self.mapVC];
    
    self.messageVC = [[MessageBoxViewController alloc] init];
    self.messageVC.view.frame = frame;
    [self addChildViewController:self.messageVC];
    [self.array addObject:self.messageVC];
    
    self.foundVC = [[FoundViewController alloc] init];
    self.foundVC.view.frame = frame;
    [self addChildViewController:self.foundVC];
    [self.array addObject:self.foundVC];
    
    self.myselfVC = [[MyselfHomeViewController alloc] init];
    self.myselfVC.view.frame = frame;
    [self addChildViewController:self.myselfVC];
    [self.array addObject:self.myselfVC];
    
    [self.view addSubview:self.mapVC.view];
    self.currentViewController = self.mapVC;
    
    
    [self ckeckAccount];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark DTTabBarDelegate
-(void)callButtonAction:(int)index
{
    if (self.tabBar.currentTab==index) {
        return;
    }
    UIViewController *viewController = [self.array objectAtIndex:index];
    [self transitionFromViewController:self.currentViewController toViewController:viewController duration:0 options:0 animations:^{
    }  completion:^(BOOL finished) {
        self.currentViewController=viewController;
        if ([self.currentViewController isKindOfClass:[MapHomeViewController class]]) {
            DTButton *button = [self.tabBar.buttonArray objectAtIndex:0];
            button.isRedDot = NO;
        }
    }];
}
/**
 *  查看是否有新的申请
 */
- (void)hasNewApply
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?hasNewApply", SERVERAPIURL];
    if (self.queue == nil)
    {
        self.queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [self.queue addOperation :operation];
}
/**
 *  获取拼车数据列表
 */
- (void)GetCarpoolList
{
    /*
    if (!self.request) {
        NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?applyList", SERVERAPIURL];
        self.request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
        [self.request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
        [self.request buildPostBody];
        self.request.tag=1;
        [self.request setDelegate:self];
        [self.request setTimeOutSeconds:60];
    }
    [self.request startAsynchronous];
     //*/
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?applyList", SERVERAPIURL];
    if (self.queue == nil)
    {
        self.queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [self.queue addOperation :operation];
}
-(void)responseNotify:( id )sender
{
    RequestParseOperation * operation=( RequestParseOperation *)sender;
    
    NSDictionary *dictionary = operation.data;
    ErrorModel *error = [[ErrorModel alloc] initWithDataDict:[dictionary valueForKey:@"error"]];
    if (error == nil) {
//        NSLog(@"------errCode=null---------");
    }
    if (error != nil && error.err_code != nil){
        NSInteger errCode = [error.err_code  intValue];
        NSString *errMsg = error.err_msg;
//        NSLog(@"------errCode-----%d----",errCode);
        if (errCode == -1) {
            SHOWLOGINVIEW;
        }
        else if (errCode < 2){
            if (operation.RequestTag==1) {
                NSDictionary *objDict = [dictionary objectForKey:@"list"];
                if ([objDict count]>0) {
                    //                NSLog(@"objDict count:%i",[objDict count]);
                    if (![self.currentViewController isKindOfClass:[MapHomeViewController class]]) {
                        DTButton *button = [self.tabBar.buttonArray objectAtIndex:0];
                        button.isRedDot = YES;
                        //                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newCarpoolList" object:nil userInfo:objDict];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hasNewApply" object:nil];
                }
                
                if (self.is_dispatch_time_t) {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self GetCarpoolList];
//                        [self hasNewApply];
                    });
                }
            }else if (operation.RequestTag==2){
                NSDictionary *objDict = [dictionary objectForKey:@"obj"];
                if ([objDict count]>0) {
                    if ([[objDict objectForKey:@"newApply"] intValue]!=0) {
                        DTButton *button = [self.tabBar.buttonArray objectAtIndex:3];
                        button.isRedDot = YES;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hasNewApply" object:nil];
                    }
                }
                
                if (self.is_dispatch_time_t) {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * 2 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self hasNewApply];
                    });
                }
            }
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:errMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag==1) {//获取拼车数据列表
        JSONDecoder *decoder=[JSONDecoder decoder];
        NSDictionary *dict=[decoder objectWithData:request.responseData];
        NSDictionary *error = [dict objectForKey:@"error"];
        if ([[error objectForKey:@"err_code"] intValue] == 2) {
            return;
        }
        NSDictionary *objDict = [dict objectForKey:@"list"];
        if ([objDict count]>0) {
            if (![self.currentViewController isKindOfClass:[MapHomeViewController class]]) {
                DTButton *button = [self.tabBar.buttonArray objectAtIndex:0];
                button.isRedDot = YES;
//                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newCarpoolList" object:nil userInfo:objDict];
        }
        
        if (self.is_dispatch_time_t) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self GetCarpoolList];
            });
        }
    }else if (request.tag==888){//验证帐号
        JSONDecoder *decoder=[JSONDecoder decoder];
        NSDictionary *dict=[decoder objectWithData:request.responseData];
        NSDictionary *error = [dict objectForKey:@"error"];
        if ([[error objectForKey:@"err_code"] intValue] == 2) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[error objectForKey:@"err_msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            NSDictionary *objDict = [dict objectForKey:@"obj"];
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
            
            //启动线程
            self.is_dispatch_time_t = YES;
            [self GetCarpoolList];
            [self hasNewApply];
        }
    }else if (request.tag==2) {
        JSONDecoder *decoder=[JSONDecoder decoder];
        NSDictionary *dict=[decoder objectWithData:request.responseData];
        NSDictionary *error = [dict objectForKey:@"error"];
        if ([[error objectForKey:@"err_code"] intValue] == 2) {
            return;
        }
        NSDictionary *objDict = [dict objectForKey:@"list"];
        if ([objDict count]>0) {
            if ([[objDict objectForKey:@"newApply"] intValue]!=0) {
                DTButton *button = [self.tabBar.buttonArray objectAtIndex:3];
                button.isRedDot = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hasNewApply" object:nil];
            }
        }
        
        if (self.is_dispatch_time_t) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self hasNewApply];
            });
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.tag==1) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self GetCarpoolList];
        });
    }else if (request.tag==888) {//网络异常,重新请求
        [self ckeckAccount];
    }
}

/**
 *  检查帐号密码是否正确
 */
- (void)ckeckAccount
{
    if ([[UserDefaultsHelper getStringForKey:@"automaticLogin"] isEqualToString:@"yes"]) {//表示自动登录
        NSString *loginName = [UserDefaultsHelper getStringForKey:@"loginName"];
        NSString *passWord = [UserDefaultsHelper getStringForKey:@"passWord"];
        
        NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?login", SERVERAPIURL];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
        [request setPostValue:loginName forKey:@"login_name"];
        [request setPostValue:passWord forKey:@"password"];
        
        [request buildPostBody];
        request.tag=888;
        [request setDelegate:self];
        [request setTimeOutSeconds:60];
        [request startAsynchronous];
    }else{
        //启动线程
        self.is_dispatch_time_t = YES;
        [self GetCarpoolList];
        [self hasNewApply];
    }
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.appDelegate showLoginView];
}
@end
