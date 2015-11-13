//
//  MyselfBlacklistViewController.m
//  LeTu
//
//  Created by DT on 14-6-9.
//
//

#import "MyselfBlacklistViewController.h"
#import "UserModel.h"
#import "MyselfBlacklistCell.h"

@interface MyselfBlacklistViewController ()<UITableViewDelegate,UITableViewDataSource,MyselfBlacklistCellDelegate>
{
    NSOperationQueue *queue;
    int _removeTag;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end

@implementation MyselfBlacklistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"黑名单" andShowButton:YES];
    self.itemArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self initTableView];
    [self fillData];
    self.appDelegate.navigation.isSlide = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.rowHeight = 74;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[MyselfBlacklistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyselfBlacklistCell *blacklistCell = (MyselfBlacklistCell*)cell;
    if (indexPath.row < [self.itemArray count]) {
        blacklistCell.tag = indexPath.row;
        blacklistCell.delegate = self;
        UserModel *model = [self.itemArray objectAtIndex:indexPath.row];
        blacklistCell.model = model;
    }
    return blacklistCell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (int i=0; i<[self.itemArray count]; i++) {
        MyselfBlacklistCell *cell = (MyselfBlacklistCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.deleteButton.center.x < 320) {
            cell.deleteButton.center = CGPointMake(cell.deleteButton.center.x+81, cell.deleteButton.center.y);
        }
    }
}
/**
 *  查询黑名单数据
 */
-(void)fillData
{
    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?blacklist", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag ==1) {//黑名单列表
        UserModel *model = nil;
        NSDictionary *objDict = [data objectForKey:@"list"];
        for (NSDictionary *dict in objDict) {
            model = [[UserModel alloc] initWithDataDict:dict];
            [self.itemArray addObject:model];
        }
        [self stopLoading];
        [self.tableView reloadData];
    }else if (tag ==2){//移除黑名单
        [self messageToast:@"移除黑名单成功!"];
        [self.itemArray removeObjectAtIndex:_removeTag];
        [self.tableView reloadData];
    }
}
#pragma mark MyselfBlacklistCellDelegate
-(void)blacklistCell:(MyselfBlacklistCell *)blacklistCell tag:(NSInteger)tag
{
    UserModel *model = [self.itemArray objectAtIndex:tag];
    _removeTag = tag;
    [self removeBlacklist:model.userId];
}
/**
 *  移除黑名单
 *
 *  @param userId 用户id
 */
-(void)removeBlacklist:(NSString*)userId
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?updateBlacklist", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:userId forKey:@"userIds"];
    [paramDict setObject:@"0" forKey:@"action"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
@end
