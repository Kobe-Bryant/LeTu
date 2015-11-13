//
//  SettingViewController.m
//  E-learning
//
//  Created by Mac Air on 13-9-5.
//
//

#import "SettingViewController.h"
#import "EGOImageView.h"
#import "ScrollViewController.h"
#import "AboutUsViewController.h"
#import "AppDelegate.h"
#import "UserDefaultsHelper.h"


@interface SettingViewController ()
{
    EGOImageView *headImageView;
    UILabel *userNameLabel;
    UILabel *authorityLabel;
    UILabel *departmentLabel;
    NSString *serverName;
}
@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self drawView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - drawView

- (void) drawView
{
    UIImage *headImage = [UIImage imageNamed:@"headImage"];
    headImageView = [[EGOImageView alloc] initWithPlaceholderImage:headImage];
    headImageView.frame = CGRectMake(15, 60, headImage.size.width, headImage.size.height);
//    headImageView.image = img;
//    headImageView.imageURL = [NSURL URLWithString:URLString];
    [self.view addSubview:headImageView];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"用户名:", @"权    限:",@"部    门:",nil];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 55 + i * 20, 70, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [titleArray objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
    }
    
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 55, 180, 20)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.text = [UserDefaultsHelper getStringForKey:@"userName"];
    userNameLabel.textColor = [UIColor grayColor];
    userNameLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:userNameLabel];
    
    authorityLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 75, 180, 20)];
    authorityLabel.backgroundColor = [UIColor clearColor];
    authorityLabel.text = @"超级管理员";
    authorityLabel.textColor = [UIColor grayColor];
    userNameLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:authorityLabel];
    
    departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 95, 180, 20)];
    departmentLabel.backgroundColor = [UIColor clearColor];
    departmentLabel.text = @"监查大队";
    departmentLabel.textColor = [UIColor grayColor];
    departmentLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:departmentLabel];
    
    for (int i = 1; i <= 4; i++) {
        UIImage *bg1 = [UIImage imageNamed:[NSString stringWithFormat:@"settingBtn%d", i]];
//        UIImage *bg2 = [UIImage imageNamed:[NSString stringWithFormat:@"settingBtn%d_c", i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15, 140 + 42 * (i - 1), 290, 42);
        [button setBackgroundImage:bg1 forState:UIControlStateNormal];
//        [button setBackgroundImage:bg2 forState:UIControlStateHighlighted];
        button.tag = i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
}

#pragma mark - buttonEvents
- (void) buttonPressed:(UIButton *) button
{
    switch (button.tag) {
        case 1:
            [self checkVersion];
            break;
        case 2://服务器配置
        {
            UIImage *bg = [UIImage imageNamed:@"pop_up_box"];
//            CustomAlertView *alert = [[CustomAlertView alloc] initWithBackgroundImage:bg model:k_ALERTVIEW_TEXTINPUT];
//            alert.alertDelegate = self;
//            alert.delegate = self;
//            NSString *serviceAPIURL = SERVERURL;
//            alert.defaultSevice = [serviceAPIURL substringFromIndex:7];
//            [alert show];
        }
            break;
        case 3:
        {
            ScrollViewController *scrollViewController = [[ScrollViewController alloc] init];
            scrollViewController.modelFrom = 1;
            [self.navigationController presentModalViewController:scrollViewController animated:YES];
        }
            
            break;
        case 4:
        {
            AboutUsViewController *vc = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - CustomAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex inputSevice:(NSString *) seviceName
{
    NSLog(@"%d %@", buttonIndex, seviceName);
    
    if (seviceName && ![serverName isEqualToString:@""]) {
        
        [self getServerInfomation:seviceName];
        serverName = seviceName;

    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

- (void) getServerInfomation:(NSString *)seviceName;
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@?method=appprocess.getservername",SERVERAPIURL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    ?method=appprocess.getservername&address=219.137.166.131:7001
    [dict setValue:seviceName forKey:@"address"];
    if (queue == nil )
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    NSLog(@"dict is%@",dict);
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:dict];
    operation.RequestTag = 3;
    [queue addOperation :operation];
}


- (void)checkVersion
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@?method=appprocess.getversion",SERVERAPIURL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"ios" forKey:@"type"];
    if (queue == nil )
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    NSLog(@"dict is%@",dict);
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:dict];
    operation.RequestTag = 4;
    [queue addOperation :operation];
    
}


-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    NSLog(@"%@", data);
    switch (tag) {
        case 3:
        {
            NSLog(@"%@", [[data objectForKey:@"obj"] objectForKey:@"Name"]);
            if ([[data objectForKey:@"obj"] objectForKey:@"Name"]) {
                NSString *serverTitle = [[data objectForKey:@"obj"] objectForKey:@"Name"];
                NSString *sName = [NSString stringWithFormat:@"http://%@",serverName];
                NSString *aName = [NSString stringWithFormat:@"http://%@/api.ashx",serverName];
                NSLog(@"sName:%@, aName: %@",sName, aName);
                [UserDefaultsHelper setStringForKey:sName :@"serviceURL"];
                [UserDefaultsHelper setStringForKey:aName :@"serviceAPI"];
                [UserDefaultsHelper setStringForKey:serverTitle :@"serverTitle"];
                SHOWLOGINVIEW;
            }
        }
            break;
        case 4:
        {
            int result;
            float sVersion = [[[data objectForKey:@"obj"] objectForKey:@"Version"] floatValue];
            float version = [VERSIONNO floatValue];
            if (sVersion > version){
                result = 1;
            }else
                result = 0;
            NSString *filePath = [[data objectForKey:@"obj"] objectForKey:@"FilePath"];
            [UserDefaultsHelper setStringForKey:filePath :@"FilePath"];
            [(AppDelegate *)[[UIApplication sharedApplication]delegate] updateMessage:result];
        }
            break;
        default:
            break;
    }
    
}







@end
