//
//  MapActivityViewController.m
//  LeTu
//
//  Created by DT on 14-6-13.
//
//

#import "MapActivityViewController.h"
#import "MapActivityCell.h"
#import "MapActivityModel.h"
#import "MapActivityDetailViewController.h"
#import "MapCreateActivityViewController.h"

@interface MapActivityViewController ()<UITableViewDelegate,UITableViewDataSource,MapActivityCellDelegate,UIAlertViewDelegate>
{
    NSOperationQueue *queue;
    BOOL _isShrink;
    UIButton *_isShrinkButton;
    int _currentActivity;
}
@property(nonatomic,strong)DTTableView *tableView;
@property(nonatomic,strong)NSMutableArray *myActivitiesArray;
@property(nonatomic,strong)NSMutableArray *nearbyActivitiesArray;
@property(nonatomic,assign)BOOL isRefresh;
@end

@implementation MapActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myActivitiesArray = [[NSMutableArray alloc] init];
    self.nearbyActivitiesArray = [[NSMutableArray alloc] init];
    _isShrink = NO;
    self.isRefresh = NO;
    
    [self setTitle:@"活动" andShowButton:YES];
    [self initRightBarButtonItem:[UIImage imageNamed:@"Creating_events_icon_normal"]
                highlightedImage:[UIImage imageNamed:@"Creating_events_icon_press"]];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self initTableView];
//    [self fillData];
}
- (void)clickRightButton:(UIButton *)button
{
    MapCreateActivityViewController *createVC = [[MapCreateActivityViewController alloc] init];
    [createVC setCallBack:^{
        [self fillData];
    }];
    [self.navigationController pushViewController:createVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  初始化tableView
 */
- (void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.tableView = [[DTTableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.rowHeight = 123;
    self.tableView.rowHeight = 116;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self CheckCacheData];
    WEAKSELF
    [self.tableView addHeaderWithTimekey:@"activityKey" Callback:^{
        [weakSelf fillData];
    }];
}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        view.backgroundColor = RGBCOLOR(239, 238, 244);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 3, 13)];
        imageView.image = [UIImage imageNamed:@"Creatingevents_line"];
        [view addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"我创建的活动";
        [view addSubview:label];
        
        _isShrinkButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 5.5, 25, 25)];
        if (!_isShrink) {
            [_isShrinkButton setImage:[UIImage imageNamed:@"Creatingevents_arrows_up"] forState:UIControlStateNormal];
        }else{
            [_isShrinkButton setImage:[UIImage imageNamed:@"Creatingevents_arrows"] forState:UIControlStateNormal];
        }
