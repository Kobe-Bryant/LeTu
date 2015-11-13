//
//  MapCarShareDetailViewController.m
//  LeTu
//
//  Created by DT on 14-5-16.
//
//

#import "MapCarShareDetailViewController.h"
#import "MapDetailTableHeaderView.h"
#import "MyselfDetailCell.h"
#import "MapCarpoolHomeController.h"
#import "MapCarSharingDetailModel.h"
#import "MyselfDetailViewController.h"
#import "MapAnnotationViewController.h"
#import "ChatViewController.h"

@interface MapCarShareDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,MapDetailTableHeaderViewDelegate>
{
    NSOperationQueue *queue;
#ifdef IMPORT_LETUIM_H
    NSString *_loginName;
#endif
}
@property(nonatomic,strong)TableView *tableView;
@property(nonatomic,strong)MapDetailTableHeaderView *tableHeaderView;
@property(nonatomic,strong)UIView *tableFootView;

@property(nonatomic,strong)MapCarSharingModel *userModel;
@property(nonatomic,strong)MapCarSharingDetailModel *model;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,assign)BOOL isMe;

//是否车主
@property(nonatomic,assign)BOOL isDriver;
@end

@implementation MapCarShareDetailViewController

- (id)initWithModel:(MapCarSharingModel *)model
{
    self = [super init];
    if (self) {
        self.isDriver = YES;
        self.userModel = model;
        self.isMe = NO;
        self.status = 1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self setTitle:self.userModel.userName andShowButton:YES];
    if (self.status==1) {
        [self setRightBarButtonItem:@"收藏"];
    }else if (self.status==2) {
        [self setRightBarButtonItem:@"取消收藏"];
    }
    
    UserModel *userModel = self.appDelegate.userModel;
    if ([self.userModel.userId isEqualToString:userModel.userId]) {
        self.isMe = YES;
    }
    [self initTableView];
    [self fillData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIButton*)setRightBarButtonItem:(NSString*)title
{
    int width = 0;
    if (self.status==1) {
        width = 40;
    }else if (self.status==2) {
        width = 60;
    }
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-width-10, 7, width, 30)];
    [backButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:title forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [backButton setTitleColor:RGBCOLOR(61, 177, 248) forState:UIControlStateNormal];
    [backButton setTitleColor:RGBCOLOR(4, 141, 225) forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
    return backButton;
}
- (void)clickRightButton:(UIButton *)button
{
    if (self.status==1) {
        [self FavoriteCarpool:@"1"];
    }else if (self.status==2) {
        [self FavoriteCarpool:@"0"];
    }
}
/**
 *  初始化tableFootView
 */
- (void)initTableFootView
{
    self.tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 60)];
    self.tableFootView.backgroundColor = [UIColor clearColor];
    UIButton *button = nil;
    button = [[UIButton alloc] initWithFrame:CGRectMake(7, 13, 95, 34)];
    [button setImage:[UIImage imageNamed:@"loaction_item_btn_send_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"loaction_item_btn_send_press"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1;
    [self.tableFootView addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(110, 13, 95, 34)];
    [button setImage:[UIImage imageNamed:@"loaction_item_btn_car_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"loaction_item_btn_car_press"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 2;
    [self.tableFootView addSubview:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(215, 13, 95, 34)];
    [button setImage:[UIImage imageNamed:@"loaction_item_btn_lahei_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"loaction_item_btn_lahei_press"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 3;
    [self.tableFootView addSubview:button];
}
/**
 *  按钮点击事件
 *
 *  @param button
 */
-(void)clickButton:(UIButton*)button
{
    if (button.tag == 1)
    {//发送消息按钮
        ChatViewController *chatVC = [[ChatViewController alloc]init];
        chatVC.titleString = self.userModel.userName;
        chatVC.targetType = @"1";
#ifdef IMPORT_LETUIM_H
        chatVC.chatWith = _loginName;
#endif
        chatVC.targetId = self.userModel.userId;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else if (button.tag ==2){//我要拼车按钮
//        MapCarpoolHomeController *carpoolVC = [[MapCarpoolHomeController alloc] init];
//        [self.navigationController pushViewController:carpoolVC animated:YES];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否发起拼车请求！"
                                                     delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        [alert show];
    }else if (button.tag ==3){//拉黑举报按钮
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"拉黑"
                                                            otherButtonTitles:@"骚扰消息",@"色情相关",@"资料不当",@"盗用他人资料",@"垃圾广告", nil];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {//确定
//        NSLog(@"queding");
        [self sendCarpoolRequest];
    }else if (buttonIndex ==1){//取消
//        NSLog(@"quxiao..");
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex !=6) {//取消
        self.type = [NSString stringWithFormat:@"%i",buttonIndex];
        [self sendReportRequest:self.type];
    }
}
/**
 *  初始化tableView
 */
- (void)initTableView
{
//    self.tableHeaderView = [[MapDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 104) block:^{
//        NSLog(@"helllo........");
//        MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] initWithTitle:self.userModel.userName userId:self.userModel.userId userKey:@""];
//        [self.navigationController pushViewController:detailVC animated:YES];
//    }];
    self.tableHeaderView = [[MapDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 104)];
    self.tableHeaderView.delegate = self;
    self.tableHeaderView.model = self.userModel;
    if (!self.isMe) {
        self.tableHeaderView.collectButton.hidden = NO;
        [self initTableFootView];
    }
    
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFootView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isDriver) {
        return 5;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[MyselfDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, 320, 0.5)];
//        label.backgroundColor = RGBACOLOR(210, 210, 210, 1);
//        [cell addSubview:label];
    }
    MyselfDetailCell *detailCell = (MyselfDetailCell*)cell;
    detailCell.keyLabel.textColor = [UIColor blackColor];
    detailCell.valueLabel.textColor = [UIColor grayColor];
//    detailCell.lineImage.hidden = YES;
    detailCell.arrowHide = YES;
    if (indexPath.row==0) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        detailCell.arrowHide = NO;
        detailCell.key = @"出发地";
        detailCell.value = self.model.routeStart;
//        detailCell.value = @"广州市体育中心128号";
    }else if (indexPath.row==1){
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        detailCell.arrowHide = NO;
        detailCell.key = @"目的地";
        detailCell.value = self.model.routeEnd;
//        detailCell.value = @"深圳市南山区南光路";
    }else if (indexPath.row==2){
        detailCell.key = @"时间";
        detailCell.value = self.model.startTime;
//        detailCell.value = @"2014-05-16 12:22";
    }else if (indexPath.row==3){
        detailCell.key = @"人数";
        detailCell.value = self.model.seating;
//        detailCell.value = @"5人";
    }else if (indexPath.row==4){
        detailCell.key = @"金额";
        detailCell.value = self.model.fee;
//        detailCell.value = @"100元";
    }else if (indexPath.row==5){
        detailCell.key = @"支付方式";
        if ([self.model.payType intValue] ==1) {
            detailCell.value = @"在线支付";
        }else if ([self.model.payType intValue] ==2){
            detailCell.value = @"线下支付";
        }
//        detailCell.value = @"在线支付";
    }
    return detailCell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0) {//出发地
        NSDictionary *currentLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                         self.model.routeStart,@"route",
                                         self.userModel.longitudeStart,@"latitude",
                                         self.userModel.latitudeStart,@"longitude",nil];
        
        NSDictionary *otherLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                         self.model.routeEnd,@"route",
                                         self.userModel.longitudeEnd,@"latitude",
                                         self.userModel.latitudeEnd,@"longitude",nil];
        
        MapAnnotationViewController *annotationVC = [[MapAnnotationViewController alloc] initWithTitle:@"出发地" currentLocation:currentLocation otherLocation:otherLocation];
        [self.navigationController pushViewController:annotationVC animated:YES];
    }else if (indexPath.row ==1){//目的地
        NSDictionary *otherLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                         self.model.routeStart,@"route",
                                         self.userModel.longitudeStart,@"latitude",
                                         self.userModel.latitudeStart,@"longitude",nil];
        
        NSDictionary *currentLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                       self.model.routeEnd,@"route",
                                       self.userModel.longitudeEnd,@"latitude",
                                       self.userModel.latitudeEnd,@"longitude",nil];
        
        MapAnnotationViewController *annotationVC = [[MapAnnotationViewController alloc] initWithTitle:@"目的地" currentLocation:currentLocation otherLocation:otherLocation];
        [self.navigationController pushViewController:annotationVC animated:YES];
    }
}
/**
 *  填充数据
 */
