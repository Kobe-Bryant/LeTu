//
//  MyselfSignedViewController.m
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import "MyselfSignedViewController.h"
#import "MyselfSignedCell.h"
#import "MapMyselfSignedModel.h"
#import "MyselfApplysModel.h"
#import "MyselfDetailViewController.h"
#import "MapAnnotationViewController.h"
#import "DTTableView.h"

@interface MyselfSignedViewController ()<UITableViewDataSource,UITableViewDelegate,MyselfSignedCellDelegate,UIAlertViewDelegate>
{
    NSOperationQueue *queue;
    int row;
}
@property(nonatomic,strong)DTTableView *tableView;
@property(nonatomic,assign)int type;

@property(nonatomic,copy)NSString *timekey;

@end

@implementation MyselfSignedViewController

-(id)initWithType:(int)type
{
    self = [self init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self initTableView];
    if (self.type==1) {
        self.timekey = @"launchkey";
        [self setTitle:@"我发起的" andShowButton:YES];
        [self myInitiatedData];
    }else if (self.type==2){
        self.timekey = @"signkey";
        [self setTitle:@"我报名的" andShowButton:YES];
        [self mySignedData];
    }
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
    self.tableView.rowHeight = 200;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    WEAKSELF
//    [self.tableView addHeaderWithTimekey:self.timekey Callback:^{
//        [weakSelf.tableView headerEndRefreshing];
//    }];
    [self.tableView addFooterWithCallback:^{
        [weakSelf.tableView footerEndRefreshing];
        if (weakSelf.type==1) {
            [weakSelf myInitiatedData];
        }else if (weakSelf.type==2) {
            [weakSelf mySignedData];
        }
    }];
    
    
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableView.tableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[MyselfSignedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyselfSignedCell *signedCell = (MyselfSignedCell*)cell;
    signedCell.delegate = self;
    signedCell.tag = indexPath.row;
    if (indexPath.row < [self.tableView.tableArray count]) {
        MapMyselfSignedModel *model = [self.tableView.tableArray objectAtIndex:indexPath.row];
        signedCell.model = model;
        signedCell.tag = indexPath.row;
    }
    if (self.type==1) {
        signedCell.deleteButton.hidden = NO;
    }
    return signedCell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark MyselfSignedCellDelegate
- (void)signedCellClickToButton:(MyselfSignedCell *)myselfSignedCell
{
    if (myselfSignedCell.type == 1) {
        
        MapMyselfSignedModel *model = [self.tableView.tableArray objectAtIndex:myselfSignedCell.tag];
        model.status = @"3";
        myselfSignedCell.type = 3;
        [self updateApply:model];
    }
}
- (void)signedCellClickToButton:(MyselfSignedCell *)myselfSignedCell userName:(NSString*)userName userId:(NSString*)userId
{
    MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] initWithTitle:userName userId:userId userKey:@""];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)myselfSignedCell:(MyselfSignedCell *)myselfSignedCell ClickToAddressAtIndex:(NSInteger)index
{
    MapMyselfSignedModel *model = [self.tableView.tableArray objectAtIndex:myselfSignedCell.tag];
    if (index==100) {//起点
        NSLog(@"起点.....");
        NSDictionary *currentLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                         model.routeStart,@"route",
                                         model.longitudeStart,@"latitude",
                                         model.latitudeStart,@"longitude",nil];
        
        NSDictionary *otherLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                       model.routeEnd,@"route",
                                       model.longitudeEnd,@"latitude",
                                       model.latitudeEnd,@"longitude",nil];
        
        MapAnnotationViewController *annotationVC = [[MapAnnotationViewController alloc] initWithTitle:@"出发地" currentLocation:currentLocation otherLocation:otherLocation];
        [self.navigationController pushViewController:annotationVC animated:YES];
        
    }else if (index==101){//终点
        NSLog(@"终点.....");
        NSDictionary *otherLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                       model.routeStart,@"route",
                                       model.longitudeStart,@"latitude",
                                       model.latitudeStart,@"longitude",nil];
        
        NSDictionary *currentLocation = [NSDictionary dictionaryWithObjectsAndKeys:
                                         model.routeEnd,@"route",
                                         model.longitudeEnd,@"latitude",
                                         model.latitudeEnd,@"longitude",nil];
        
        MapAnnotationViewController *annotationVC = [[MapAnnotationViewController alloc] initWithTitle:@"目的地" currentLocation:currentLocation otherLocation:otherLocation];
        [self.navigationController pushViewController:annotationVC animated:YES];
    
    }else if (index==222){//删除
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"是否要删除该拼车?"
                                                     delegate:self
                                            cancelButtonTitle:@"是"
                                            otherButtonTitles:@"否",nil];
        [alert show];
        row = myselfSignedCell.tag;
//        MapMyselfSignedModel *model = [self.tableView.tableArray objectAtIndex:myselfSignedCell.tag];
//        [self deleteCarsharing:model.mId];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        MapMyselfSignedModel *model = [self.tableView.tableArray objectAtIndex:row];
        [self deleteCarsharing:model.mId];
    }
}
/**
 *  我发起的数据
 */
-(void)myInitiatedData
{
    if (self.tableView.pageNumber==0) {
        [self startLoading];
        self.tableView.hidden = YES;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?myList", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",1] forKey:@"type"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",self.tableView.pages] forKey:@"page_size"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",self.tableView.pageNumber] forKey:@"page_no"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
/**
 *  我报名的数据
 */
