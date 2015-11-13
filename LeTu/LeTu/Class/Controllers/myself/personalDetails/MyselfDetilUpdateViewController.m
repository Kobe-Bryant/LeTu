//
//  MyselfDetilUpdateViewController.m
//  LeTu
//
//  Created by DT on 14-5-20.
//
//

#import "MyselfDetilUpdateViewController.h"

#ifdef IMPORT_LETUIM_H
#import "LeTuIM.h"
#endif

#define INTNUM @"0123456789"

@interface MyselfDetilUpdateViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSOperationQueue *queue;
    CallBack callBack;
    int selectIndex;
}
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,assign)BOOL isMe;
@property(nonatomic,strong)UserDetailModel *detailModel;
@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)UIButton *senderButton;

@property(nonatomic,copy)NSString *userKey;
@end

@implementation MyselfDetilUpdateViewController

-(id)initWithContent:(NSString *)content type:(NSString *)type userKey:(NSString*)userKey
{
    self = [super init];
    if (self) {
        selectIndex = 0;
        self.provinceArray = [[NSMutableArray alloc] init];
        self.cityArray = [[NSMutableArray alloc] init];
        self.detailModel = nil;
        self.content = content;
        self.type = type;
        self.isMe = NO;
        self.userKey = userKey;
        self.titleArray = [[NSArray alloc] initWithObjects:@"更改昵称",@"更改个性签名",@"更改地区",@"更改年龄", nil];
        [self initRightBarButtonItem];
    }
    return self;
}

-(id)initWithContent:(NSString *)content type:(NSString *)type isMe:(BOOL)isMe detailModel:(UserDetailModel*)detailModel block:(CallBack)block
{
    self = [super init];
    if (self) {
        selectIndex = 0;
        self.provinceArray = [[NSMutableArray alloc] init];
        self.cityArray = [[NSMutableArray alloc] init];
        self.detailModel = detailModel;
        callBack = block;
        self.content = content;
        self.type = type;
        self.isMe = isMe;
        self.userKey = nil;
        self.titleArray = [[NSArray alloc] initWithObjects:@"更改昵称",@"更改个性签名",@"更改地区",@"更改年龄", nil];
        [self initRightBarButtonItem];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self setTitle:[self.titleArray objectAtIndex:[self.type intValue]] andShowButton:YES];
    
    if ([self.type isEqualToString:@"2"]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Provineces" ofType:@"plist"];
        NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *dict in dataArray) {
            [self.provinceArray addObject:[dict objectForKey:@"ProvinceName"]];
            NSMutableArray *cicty = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in [dict objectForKey:@"cities"]) {
                [cicty addObject:[dic objectForKey:@"CityName"]];
            }
            [self.cityArray addObject:cicty];
        }
        self.province = [self.provinceArray objectAtIndex:0];
        self.city = [[self.cityArray objectAtIndex:0] objectAtIndex:0];
        [self initTableViews];
        
        NSArray *contentArray = [self.content componentsSeparatedByString:@" "];
        if ([contentArray count]==1) {
            for (int i=0; i<[self.provinceArray count]; i++) {
                NSString *province = [self.provinceArray objectAtIndex:i];
                if ([province isEqualToString:(NSString*)[contentArray lastObject]]) {
                    selectIndex = i;
                    [self.rightTableView reloadData];
                    self.province = province;
                    
                    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionMiddle];
                    [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionMiddle];
                    break;
                }
            }
        }else if ([contentArray count]==2) {
            for (int i=0; i<[self.provinceArray count]; i++) {
                NSString *province = [self.provinceArray objectAtIndex:i];
                if ([province isEqualToString:(NSString*)[contentArray firstObject]]) {
                    selectIndex = i;
                    [self.rightTableView reloadData];
                    self.province = province;
                    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionMiddle];
                    break;
                }
            }
            for (int i=0; i<[[self.cityArray objectAtIndex:selectIndex] count]; i++) {
                NSString *city = [[self.cityArray objectAtIndex:selectIndex] objectAtIndex:i];
                if ([city isEqualToString:(NSString*)[contentArray lastObject]]) {
                    [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionMiddle];
                    break;
                }
            }
        }
    }else{
        [self initTextField];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化发送按钮
 */
- (void)initRightBarButtonItem
{
    self.senderButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 7, 45, 30)];
    [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_normal"] forState:UIControlStateNormal];
    [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_press1"] forState:UIControlStateHighlighted];
    [self.senderButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.senderButton.tag = 0;
    [self.view addSubview:self.senderButton];
    if ([self.type isEqualToString:@"2"]) {
//        [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_press"] forState:UIControlStateNormal];
        self.senderButton.enabled = NO;
    }else{
        self.senderButton.enabled = NO;
    }
}
/**
 *  初始化文本框
 */
- (void)initTextField
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 60, 322, 41)];
    backgroundView.image =[UIImage imageNamed:@"myinformation_table"];
    [self.view addSubview:backgroundView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 305, 41)];
    self.textField.backgroundColor = [UIColor clearColor];