- (void)fillData
{
    [self startLoading];
    self.tableView.hidden = YES;
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?get",SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.userModel.mId forKey:@"id"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag==1) {
        NSDictionary *objDict = [data objectForKey:@"obj"];
#ifdef IMPORT_LETUIM_H
        //        if ([objDict isKindOfClass:[NSDictionary class]])
        _loginName = objDict[@"loginName"];
#endif
        self.model = [[MapCarSharingDetailModel alloc] initWithDataDict:objDict];
        [self stopLoading];
        self.tableView.hidden = NO;
        if ([self.model.userType intValue]==1) {
            self.isDriver = YES;
        }else if ([self.model.userType intValue]==2) {
            self.isDriver = NO;
        }
        [self BlogOverheadData];
        [self.tableView reloadData];
    }else if (tag ==2){//发送拼车请求
        [self messageToast:@"发起拼车请求成功"];
    }else if (tag ==3){//拉黑举报
        if ([self.type isEqualToString:@"0"]) {
            [self messageToast:@"拉黑成功"];
        }else{
            [self messageToast:@"举报成功"];
        }
    }else if (tag==4) {
        if (self.status==1) {
            [self messageToast:@"收藏拼车成功"];
        }else if (self.status==2) {
            [self messageToast:@"取消收藏拼车成功"];
        }
    }else if (tag==5) {
        NSDictionary *objDict = [data objectForKey:@"obj"];
        NSString *hbgPhoto = [objDict objectForKey:@"hbgPhoto"];
        [self.tableHeaderView.bgImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,hbgPhoto]] placeholderImage:[UIImage imageNamed:@"loaction_item_bg"]];
    }
}
/**
 *  发送拼车请求
 */
