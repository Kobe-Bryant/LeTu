//
//  MyselfAboutViewController.m
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "MyselfAboutViewController.h"

@interface MyselfAboutViewController ()
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *versionNumberLabel;
@property(nonatomic,strong)UIButton *updateButton;

@end

@implementation MyselfAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"关于" andShowButton:YES];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
 
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    self.versionNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.versionNumberLabel.backgroundColor = [UIColor clearColor];
    self.versionNumberLabel.textColor = [UIColor grayColor];
    self.versionNumberLabel.textAlignment = UITextAlignmentCenter;
    self.versionNumberLabel.text = [NSString stringWithFormat:@"V %@",self.appDelegate.versionNumber];
    [self.imageView addSubview:self.versionNumberLabel];
    
    self.updateButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.updateButton setImage:[UIImage imageNamed:@"checknew_btn_normal"] forState:UIControlStateNormal];
    [self.updateButton setImage:[UIImage imageNamed:@"checknew_btn_press"] forState:UIControlStateHighlighted];
    [self.updateButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.updateButton];
    
    if (height==480) {//3.5寸
        self.imageView.image = [UIImage imageNamed:@"about_832"];
        self.imageView.frame = CGRectMake(0, 44, 320, 416);
        self.versionNumberLabel.frame = CGRectMake(127, 205, 63, 20);
        self.updateButton.frame = CGRectMake(69, 240, 182, 36);
        
    }else if (height==568) {//4寸
        self.imageView.image = [UIImage imageNamed:@"about_1008"];
        self.imageView.frame = CGRectMake(0, 44, 320, 504);
        self.versionNumberLabel.frame = CGRectMake(127, 245, 63, 20);
        self.updateButton.frame = CGRectMake(69, 280, 182, 36);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  获取版本号
 *
 *  @param button
 */
-(void)clickButton:(UIButton*)button
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@common/commonService.jws?version", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:@"IOS" forKey:@"os_type"];
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag == 1) {
        NSDictionary *dict = [data objectForKey:@"obj"];
        NSString *appVersion = [dict objectForKey:@"appVersion"];
        if ([appVersion isEqualToString:self.appDelegate.versionNumber]) {
            [self messageToast:@"已经是最新版本!"];
        }else{
            [self messageShow:@"有最新安装包,请更新!"];
        }
    }
}
@end
