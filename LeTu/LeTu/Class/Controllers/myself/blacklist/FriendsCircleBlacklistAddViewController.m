//
//  FriendsCircleBlacklistAddViewController.m
//  LeTu
//
//  Created by DT on 14-6-13.
//
//

#import "FriendsCircleBlacklistAddViewController.h"
#import "BATableView.h"
#import "UserModel.h"
#import "FriendsCircleBlacklistCell.h"

@interface FriendsCircleBlacklistAddViewController ()<BATableViewDelegate,UIScrollViewDelegate>
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)BATableView *tableView;
@property(nonatomic,strong)UIView *showFootView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *sureButton;

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation FriendsCircleBlacklistAddViewController


-(id)initWithArray:(NSMutableArray*)array
{
    self = [super init];
    if (self) {
        self.array = array;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"选择联系人" andShowButton:YES];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self initTableView];
    [self initShowFootView];
    [self initScrollView];
    [self GetContactPersonData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化tableView
 */
-(void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height - STATUSBAR_HEIGHT-NAVBAR_HEIGHT - 50;
    self.tableView = [[BATableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height)];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.isHideFlotage = YES;
    self.tableView.delegate = self;
    self.tableView.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    [self.tableView.tableView setEditing:YES animated:YES];
    self.tableView.tableView.allowsMultipleSelectionDuringEditing = YES;
}
#pragma mark UITableViewDataSource
#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView
{
    NSMutableArray *arr=nil;
    if ((UITableView*)tableView != self.searchDisplayController.searchResultsTableView){
        NSMutableArray * indexTitles = [NSMutableArray array];
        for (NSDictionary * sectionDictionary in self.dataSource) {
            [indexTitles addObject:sectionDictionary[@"indexTitle"]];
        }
        arr= indexTitles;
    }
    return arr;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title=nil;
    if (tableView != self.searchDisplayController.searchResultsTableView){
        title=self.dataSource[section][@"indexTitle"];
    }
    return title;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != self.searchDisplayController.searchResultsTableView){
        return self.dataSource.count;
    }else{
        return 1;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return self.searchResults.count;
    }else{
        return [self.dataSource[section][@"data"] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FriendsCircleBlacklistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[FriendsCircleBlacklistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.nameLabel.text = [self.dataSource[indexPath.section][@"data"][indexPath.row]objectForKey:@"userName"];
    NSString *userPhoto = [self.dataSource[indexPath.section][@"data"][indexPath.row]objectForKey:@"userPhoto"];
    [cell.faceImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,userPhoto]] placeholderImage:PLACEHOLDER];
    
    for (UserModel *model in self.array) {
        if ([model.userId isEqualToString:[self.dataSource[indexPath.section][@"data"][indexPath.row]objectForKey:@"userId"]]) {
            [self.tableView.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.tableView.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self reloadData];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *selectedRows = [self.tableView.tableView indexPathsForSelectedRows];
    [self reloadData];
    self.sureButton.enabled = YES;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedRows = [self.tableView.tableView indexPathsForSelectedRows];
    [self reloadData];
    if (!selectedRows) {
        self.sureButton.enabled = NO;
    }
}
/**
 *  初始化showFootView
 */
-(void)initShowFootView
{
    int y = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT- 50;
    self.showFootView = [[UIView alloc] initWithFrame:CGRectMake(0, y, FRAME_WIDTH, 50)];
    self.showFootView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blacklist_choose people_bg"]];
    [self.view addSubview:self.showFootView];
    
    self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 60, 30)];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.sureButton.titleLabel.textColor = [UIColor whiteColor];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitle:@"确定" forState:UIControlStateHighlighted];
    [self.sureButton setBackgroundImage:[UIImage imageNamed:@"Blacklist_btn_define_normal"] forState:UIControlStateNormal];
    [self.sureButton setBackgroundImage:[UIImage imageNamed:@"Blacklist_btn_define_press"] forState:UIControlStateHighlighted];
    [self.sureButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.showFootView addSubview:self.sureButton];
    self.sureButton.enabled = NO;
}
-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 5, 225, 40)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
//    self.scrollView.contentSize = CGSizeMake(400, 40);
    [self.showFootView addSubview:self.scrollView];
}
-(void)clickButton:(UIButton*)button
{
    if (self.callBack) {
        NSArray *selectedRows = [self.tableView.tableView indexPathsForSelectedRows];
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        UserModel *model = nil;
        for (NSIndexPath *indexPath in selectedRows) {
            model = [[UserModel alloc] initWithDataDict:self.dataSource[indexPath.section][@"data"][indexPath.row]];
            [itemArray addObject:model];
        }
        self.callBack(itemArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)GetContactPersonData
{
    NSString *requestURL = [NSString stringWithFormat:
                            @"%@/ms/friendService.jws?list&&l_key=%@",SERVERAPIURL,[UserDefaultsHelper getStringForKey:@"key"]];
    if (queue == nil ){
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation * operation=[[RequestParseOperation alloc] initWithURLString:requestURL delegate:self ];
    operation.RequestTag = 1;
    
    [queue addOperation :operation]; // 开始处理
    
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    NSDictionary *errDict = [data objectForKey:@"error"];
    int errCode = [[errDict objectForKey:@"err_code"] intValue];
    if (errCode == 0 || errCode == 1){
        if ([data objectForKey:@"list"]!=nil&&![[data objectForKey:@"list"] isKindOfClass:[NSNull class]]){
            self.dataSource=[data objectForKey:@"list"];
            //搜索内容数据
            self.dataArray = [NSMutableArray array];
            UserModel *model = nil;
            for (NSDictionary * sectionDictionary in self.dataSource){
                for (NSDictionary* dict in sectionDictionary[@"data"]){
                    model = [[UserModel alloc] initWithDataDict:dict];
//                    [self.dataArray addObject:[dict objectForKey:@"userName"]];
                    [self.dataArray addObject:model];
                }
            }
            [self.tableView reloadData];
        }
    }
}
/**
 *  刷新scrollView数据
 */
-(void)reloadData
{
    for (UIView *view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    NSArray *selectedRows = [self.tableView.tableView indexPathsForSelectedRows];
    UIImageView *imageView = nil;
    for (int i=0; i<[selectedRows count]; i++) {
        NSIndexPath *indexPath = [selectedRows objectAtIndex:i];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40*i+7*i, 0, 40, 40)];
        imageView.image = [UIImage imageNamed:@"Blacklist_choose_people_blank"];
        NSString *userPhoto = [self.dataSource[indexPath.section][@"data"][indexPath.row]objectForKey:@"userPhoto"];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,userPhoto]] placeholderImage:PLACEHOLDER];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(47*[selectedRows count], 40);
    
    [self.sureButton setTitle:[NSString stringWithFormat:@"%@(%i)",@"确定",[selectedRows count]]
                     forState:UIControlStateNormal];
    [self.sureButton setTitle:[NSString stringWithFormat:@"%@(%i)",@"确定",[selectedRows count]]
                     forState:UIControlStateHighlighted];
    self.sureButton.enabled = YES;
}
@end