//    self.textField.background = [UIImage imageNamed:@"myinformation_table"];
//    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySend;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.text = self.content;
    if ([self.type isEqualToString:@"3"]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
}
#pragma mark UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self.type isEqualToString:@"3"]) {
        if (textField.text.length==0) {
            if ([string length]>0) {
                unichar single=[string characterAtIndex:0];//当前输入的字符
                if (single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:INTNUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        return canChange;
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_press"] forState:UIControlStateNormal];
    self.senderButton.enabled = YES;
    return YES;
}
/**
 *  按下回车键事件
 *
 *  @param textField
 *
 *  @return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    [self submitData];
    return YES;
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    [self.textField resignFirstResponder];
    [self submitData];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}
/**
 *  提交数据
 */
- (void)submitData
{
    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([self.type isEqualToString:@"0"]) {//修改昵称
        [param setObject:@"fullName" forKey:@"item"];
        [param setObject:[self.textField text] forKey:@"fullName"];
    }else if ([self.type isEqualToString:@"1"]){//修改个性签名
        [param setObject:@"sign" forKey:@"item"];
        [param setObject:[self.textField text] forKey:@"sign"];
    }else if ([self.type isEqualToString:@"2"]){//修改地区
        [param setObject:@"area" forKey:@"item"];
        if ([self.province isEqualToString:self.city]) {
            [param setObject:self.province forKey:@"area"];
        }else{
            [param setObject:[NSString stringWithFormat:@"%@ %@",self.province,self.city] forKey:@"area"];
        }
//        [param setObject:[self.textField text] forKey:@"area"];
    }else if ([self.type isEqualToString:@"3"]) {//修改年龄
        [param setObject:@"age" forKey:@"item"];
        [param setObject:[self.textField text] forKey:@"age"];
    }
    if ([self.userKey isEqualToString:@""] || self.userKey ==nil) {
        [param setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    }else{
        [param setObject:self.userKey forKey:@"l_key"];
    }
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init ];
    }
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:param];
    [queue addOperation :operation];
}

-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    
    [self stopLoading];
    UserModel *userModel = nil;
    if (self.isMe) {
        userModel = [AppDelegate sharedAppDelegate].userModel;
    };
    
    NSString *string = [data objectForKey:@"obj"];
    if (self.blockBack) {
        self.blockBack(string);
    }
    if ([self.type isEqualToString:@"0"]) {
#ifdef IMPORT_LETUIM_H
        [[LeTuIM sharedInstance] setMyLeTuAccountNeedUpdate:YES];
#endif
        self.detailModel.fullName = string;
        userModel.fullName = string;
        [[[[iToast makeText:@"更改昵称成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        if (callBack) {
            callBack(self.detailModel);
        }
    }else if ([self.type isEqualToString:@"1"]){
#ifdef IMPORT_LETUIM_H
        [[LeTuIM sharedInstance] setMyLeTuAccountNeedUpdate:YES];
#endif
        self.detailModel.sign = string;
        userModel.sign = string;
        [[[[iToast makeText:@"更改个性签名成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        if (callBack) {
            callBack(self.detailModel);
        }
    }else if ([self.type isEqualToString:@"2"]){
#ifdef IMPORT_LETUIM_H
        [[LeTuIM sharedInstance] setMyLeTuAccountNeedUpdate:YES];
#endif
        self.detailModel.area = string;
        userModel.area = string;
        [[[[iToast makeText:@"更改地区成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        if (callBack) {
            callBack(self.detailModel);
        }
    }else if ([self.type isEqualToString:@"3"]){
#ifdef IMPORT_LETUIM_H
        [[LeTuIM sharedInstance] setMyLeTuAccountNeedUpdate:YES];
#endif
        self.detailModel.age = string;
        userModel.age = string;
        if (callBack) {
            callBack(self.detailModel);
        }
        [self messageToast:@"更改年龄成功"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  初始化tableView
 */
-(void)initTableViews
{
    int height = [UIScreen mainScreen].bounds.size.height - STATUSBAR_HEIGHT -NAVBAR_HEIGHT;
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, 140, height) style:UITableViewStylePlain];
    self.leftTableView.backgroundColor = [UIColor clearColor];
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.leftTableView.tag = 1;
    [self.view addSubview:self.leftTableView];
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(140, NAVBAR_HEIGHT,180, height) style:UITableViewStylePlain];
    self.rightTableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.rightTableView.showsVerticalScrollIndicator = NO;
    self.rightTableView.separatorColor = [UIColor clearColor];
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.tag = 2;
    [self.view addSubview:self.rightTableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return [self.provinceArray count];
    }else if (tableView.tag ==2){
        return [[self.cityArray objectAtIndex:selectIndex] count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    if (tableView.tag==1) {
        cell.textLabel.text = [self.provinceArray objectAtIndex:indexPath.row];
    }else if (tableView.tag == 2){
        NSArray *array = [self.cityArray objectAtIndex:selectIndex];
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==1) {
        [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_normal"] forState:UIControlStateNormal];
        self.senderButton.enabled = NO;
        selectIndex = indexPath.row;
        [self.rightTableView reloadData];
        self.province = [self.provinceArray objectAtIndex:indexPath.row];
    }else if (tableView.tag ==2){
        [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_press"] forState:UIControlStateNormal];
        self.senderButton.enabled = YES;
        self.city = [[self.cityArray objectAtIndex:selectIndex] objectAtIndex:indexPath.row];
    }
}
@end
