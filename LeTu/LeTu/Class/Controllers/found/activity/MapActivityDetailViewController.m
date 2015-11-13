//
//  MapActivityDetailViewController.m
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import "MapActivityDetailViewController.h"
#import "MapActivityDetailHeaderView.h"
#import "DetailCommentCell.h"
#import "MapApplyActivityViewController.h"
#import "MapActivityPeoplesViewController.h"
#import "MapActivityApplysModel.h"
#import "MapActivityMessageModel.h"

@interface MapActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)MapActivityDetailHeaderView *tableHeaderView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MapActivityModel *model;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,assign)BOOL isMe;
@end

@implementation MapActivityDetailViewController


-(id)initWithActivityModel:(MapActivityModel *)model;
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.model.userId isEqualToString:self.appDelegate.userModel.userId]) {
        self.isMe = YES;
    }else{
        self.isMe = NO;
    }
    
    [self setTitle:@"活动详情" andShowButton:YES];
    [self getActivityDetails];
    [self initTableView];
    [self initBottomButton];
//    [self fillData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化底部按钮
 */
-(void)initBottomButton
{
    int y = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-37;
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0,y, 320, 38)];
    [self.button setImage:[UIImage imageNamed:@"activity_detial_fuceng"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}
-(void)clickButton:(UIButton*)button
{
    MapApplyActivityViewController *applyVC = [[MapApplyActivityViewController alloc] initWithActivityId:self.model.mId];
    [self.navigationController pushViewController:applyVC animated:YES];
    [applyVC setCallBack:^{
        [self getActivityDetails];
    }];
}
/**
 *  初始化tableView
 */
- (void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.rowHeight = 60;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
    
    self.tableHeaderView = [[MapActivityDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 270+50)];
    self.tableHeaderView.model = self.model;
    self.tableHeaderView.joinButton.hidden = self.isMe;
    self.tableView.tableHeaderView = self.tableHeaderView;
    WEAKSELF
    [self.tableHeaderView setCallBack:^(int type) {
        if (type==1) {//查看活动人数
            MapActivityPeoplesViewController *peoplesVC = [[MapActivityPeoplesViewController alloc] initWithActivityAppls:weakSelf.model.activityApplys];
            [weakSelf.navigationController pushViewController:peoplesVC animated:YES];
        }else if (type==2){//参加活动
//            weakSelf.model.apply = @"1";
//            weakSelf.tableHeaderView.model = weakSelf.model;
            [weakSelf signupActivity];
        }
    }];
    
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.model.messages isKindOfClass:[NSString class]]) {
        return 0;
    }
    return [self.model.messages count];
//    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[DetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%i",indexPath.row];
    MapActivityMessageModel *model = [self.model.messages objectAtIndex:indexPath.row];
    cell.messageModel = model;
    return cell;
    
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCommentCell *cell = (DetailCommentCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  获取活动列表数据
 */
-(void)fillData
{
    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@activity/activityService.jws?activityDetail", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:@"" forKey:@"id"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag==1) {
        [self stopLoading];
//        NSDictionary *dict = [data objectForKey:@"list"];
    }else if (tag==2) {
        if (self.callBack) {
            self.callBack();
        }
        [self messageToast:@"参加活动成功"];
        self.model.apply = @"1";
        self.tableHeaderView.model = self.model;
    }else if (tag==3) {
        NSDictionary *dict = [data objectForKey:@"obj"];
        NSString *apply = [dict objectForKey:@"apply"];
        self.model.apply = apply;
        self.tableHeaderView.model = self.model;
        self.model.activityApplys = [[NSMutableArray alloc] init];
        
        //默认增加活动创建者
        MapActivityApplysModel *applysModel = [[MapActivityApplysModel alloc] init];
        applysModel.userGender = [dict objectForKey:@"userGender"];
        applysModel.userId = [dict objectForKey:@"userId"];
        applysModel.userName = [dict objectForKey:@"userName"];
        applysModel.userPhoto = [dict objectForKey:@"userPhoto"];
        [self.model.activityApplys addObject:applysModel];
        
        for (NSDictionary *apply in [dict objectForKey:@"activityApplys"]) {
            [self.model.activityApplys addObject:[[MapActivityApplysModel alloc] initWithDataDict:apply]];
        }
        self.model.messages = [[NSMutableArray alloc] init];
        for (NSDictionary *message in [dict objectForKey:@"messages"]) {
            MapActivityMessageModel *messageModel = [[MapActivityMessageModel alloc] initWithDataDict:message];
            messageModel.activityLatitude = self.model.latitudeActivity;
            messageModel.activityLongitude = self.model.longitudeActivity;
            messageModel.activityId = [message objectForKey:@"id"];
            [self.model.messages addObject:messageModel];
            [self.tableView reloadData];
        }
//        NSLog(@"...");
    }
}
/**
 *  报名活动
 */
-(void)signupActivity
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@activity/activityService.jws?join", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:self.model.mId forKey:@"id"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
/**
 *  获取活动详情
 */
-(void)getActivityDetails
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@activity/activityService.jws?activityDetail", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:self.model.mId forKey:@"id"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 3;
    [queue addOperation :operation];
}
@end
