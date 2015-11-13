//
//  SignUpdateViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import "SignUpdateViewController.h"
#import "UserDefaultsHelper.h"
#import "UserDetailModel.h"


@interface SignUpdateViewController ()
{
    NSOperationQueue* queue;
    
 
}
@property(nonatomic,strong)  UITextView* textView;

@end

@implementation SignUpdateViewController

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
    
    NSLog(@"%@",self.navigationController);
    
    self.view.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
    // Do any additional setup after loading the view.
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }

    
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
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 20.0, 220, 44)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"编辑个性签名";
    label.backgroundColor = [UIColor clearColor];
    [topBarImageView addSubview:label];
    
    UIImage* backImage = [UIImage imageNamed:@"topBack.png"];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 20.0, 80.0, 40.0);
    [backButton setImage:backImage forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -40.0, 0, 0);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.tag = 1;
    [backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [topBarImageView addSubview:backButton];
    
    UIImage* backEditImage = [UIImage imageNamed:@"meInput300x120.png"];
    UIImageView* imageview =[[UIImageView alloc]init];
    imageview.frame = CGRectMake(10.0, 79.0, backEditImage.size.width, backEditImage.size.height);
    imageview.userInteractionEnabled = YES;
    imageview.image = backEditImage;
    [self.view addSubview:imageview];
    
    
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(230.0, 25.0, 80.0, 40.0);
    [sureButton setTitle:@"保存" forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0);
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 2;
    [topBarImageView addSubview:sureButton];
    
    self.textView = [[UITextView alloc]init];
    _textView.frame = CGRectMake(10.0, 10.0, backEditImage.size.width -20.0, backEditImage.size.height - 20);
    _textView.text = self.model.sign;
    _textView.font = [UIFont systemFontOfSize:16.0];
    _textView.textColor = RGBCOLOR(54, 54, 54);
    [imageview addSubview:_textView];
    
}

- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
    
        [self.navigationController popViewControllerAnimated:YES];

    }else {
    
        //更新签名。。。。。。。
        [self updateSign:self.textView.text];
        

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
- (void)updateSign:(NSString*)sign
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    [param setObject:@"sign" forKey:@"item"];
    [param setObject:sign forKey:@"sign"];
    [param setObject:lkey forKey:@"l_key"];
    
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:param];
    [queue addOperation :operation];
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
        userModel = [AppDelegate sharedAppDelegate].userModel;

    NSString *string = [data objectForKey:@"obj"];

        self.model.sign = string;
        userModel.sign = string;
        [[[[iToast makeText:@"更改个性签名成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateSignNotification" object:string userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}






@end