- (void)mySignedData
{
    if (self.tableView.pageNumber==0) {
        [self startLoading];
        self.tableView.hidden = YES;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?myApplyList", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",self.tableView.pages] forKey:@"page_size"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",self.tableView.pageNumber] forKey:@"page_no"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag == 2) {//我报名的
        MapMyselfSignedModel *model = nil;
        NSDictionary *objDict = [data objectForKey:@"list"];
        
        if (self.tableView.pageNumber==0) {//第一批数据
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in objDict) {
                NSString *status = [dict objectForKey:@"status"];
//                if ([status intValue]!=-1 && status!=nil) {
                    model = [[MapMyselfSignedModel alloc] initWithDataDict:dict];
                    model.applys = [[NSMutableArray alloc] init];
                    
                    MyselfApplysModel *applysModel = [[MyselfApplysModel alloc] init];
                    applysModel.userId = [dict objectForKey:@"userId"];
                    applysModel.userName = [dict objectForKey:@"userName"];
                    applysModel.userPhoto = [dict objectForKey:@"userPhoto"];
                    [model.applys addObject:applysModel];
                    
                    for (NSDictionary *apply in [dict objectForKey:@"applys"]) {
                        [model.applys addObject:[[MyselfApplysModel alloc] initWithDataDict:apply]];
                    }
                    [array addObject:model];
//                }
            }
            [self stopLoading];
            self.tableView.hidden = NO;
            [self.tableView addFirstArray:array];
            self.tableView.pageNumber++;
        }else{
            if ([objDict count]==0) {
                [self.tableView footerEndRefreshing];
            }else{
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in objDict) {
                    NSString *status = [dict objectForKey:@"status"];
//                    if ([status intValue]!=-1 && status!=nil) {
                        model = [[MapMyselfSignedModel alloc] initWithDataDict:dict];
                        model.applys = [[NSMutableArray alloc] init];
                        
                        MyselfApplysModel *applysModel = [[MyselfApplysModel alloc] init];
                        applysModel.userId = [dict objectForKey:@"userId"];
                        applysModel.userName = [dict objectForKey:@"userName"];
                        applysModel.userPhoto = [dict objectForKey:@"userPhoto"];
                        [model.applys addObject:applysModel];
                        
                        for (NSDictionary *apply in [dict objectForKey:@"applys"]) {
                            [model.applys addObject:[[MyselfApplysModel alloc] initWithDataDict:apply]];
                        }
                        [array addObject:model];
//                    }
                }
                [self.tableView addMoreArray:array];
                self.tableView.pageNumber++;
                [self.tableView footerEndRefreshing];
            }
        }
    }else if (tag==1){//我发起的
        MapMyselfSignedModel *model = nil;
        NSDictionary *objDict = [data objectForKey:@"list"];
        
        if (self.tableView.pageNumber==0) {//第一批数据
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in objDict) {
                model = [[MapMyselfSignedModel alloc] initWithDataDict:dict];
                model.applys = [[NSMutableArray alloc] init];
                
                MyselfApplysModel *applysModel = [[MyselfApplysModel alloc] init];
                applysModel.userId = [dict objectForKey:@"userId"];
                applysModel.userName = [dict objectForKey:@"userName"];
                applysModel.userPhoto = [dict objectForKey:@"userPhoto"];
                [model.applys addObject:applysModel];
                
                for (NSDictionary *apply in [dict objectForKey:@"applys"]) {
                    [model.applys addObject:[[MyselfApplysModel alloc] initWithDataDict:apply]];
                }
                [array addObject:model];
            }
//            [self stopLoading];
//            self.tableView.hidden = NO;
//            [self.tableView reloadData];
            [self stopLoading];
            self.tableView.hidden = NO;
            [self.tableView addFirstArray:array];
            self.tableView.pageNumber++;
        }else{
            if ([objDict count]==0) {
                [self.tableView footerEndRefreshing];
            }else{
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in objDict) {
                    model = [[MapMyselfSignedModel alloc] initWithDataDict:dict];
                    model.applys = [[NSMutableArray alloc] init];
                    
                    MyselfApplysModel *applysModel = [[MyselfApplysModel alloc] init];
                    applysModel.userId = [dict objectForKey:@"userId"];
                    applysModel.userName = [dict objectForKey:@"userName"];
                    applysModel.userPhoto = [dict objectForKey:@"userPhoto"];
                    [model.applys addObject:applysModel];
                    
                    for (NSDictionary *apply in [dict objectForKey:@"applys"]) {
                        [model.applys addObject:[[MyselfApplysModel alloc] initWithDataDict:apply]];
                    }
                    [array addObject:model];
                }
                [self.tableView addMoreArray:array];
                self.tableView.pageNumber++;
                [self.tableView footerEndRefreshing];
            }
        }
        
        
    }else if (tag==3){
        [self messageToast:@"状态更新成功!"];
    }else if (tag==4){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"informationRevised" object:nil];
        [self.tableView.tableArray removeObjectAtIndex:row];
        [self.tableView reloadData];
        [self messageToast:@"删除成功!"];
    }
}
/**
 *  更新我报名的状态
 */
-(void)updateApply:(MapMyselfSignedModel*)model
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?updateApply", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [paramDict setObject:model.mId forKey:@"id"];
    [paramDict setObject:@"2" forKey:@"status"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 3;
    [queue addOperation :operation];
}
//删除我发起的拼车
-(void)deleteCarsharing:(NSString*)mId
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?deleteCarSharing", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:mId forKey:@"id"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 4;
    [queue addOperation :operation];
}
@end