- (void)sendCarpoolRequest
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?apply",SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.model.mId forKey:@"id"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
/**
 *  拉黑举报请求
 *
 *  @param type 类型 空值:拉黑 1:骚扰消息 2:色情相关 3:资料不当 4:盗用他人资料 5:垃圾广告
 */
-(void)sendReportRequest:(NSString *)type
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?report",SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    if (![type isEqualToString:@"0"]) {//举报
        [paramDict setObject:type forKey:@"reportType"];
    }
    [paramDict setObject:self.model.userId forKey:@"userId"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 3;
    [queue addOperation :operation];
}
-(void)mapDetailHeaderView:(MapDetailTableHeaderView *)mapDetailHeaderView didClickAtIndex:(NSInteger)index
{
    if (index==1) {//头像
        MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] initWithTitle:self.userModel.userName userId:self.userModel.userId userKey:@""];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (index==2){//收藏
        [self FavoriteCarpool:@"1"];
    }
}


/**
 *  收藏/取消拼车
 *
 *  @param action 收藏类型 1:收藏 0:取消
 */
-(void)FavoriteCarpool:(NSString*)action
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?favorite",SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:self.model.mId forKey:@"id"];
    [paramDict setObject:action forKey:@"action"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 4;
    [queue addOperation :operation];
}
/**
 *  微博列表顶置数据
 */
- (void)BlogOverheadData
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?get", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:self.model.userId forKey:@"userId"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 5;
    [queue addOperation :operation];
}
@end
