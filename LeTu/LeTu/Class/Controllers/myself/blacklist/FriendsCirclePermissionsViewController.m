//
//  FriendsCirclePermissionsViewController.m
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import "FriendsCirclePermissionsViewController.h"
#import "KLSwitch.h"

@interface FriendsCirclePermissionsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSOperationQueue *queue;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)KLSwitch *switchButton;
@end

@implementation FriendsCirclePermissionsViewController

- (id)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"设置朋友圈权限" andShowButton:YES];
//    [self initRightBarButtonItem:[UIImage imageNamed:@"Blacklist_finish_btn_current"]
//                highlightedImage:[UIImage imageNamed:@"Blacklist_finish_btn_press"]];
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//-(void)clickRightButton:(UIButton *)button
//{
//    if ([self.switchButton isOn]) {
//        NSLog(@"on");
//    }else{
//        NSLog(@"off");
//    }
//}
/**
 *  初始化tableView
 */
-(void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.rowHeight = 115;
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    self.switchButton = [[KLSwitch alloc] initWithFrame:CGRectMake(FRAME_WIDTH - 60, 25, 45, 30)
                                       didChangeHandler:^(BOOL isOn) {
                                           [self updateBlcaklist];
                                       }];
    [self.switchButton setOn:YES animated:YES];
    self.switchButton.backgroundColor = [UIColor clearColor];
    self.switchButton.contrastColor = RGBCOLOR(255, 255, 255);
    self.switchButton.onTintColor = RGBCOLOR(41, 159, 249);
    [cell addSubview:self.switchButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 250, 40)];
    titleLabel.font = [UIFont systemFontOfSize:20.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"不让他(她)看我的朋友圈";
    [cell addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 290, 40)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:16.0f];
    detailLabel.numberOfLines = 2;
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.text = @"打开后,你在朋友圈发的照片,对方将无法看到";
    [cell addSubview:detailLabel];
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 114.5, 320, 0.5)];
    lineLabel.backgroundColor = RGBCOLOR(218, 218, 218);
    [cell addSubview:lineLabel];
    return cell;
}
/**
 *  更新朋友圈黑名单
 *
 *  @param button
 */
-(void)updateBlcaklist
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?updateWeiboBlack",SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:self.userId forKey:@"userId"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{

}

@end
