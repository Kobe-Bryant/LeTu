//
//  RegistThreeViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-16.
//
//

#import "RegistThreeViewController.h"
#import "LoginViewController.h"


@interface RegistThreeViewController ()
@property(nonatomic,strong) UITextField* homeTextField;
@property(nonatomic,strong) UITextField* companyTextField;
@property(nonatomic,strong) UIButton* homeMapButton;
@property(nonatomic,strong) UIButton* companyMapButton;
@property(nonatomic,strong) UIButton* complishButton;



@end

@implementation RegistThreeViewController

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

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 120, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"注册3/3";
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
    sureButton.frame = CGRectMake(0.0, 0.0, 80, 40);
    [sureButton setTitle:@"完成" forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 2;
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:sureButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    

}
- (void)viewWillAppear:(BOOL)animated
{
    
   [super viewWillAppear:animated];
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    
    
    
    UIImage* homeImage = [UIImage imageNamed:@"loginRegistration.png"];
    UIImageView* homeImageView = [[UIImageView alloc]init];
    homeImageView.frame = CGRectMake(8.0, 10,homeImage.size.width, homeImage.size.height);
    homeImageView.image = homeImage;
    homeImageView.userInteractionEnabled = YES;
    [self.view addSubview:homeImageView];
    
    self.homeTextField = [[UITextField alloc] initWithFrame:CGRectMake(80.0, 1.0, 200, 40)];
    self.homeTextField.backgroundColor = [UIColor clearColor];
    self.homeTextField.returnKeyType = UIReturnKeyDone;
    self.homeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.homeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.homeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.homeTextField.text = @"";
    self.homeTextField.placeholder = @"请设置住宅地址";
    [homeImageView addSubview:self.homeTextField];
    
    UIImage* homeMapImage = [UIImage imageNamed:@"loginMap.png"];
    self.homeMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homeMapButton.backgroundColor = [UIColor clearColor];
    self.homeMapButton.frame = CGRectMake(CGRectGetMaxX(self.homeTextField.frame)-5.0, self.homeTextField.frame.origin.y+5,homeMapImage.size.width, homeMapImage.size.height);
    [self.homeMapButton setBackgroundImage:homeMapImage forState:UIControlStateNormal];
    self.homeMapButton.selected = NO;
    self.homeMapButton.tag = 3;
    [self.homeMapButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [homeImageView addSubview:self.homeMapButton];
    
    
    
    
    UIImage* companyImage = [UIImage imageNamed:@"logincompany.png"];
    UIImageView* companyImageView = [[UIImageView alloc]init];
    companyImageView.frame = CGRectMake(8.0, CGRectGetMaxY(homeImageView.frame) +10,homeImage.size.width, homeImage.size.height);
    companyImageView.image = companyImage;
    companyImageView.userInteractionEnabled = YES;
    [self.view addSubview:companyImageView];
    
    
    
    self.companyTextField = [[UITextField alloc] initWithFrame:CGRectMake(80.0, 1.0, 200, 40)];
    self.companyTextField.backgroundColor = [UIColor clearColor];
    self.companyTextField.returnKeyType = UIReturnKeyDone;
    self.companyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.companyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.companyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.companyTextField.text = @"";
    self.companyTextField.placeholder = @"请设置公司地址";
    [companyImageView addSubview:self.companyTextField];
    

 
    
    UIImage* mapImage = [UIImage imageNamed:@"loginMap.png"];
    self.companyMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.companyMapButton.backgroundColor = [UIColor clearColor];
    self.companyMapButton.frame = CGRectMake(CGRectGetMaxX(self.companyTextField.frame)-5.0, self.companyTextField.frame.origin.y+5,homeMapImage.size.width, homeMapImage.size.height);
    [self.companyMapButton setBackgroundImage:mapImage forState:UIControlStateNormal];
    self.companyMapButton.selected = NO;
    self.companyMapButton.tag = 4;
    [self.companyMapButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [companyImageView addSubview:self.companyMapButton];
    
    //注册按钮
    UIImage* loginImage = [UIImage imageNamed:@"loginBtAccomplish.png"];
    self.complishButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, CGRectGetMaxY(companyImageView.frame) +15.0, loginImage.size.width, loginImage.size.height)];
    [self.complishButton setImage:loginImage forState:UIControlStateNormal];
    [self.complishButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.complishButton.tag = 5;
    [self.view addSubview:self.complishButton];
    
}
- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
    
    [self.navigationController popViewControllerAnimated:YES];
        
        
    }else if (bt.tag ==2){
    
    
    }else if (bt.tag ==3){
        
    
    }else if (bt.tag ==4){
    
    
    }else if (bt.tag ==5){
    
        LoginViewController* loginVC = [[LoginViewController alloc]init];
        UINavigationController* navigationVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:navigationVC animated:YES completion:nil];
    }
}

@end
