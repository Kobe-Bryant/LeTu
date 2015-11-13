//
//  MapSearchLocationViewController.m
//  LeTu
//
//  Created by DT on 14-7-2.
//
//

#import "MapSearchLocationViewController.h"

@interface MapSearchLocationViewController()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,BMKSearchDelegate>

@property(nonatomic,strong)BMKSearch *search;

@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)DTTableView *tableView;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,assign)int type;
@end

@implementation MapSearchLocationViewController

-(id)initWithSearchType:(int)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self iniNavigationController];
    
    self.search = [[BMKSearch alloc] init];
    self.search.delegate = self;
    
    [self initTabelView];
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
/**
 *  初始化导航栏
 */
-(void)iniNavigationController
{
    UIImage *topBar = [UIImage imageNamed:@"letu_navbtn_bg"];
    UIImageView *topBarImageView = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(0, 0, topBar.size.width, topBar.size.height)];
    topBarImageView.image = topBar;
    topBarImageView.userInteractionEnabled = YES;
    [self.view addSubview:topBarImageView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 7, 275, 30)];
    searchImageView.image = [UIImage imageNamed:@"search_blank"];
    searchImageView.userInteractionEnabled = YES;
    [topBarImageView addSubview:searchImageView];
    
    UIImage *normal = [UIImage imageNamed:@"common_topbar_back_btn_normal"];
    UIImage *highlighted = [UIImage imageNamed:@"common_topbar_back_btn_press"];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-8, 0, 44, 44);
    [backBtn setImage:normal forState:UIControlStateNormal];
    [backBtn setImage:highlighted forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, 240, 30)];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.font = [UIFont systemFontOfSize:15.0f];
    self.textField.text = self.adress;
    self.textField.placeholder = @"请输入地址";
    self.textField.delegate = self;
    
    [searchImageView addSubview:self.textField];

    if (self.adress!=nil) {
        [self searchLocation:self.adress];
    }
}
- (void) backPressed:(id) sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

/**
 *  初始化tabelView
 */
-(void)initTabelView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.tableView = [[DTTableView alloc] initWithFrame:CGRectMake(0, 44, FRAME_WIDTH, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.separatorColor = RGBACOLOR(229, 229, 229, 0.5);
    self.tableView.rowHeight = 50;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.pageNumber = 0;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView addFooterWithCallback:^{
        [weakSelf searchLocation:weakSelf.address];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.textField resignFirstResponder];
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
    if (![self.textField.text isEqualToString:@""]) {
        self.address = self.textField.text;
        self.tableView.pageNumber = 0;
        [self searchLocation:self.address];
    }
    return YES;
}
/**
 *  填充数据
 *  调用的是百度地图Place API
 */
- (void)searchLocation:(NSString*)address
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?ak=%@&output=json&query=%@&page_size=20&page_num=%i&scope=1&region=%@",
                            SERVERAK,
                            [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            self.tableView.pageNumber,
                            [[AppDelegate sharedAppDelegate].locality stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    
    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:120];
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *error = [request error];
    if (!error){
        //发送消息
        if (request.tag==888){
            JSONDecoder *decoder=[JSONDecoder decoder];
            NSDictionary *dict=[decoder objectWithData:request.responseData];
            NSString *jsonString = [dict JSONString];
            
            NSDictionary * root = [jsonString objectFromJSONString];
            NSArray *entries = [root objectForKey:@"results"];
            
            if (self.tableView.pageNumber==0) {
                [self.tableView addFirstArray:[NSMutableArray arrayWithArray:entries]];
                self.tableView.pageNumber++;
                self.tableView.hidden = NO;
            }else{
                if ([entries count]==0) {
                    [self.tableView footerEndRefreshing];
                }else{
                    [self.tableView addMoreArray:[NSMutableArray arrayWithArray:entries]];
                    self.tableView.pageNumber++;
                    [self.tableView footerEndRefreshing];
                }
            }
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (request.tag==888){
        [self messageShow:@"网络繁忙，请稍后在试！"];
//        self.sureButton.enabled = YES;
    }
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableView.tableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary* entry = [self.tableView.tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [entry objectForKey:@"name"];
    cell.detailTextLabel.text = [entry objectForKey:@"address"];
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* entry = [self.tableView.tableArray objectAtIndex:indexPath.row];
    NSDictionary *location = [entry objectForKey:@"location"];
    
    [self startLoading];
    
    [self.search reverseGeocode:CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue],
                                                           [[location objectForKey:@"lng"] floatValue])];
    
//    if (self.callBack) {
//        self.callBack([[location objectForKey:@"lat"] floatValue],[[location objectForKey:@"lng"] floatValue],[entry objectForKey:@"address"]);
//    }
//    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - BMKSearchDelegate
//返回地址信息搜索结果
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        [self stopLoading];
        
        if (self.callBack) {
            self.callBack(result.geoPt.latitude,result.geoPt.longitude,result.strAddr);
        }
        [self dismissModalViewControllerAnimated:YES];
	}
}

@end
