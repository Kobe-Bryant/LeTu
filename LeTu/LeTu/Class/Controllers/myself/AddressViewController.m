//
//  AddressViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import "AddressViewController.h"

@interface AddressViewController ()
@property(nonatomic,strong) TableView* tableView;

@end

@implementation AddressViewController

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
    
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, FRAME_WIDTH, topBar.size.height)];
    topBarImageView.image = topBar;
    topBarImageView.userInteractionEnabled = YES;
    [self.view addSubview:topBarImageView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 20.0, 220, 44)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"常用地址";
    label.backgroundColor = [UIColor clearColor];
    [topBarImageView addSubview:label];
    
    UIImage* backImage = [UIImage imageNamed:@"topBack.png"];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10.0, 20.0, 80.0, 40.0);
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -35.0, 0.0, 0.0);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.tag = 1;
    [backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [topBarImageView addSubview:backButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGBCOLOR(238, 238, 238);
    //self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2.0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
        NSString* cellidenty = @"cellID";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidenty];
        
        if (cell ==nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidenty];
            
        }
        
        cell.textLabel.textColor =RGBCOLOR(54.0, 54.0, 54.0);
        cell.detailTextLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);
        UIImage* arrImage = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        UIImageView* arrimageview = [[UIImageView alloc]init];
        arrimageview.frame = CGRectMake(300.0, 10.0,arrImage.size.width , arrImage.size.height);
        arrimageview.image = arrImage;
        cell.accessoryView = arrimageview;
    if (indexPath.section ==0) {
   
        UIImage* homeImage = [UIImage imageNamed:@"meIconHome.png"];
        cell.imageView.image = homeImage;
        cell.textLabel.text = @"家";
        cell.detailTextLabel.text = @"xxxxxxxxxxxx";
    
    }else {
    
        
        UIImage* homeImage = [UIImage imageNamed:@"meIconCompany.png"];
        cell.imageView.image = homeImage;
        cell.textLabel.text = @"公司";
        cell.detailTextLabel.text = @"xxxxxxxxxxxx";
    
    }
    
    return cell;
        
}
    
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ( section ==0) {
        
        return 0.1;
    }
    return 5.0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  return 40.0;
        
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)backButtonMethod:(UIButton*)bt
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
