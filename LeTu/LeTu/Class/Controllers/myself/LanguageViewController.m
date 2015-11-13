//
//  LanguageViewController.m
//  LeTu
//
//  Created by mafeng on 14-9-23.
//
//

#import "LanguageViewController.h"
#import "UserDetailModel.h"

@interface LanguageViewController ()
{
    NSOperationQueue* queue;
    
}
@property(nonatomic,strong) UITableView* tableview;
@property(nonatomic,strong)  UIImageView* avatorImageView;
@property(nonatomic,strong) NSMutableArray* selectArrayOne;
@property(nonatomic,strong) NSMutableArray* selectArrayTwo;
@property(nonatomic,strong) NSMutableArray* selectArray;
@property(nonatomic,strong) NSMutableArray* languageArray;
@property(nonatomic,strong) NSString* languageString;


@end

@implementation LanguageViewController

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
    NSArray* chinaArray = @[@"普通话",@"粤语",@"天津话",@"山东话",@"东北话",@"上海话",@"苏州话",@"温州话",@"四川话",@"湖南话",@"江西话",@"客家话",@"陕西话",@"闽南话",@"潮汕话",@" 雷州话",@"海南话",@"台语",@"蒙古语",@"藏语"];
    NSArray* englishArray = @[@"英语",@"西班牙语",@"阿拉伯语",@"俄语",@"日语",@"韩语",@"法语",@"德语",@"葡萄牙语",@"意大利语"];
    self.languageArray = [NSMutableArray arrayWithObjects:chinaArray,englishArray ,nil];
    
    self.selectArrayOne = [NSMutableArray array];
    self.selectArrayTwo = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    self.view.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
    // Do any additional setup after loading the view.
    [self initUINavigationController];
    if (iOS_7_Above) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    NSString* string = self.model.userLanguage;
    NSLog(@"%@",string);
    NSArray* array = [string componentsSeparatedByString:@","];
    for (NSString* location in array)
    {
     
         NSIndexPath* indexPath;
         for (NSString* obj in chinaArray) {
        
            NSInteger index = [chinaArray indexOfObject:obj];
            if ([obj isEqualToString:location]) {
                
                indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.selectArrayOne addObject:indexPath];
            }
        }
         for (NSString* objtwo in englishArray) {
            
            NSInteger index = [englishArray indexOfObject:objtwo];
            if ([objtwo isEqualToString:location]) {
                
                indexPath = [NSIndexPath indexPathForRow:index inSection:1];
                [self.selectArrayTwo addObject:indexPath];
            }
        }
    
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
    label.text = @"请选择语言";
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
    
    
    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(230.0, 25.0, 80.0, 40.0);
    [sureButton setTitle:@"保存" forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor clearColor];
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0);
    [sureButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 2;
    [topBarImageView addSubview:sureButton];
    
    
    CGFloat height = self.view.frame.size.height - 64;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,64.0, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableview.backgroundColor = RGBCOLOR(238, 238, 238);
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:self.tableview];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return self.languageArray.count;
    

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
    
    return @"汉语(最多只能选两项)";
        
    }else {
        
    return @"世界语(最多只能选两项)";

    
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.languageArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
     }

    if ([self.selectArrayOne containsObject:indexPath]) {
        
        UIImage* image = [UIImage imageNamed:@"meCheck.png"];
        self.avatorImageView = [[UIImageView alloc] init];
        self.avatorImageView.frame = CGRectMake(280.0, 15.0, image.size.width, image.size.height);
        self.avatorImageView.image = image;
        cell.accessoryView = self.avatorImageView;
        
    }else if([self.selectArrayTwo containsObject:indexPath]) {
        
        UIImage* image = [UIImage imageNamed:@"meCheck.png"];
        self.avatorImageView = [[UIImageView alloc] init];
        self.avatorImageView.frame = CGRectMake(280.0, 15.0, image.size.width, image.size.height);
        self.avatorImageView.image = image;
        cell.accessoryView = self.avatorImageView;
        
        
        
    }else {
        cell.accessoryView = nil;
  
    
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
    cell.detailTextLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);
    NSArray* array = self.languageArray[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
    
    
}
- (void)messageToast:(NSString*)msg
{
    [[[[iToast makeText:msg] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
      
        if (![self.selectArrayOne containsObject:indexPath]) {
            
             if (self.selectArrayOne.count >=2) {
                [self messageToast:@"最多只能选择两种语言"];
                return;
        }
          [self.selectArrayOne addObject:indexPath];
            
        }else {
            
          [self.selectArrayOne removeObject:indexPath];
        }
         [self.tableview reloadRowsAtIndexPaths:self.selectArrayOne withRowAnimation:UITableViewRowAnimationNone];
         [self.tableview reloadData];
        
    }else {
        if (![self.selectArrayTwo containsObject:indexPath]) {
            
            if (self.selectArrayTwo.count >=2) {
                
                [self messageToast:@"最多只能选择两种语言"];
                return;
            }
            [self.selectArrayTwo addObject:indexPath];
            
        }else {
            
            [self.selectArrayTwo removeObject:indexPath];
        }
        [self.tableview reloadRowsAtIndexPaths:self.selectArrayTwo withRowAnimation:UITableViewRowAnimationNone];
        [self.tableview reloadData];
    
    }

}

- (void)backButtonMethod:(UIButton*)bt
{
    if (bt.tag ==1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        for (NSIndexPath* indexPath in self.selectArrayOne) {
        
            NSArray* array = self.languageArray[indexPath.section];
            NSString* title = [array objectAtIndex:indexPath.row];
            [self.selectArray addObject:title];
         
        }
         for (NSIndexPath* indexPath in self.selectArrayTwo) {

            
            NSArray* array = self.languageArray[indexPath.section];
            NSString* title = [array objectAtIndex:indexPath.row];
            [self.selectArray addObject:title];
        
        }
     
        self.languageString = [self.selectArray componentsJoinedByString:@","];
        NSLog(@"str = %@",self.languageString);
        [self updatelanague:self.languageString];
        
        
        
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
- (void)updatelanague:(NSString*)language
{
   // http://218.17.99.76:8083/user/userService.jws?update&l_key=&item=fullName&fullName=
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString* lkey = [UserDefaultsHelper getStringForKey:@"key"];
    [param setObject:lkey forKey:@"l_key"];

    [param setObject:@"userLanguage" forKey:@"item"];
    [param setObject:language forKey:@"userLanguage"];
    
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
    
    self.model.userLanguage = string;
    userModel.sign = string;
    [[[[iToast makeText:@"语言设置成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateLauangeNotification" object:string userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
