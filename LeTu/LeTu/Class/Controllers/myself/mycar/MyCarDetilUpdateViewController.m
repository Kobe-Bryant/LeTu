//
//  MyCarDetilUpdateViewController.m
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "MyCarDetilUpdateViewController.h"

@interface MyCarDetilUpdateViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CallBack callBack;
    NSOperationQueue *queue;
}
@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;

@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIButton *senderButton;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,assign)BOOL isList;

@property(nonatomic,strong)NSMutableArray *brandArray;
@property(nonatomic,strong)NSMutableArray *carArray;

@property(nonatomic,copy)NSString *carName;
@property(nonatomic,strong)NSDictionary *dictBrand;
@end

@implementation MyCarDetilUpdateViewController

-(id)initWithBrandAndblock:(CallBack)block
{
    self = [super init];
    if (self) {
        callBack = block;
        self.isList = YES;
    }
    return self;
}
-(id)initWithContent:(NSString *)content title:(NSString *)title block:(CallBack)block
{
    self = [super init];
    if (self) {
        callBack = block;
        self.content = content;
        self.titleName = title;
        self.isList = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    self.carName = @"";
    
    [self setTitle:self.titleName andShowButton:YES];
    [self initRightBarButtonItem];
    self.brandArray = [[NSMutableArray alloc] init];
    self.carArray = [[NSMutableArray alloc] init];
    
    if (self.isList) {
        self.title = @"修改车型";
        [self initTableViews];
        [self getBrandList];
        self.senderButton.enabled = NO;
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
    [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_press"] forState:UIControlStateNormal];
    [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_press1"] forState:UIControlStateHighlighted];
    [self.senderButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.senderButton.tag = 0;
    [self.view addSubview:self.senderButton];
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
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    [self.textField resignFirstResponder];
    if (self.isList) {
        if (callBack) {
            callBack(self.carName,[self.dictBrand objectForKey:@"id"]);
        }
    }else{
        if (callBack) {
            callBack(self.textField.text,@"");
        }
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
    self.leftTableView.backgroundColor = RGBCOLOR(239, 238, 244);
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==1) {
        return [self.brandArray count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
//        return [[self.brandArray objectAtIndex:section] count];
        return [[[self.brandArray objectAtIndex:section] objectForKey:@"data"] count];
    }else if (tableView.tag ==2){
        return [self.carArray count];
    }
    return 0;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return [[self.brandArray objectAtIndex:section] objectForKey:@"indexTitle"];
    }
    return @"";
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
//        NSDictionary *dict = [[self.brandArray objectAtIndex:indexPath.section] objectForKey:@"data"];
//        cell.textLabel.text = [dict objectForKey:@"name"];
//        cell.textLabel.text = [dict[indexPath.row] objectForKey:@"name"];
        cell.textLabel.text = [self.brandArray[indexPath.section][@"data"][indexPath.row]objectForKey:@"name"];
//        self.dictBrand = self.brandArray[indexPath.section][@"data"][indexPath.row];
    }else if (tableView.tag == 2){
        NSDictionary *dict = [self.carArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict objectForKey:@"name"];
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==1) {
        self.senderButton.enabled = NO;
        self.dictBrand = self.brandArray[indexPath.section][@"data"][indexPath.row];
//        NSDictionary *dict = [self.brandArray objectAtIndex:indexPath.row];
        [self getCarList:[self.dictBrand objectForKey:@"id"]];
    }else if (tableView.tag ==2){
        self.senderButton.enabled = YES;
        if (indexPath.row < [self.carArray count]) {
            NSDictionary *dict = [self.carArray objectAtIndex:indexPath.row];
            self.carName = [dict objectForKey:@"name"];
        }
    }
}
/**
 *  获取品牌列表
 */
-(void)getBrandList
{
    self.leftTableView.hidden = YES;
    self.rightTableView.hidden = YES;
    [self startLoading];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar/myCarService.jws?brandList", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    self.leftTableView.hidden = NO;
    self.rightTableView.hidden = NO;
    [self stopLoading];
    
    if (tag==1) {
        NSDictionary *dict = [data objectForKey:@"list"];
        [self.brandArray removeAllObjects];
        for (NSDictionary *dic in dict) {
            [self.brandArray addObject:dic];
            [self.leftTableView reloadData];
        }
    }else if (tag==2){
        NSDictionary *dict = [data objectForKey:@"list"];
        [self.carArray removeAllObjects];
        for (NSDictionary *dic in dict) {
            [self.carArray addObject:dic];
            [self.rightTableView reloadData];
        }
    }
}
/**
 *  获取汽车列表
 *
 *  @param brandId 品牌id
 */
-(void)getCarList:(NSString*)brandId
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar/myCarService.jws?carList", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:brandId forKey:@"brandId"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}

@end