//        [_isShrinkButton setImage:[UIImage imageNamed:@"Creatingevents_arrows_up"] forState:UIControlStateNormal];
        [_isShrinkButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_isShrinkButton];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35.5, 320, 0.5)];
        lineLabel.backgroundColor = RGBCOLOR(220, 220, 220);
        [view addSubview:lineLabel];
        return view;
    }else if (section==1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        view.backgroundColor = RGBCOLOR(239, 238, 244);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 3, 13)];
        imageView.image = [UIImage imageNamed:@"Creatingevents_line"];
        [view addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"附近的活动";
        [view addSubview:label];
        return view;
    }
    return nil;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"我创建的活动";
    }else if (section==1){
        return @"附近的活动";
    }
    return nil;
}
 //*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (_isShrink) {
            return 0;
        }
        return [self.myActivitiesArray count];
    }else if (section==1){
        return [self.nearbyActivitiesArray count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell0";
    MapActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[MapActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section==0) {
        if (indexPath.row < [self.myActivitiesArray count]) {
            MapActivityModel *model = [self.myActivitiesArray objectAtIndex:indexPath.row];
            cell.model = model;
            cell.isMyActivity = YES;
            cell.delegate = self;
            cell.tag = indexPath.row;
        }
    }else if (indexPath.section==1){
        if (indexPath.row < [self.nearbyActivitiesArray count]) {
            MapActivityModel *model = [self.nearbyActivitiesArray objectAtIndex:indexPath.row];
            cell.model = model;
            cell.isMyActivity = NO;
        }
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        MapActivityModel *model = [self.myActivitiesArray objectAtIndex:indexPath.row];
        MapActivityDetailViewController *detailVC = [[MapActivityDetailViewController alloc] initWithActivityModel:model];
        [detailVC setCallBack:^{
            self.isRefresh = YES;
            [self fillData];
        }];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (indexPath.section==1){
        MapActivityModel *model = [self.nearbyActivitiesArray objectAtIndex:indexPath.row];
        MapActivityDetailViewController *detailVC = [[MapActivityDetailViewController alloc] initWithActivityModel:model];
        [detailVC setCallBack:^{
            self.isRefresh = YES;
            [self fillData];
        }];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
/**
 *  获取活动列表数据
 */
-(void)fillData
{
//    if (!self.isRefresh) {
//        [self startLoading];
//        self.tableView.hidden = YES;
//    }
     NSString *address = @"";
//    if (self.appDelegate.address != nil) {
//       address = [NSString stringWithString:[self.appDelegate.address stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    }
    if (self.appDelegate.locality != nil) {
        address = [NSString stringWithString:[self.appDelegate.locality stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@activity/activityService.jws?activityList", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:address forKey:@"address"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
    
//    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLString:requestUrl delegate:self];
//    operation.RequestTag = 1;
//    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag==1) {
//        [self stopLoading];
        NSDictionary *dict = [data objectForKey:@"list"];
        [UserDefaultsHelper setArrayForKey:[data objectForKey:@"list"] :@"activityList"];
        
        MapActivityModel *model = nil;
        UserModel *userModel = self.appDelegate.userModel;
        [self.myActivitiesArray removeAllObjects];
        [self.nearbyActivitiesArray removeAllObjects];
        for (NSDictionary *dic in dict) {
            model = [[MapActivityModel alloc]initWithDataDict:dic];
            if ([model.userId isEqualToString:userModel.userId]) {
                [self.myActivitiesArray addObject:model];
            }else{
                [self.nearbyActivitiesArray addObject:model];
            }
        }
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }else if (tag==2){//删除活动
        [self messageToast:@"活动删除成功"];
        [self.myActivitiesArray removeObjectAtIndex:_currentActivity];
        [self.tableView reloadData];
    }
}
-(void)clickButton:(UIButton*)button
{
    _isShrink = !_isShrink;
    [self.tableView reloadData];
}
#pragma mark MapActivityCellDelegate
- (void)activityCell:(MapActivityCell*)activityCell clickButtonAtIndex:(NSInteger)index
{
    if (index==1) {//修改
        
    }else if (index==2){//删除
        _currentActivity = activityCell.tag;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要删除当前活动吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        [alert show];
    }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {//确定
        MapActivityModel *model = [self.myActivitiesArray objectAtIndex:_currentActivity];
        [self deleteActicity:model.mId];
    }else if (buttonIndex==1){//取消
        
    }
}
/**
 *  删除活动
 *
 *  @param acticityId 活动Id
 */
-(void)deleteActicity:(NSString*)acticityId
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@activity/activityService.jws?cancelActivity", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:acticityId forKey:@"id"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}

/**
 *  检查缓存数据
 */
-(void)CheckCacheData
{
    NSArray *objDict = [UserDefaultsHelper getArrayForKey:@"activityList"];
    if (objDict !=nil) {//表示有缓存数据
        
        MapActivityModel *model = nil;
        UserModel *userModel = self.appDelegate.userModel;
        [self.myActivitiesArray removeAllObjects];
        [self.nearbyActivitiesArray removeAllObjects];
        for (NSDictionary *dic in objDict) {
            model = [[MapActivityModel alloc]initWithDataDict:dic];
            if ([model.userId isEqualToString:userModel.userId]) {
                [self.myActivitiesArray addObject:model];
            }else{
                [self.nearbyActivitiesArray addObject:model];
            }
        }
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else{
        [self fillData];
    }
}
@end
