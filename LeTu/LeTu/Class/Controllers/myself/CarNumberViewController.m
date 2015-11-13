//
//  CarNumberViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-24.
//
//

#import "CarNumberViewController.h"
#import "BrandCar.h"



@interface CarNumberViewController ()
{
    NSOperationQueue* queue;
    

}
@property(nonatomic,strong)  UIView* backView;
@property(nonatomic,strong) UITextField* carNumberTextField;
@property(nonatomic,strong) NSArray* placeArray;
@property(nonatomic,strong) UIView* placeBackView;
@property(nonatomic,strong) UIButton* finshButton;
@property(nonatomic,strong) UILabel* placeLabel;





@end

@implementation CarNumberViewController

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
    
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, FRAME_WIDTH, topBar.size.height)];
    topBarImageView.image = topBar;
    topBarImageView.userInteractionEnabled = YES;
    [self.view addSubview:topBarImageView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 20.0, 220, 44)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"提交车牌号";
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
    
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(230.0, 25.0, 80.0, 40.0);
    [sureButton setTitle:@"保存" forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0);
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 2;
    [topBarImageView addSubview:sureButton];
    
    
    self.backView = [[UIView alloc]init];
    self.backView.frame = CGRectMake(0.0, 10.0+64, self.view.frame.size.width, 46);
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.borderWidth = 0.5;
    self.backView.layer.borderColor =RGBCOLOR(212, 212, 212).CGColor;
    [self.view addSubview:self.backView];
    
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.frame = CGRectMake(10.0, 12.0, 70, 20);
    numberLabel.font = [UIFont systemFontOfSize:16];
    numberLabel.textColor = RGBCOLOR(54, 54, 54);
    numberLabel.text = @"车牌号码";
    [self.backView addSubview:numberLabel];
    
    UIButton* clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(CGRectGetMaxX(numberLabel.frame), 0.0, 40, 40);
    clickButton.backgroundColor = [UIColor clearColor];
    [clickButton addTarget:self action:@selector(chosePlace:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:clickButton];

    
    
    _placeLabel = [[UILabel alloc]init];
    _placeLabel.frame = CGRectMake(CGRectGetMaxX(numberLabel.frame)+5, 12.0, 20, 20);
    _placeLabel.font = [UIFont systemFontOfSize:16];
    _placeLabel.textColor = RGBCOLOR(160, 160, 160);
    NSLog(@"%@",self.car.carPlace);

    if ([self.car.carPlace isEqualToString:@"(null)"] ||[self.car.carPlace isEqualToString:@" "] ||self.car.carPlace==nil) {
        
        _placeLabel.text = @"京";

    }else {
    
        _placeLabel.text = self.car.carPlace;

    }
    [self.backView addSubview:_placeLabel];
    

    
    UIImage* downImage = [UIImage imageNamed:@"meDownward.png"];
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(CGRectGetMaxX(_placeLabel.frame), 20,downImage.size.width , downImage.size.height);
    imageView.image = downImage;
    [self.backView addSubview:imageView];
    
    
    
    
    self.carNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 8.0, 12, 180, 20)];
    self.carNumberTextField.backgroundColor = [UIColor clearColor];
    self.carNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.carNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.carNumberTextField.placeholder = @"请输入车牌号码";
    self.carNumberTextField.text = self.car.carNumber;
    [self.backView addSubview:self.carNumberTextField];
    
    
    self.placeBackView = [[UIView alloc]init];
    self.placeBackView.frame = CGRectMake(0.0,-150+CGRectGetHeight(self.view.frame), self.view.frame.size.width, 150);
    self.placeBackView.hidden = YES;
    self.placeBackView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.placeBackView];
    
    self.placeArray = [[NSArray alloc] initWithObjects:@"京",@"沪",@"津",@"渝",@"黑",@"吉",@"辽",@"蒙",@"冀",@"新",@"甘",@"青",@"陕",@"宁",@"豫",@"鲁",@"晋",@"皖",@"鄂",@"湘",@"苏",@"川",@"贵",@"云",@"桂",@"藏",@"浙",@"赣",@"粤",@"闽",@"台",@"琼",@"港",@"澳", nil];
    
    CGFloat spaceY = 8.0;
    CGFloat spaceX = 5.0;
    CGFloat rowSpaceX = 15.0;
    CGFloat rowSpaceY = 16.0;
    
    NSInteger row =1;
    NSInteger m = 0;
    for (int i = 0; i <self.placeArray.count ; i++) {
        
    UIButton* button = [self createButton:self.placeArray[i]];
     if (i /9==1 && i%9==0) {
            m =0;
            row = 2;
     } else if (i/9==2 && i%9==0){
             m=0;
           row = 3;
     }else if (i/9==3 && i%9==0){
            m=0;
           row =4;
     }
      button.frame = CGRectMake(spaceX+20*m+rowSpaceX*m, spaceY+(row-1)*rowSpaceY+20*(row-1), 20.0, 20.0);
      [self.placeBackView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(clickChoseButton:) forControlEvents:UIControlEventTouchUpInside];
       m++;
    }
    
    self.finshButton = [self createButton:@"完成"];
    self.finshButton.frame = CGRectMake(265.0, 115.0, 40, 20);
    [self.finshButton addTarget:self action:@selector(clickChoseButton:) forControlEvents:UIControlEventTouchUpInside];
    self.finshButton.tag = 100;
    [self.placeBackView addSubview:self.finshButton];
}
- (UIButton*)createButton:(NSString*)title
{
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.backgroundColor = [UIColor clearColor];
    bt.titleLabel.textColor = [UIColor whiteColor];
    bt.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [bt setTitle:title forState:UIControlStateNormal];
    return bt;
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.placeBackView.hidden = YES;
    [self.carNumberTextField resignFirstResponder];
}
- (void)clickChoseButton:(UIButton*)bt
{
    NSLog(@"button = %d",bt.tag);
    if (bt.tag ==100) {
    
     self.placeBackView.hidden = YES;
        
    }else {
    
        self.placeLabel.text = self.placeArray[bt.tag];
    }
}
- (void)chosePlace:(UIButton*)bt
{
    [self.carNumberTextField resignFirstResponder];
    
    if (self.placeBackView.hidden) {
        
        self.placeBackView.hidden = NO;
    }else {
    
        self.placeBackView.hidden = YES;
        
    }

}


- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
    
        [self.navigationController popViewControllerAnimated:YES];
     
    }else {

        NSLog(@"%@",self.placeLabel.text);
        
        if ([[self.placeLabel text] isEqualToString:@""]) {
       
            [[[[iToast makeText:@"车辆归属地不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
            return;
        
        }
        
        if ([self.placeLabel.text isEqualToString:@"(null)"]) {
            [[[[iToast makeText:@"车辆归属地不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
            return;
            
        }
        if ([[self.carNumberTextField text] isEqualToString:@""]) {
            [[[[iToast makeText:@"车牌号码不能为空..."] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
            return;
        }
        
        [self updateMyCarInfomation:self.placeLabel.text number:self.carNumberTextField.text];
        
        }
    
}
- (void)updateMyCarInfomation:(NSString*)place number:(NSString*)carNumber
{

    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar2/myCarService.jws?changeMyCar", SERVERAPIURL];
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
     NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:place forKey:@"carLocation"];
    [param setObject:carNumber forKey:@"carNumber"];
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
-( void )reponseFaild:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
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
    
  [[[[iToast makeText:@"汽车车牌号信息修改成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    
}

@end
