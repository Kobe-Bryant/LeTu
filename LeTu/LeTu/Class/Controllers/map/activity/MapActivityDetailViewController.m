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

@interface MapActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)MapActivityDetailHeaderView *tableHeaderView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MapActivityModel *model;
@property(nonatomic,strong)UIButton *button;
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
    [self setTitle:@"活动详情" andShowButton:YES];
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
    MapApplyActivityViewController *applyVC = [[MapApplyActivityViewController alloc] initWithActivityId:@""];
    [self.navigationController pushViewController:applyVC animated:YES];
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
    self.tableView.rowHeight = 60;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableHeaderView = [[MapActivityDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 270)];
    self.tableHeaderView.model = self.model;
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[DetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%i",indexPath.row];
    return cell;
    
}
#pragma mark UITableViewDelegate
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCommentCell *cell = (DetailCommentCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
//*/
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
        NSDictionary *dict = [data objectForKey:@"list"];
    }
}
@end
