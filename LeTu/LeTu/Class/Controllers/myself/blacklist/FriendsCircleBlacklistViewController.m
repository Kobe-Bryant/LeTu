//
//  FriendsCircleBlacklistViewController.m
//  LeTu
//
//  Created by DT on 14-6-13.
//
//

#import "FriendsCircleBlacklistViewController.h"
#import "FriendsCircleBlacklistAddViewController.h"
#import "FriendsCircleBlacklistView.h"
#import "UserModel.h"

@interface FriendsCircleBlacklistViewController ()<FriendsCircleBlacklistViewDelegate>
{
    NSOperationQueue *queue;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *blacklistBackground;
@property(nonatomic,strong)UIButton *addButton;
@property(nonatomic,strong)UIButton *deleteButton;

@property(nonatomic,strong)NSMutableArray *itemArray;
//@property(nonatomic,strong)NSMutableArray *indexPathArray;
//@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,assign)BOOL isHide;
@end

@implementation FriendsCircleBlacklistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.indexPathArray = [[NSMutableArray alloc] init];
    self.itemArray = [[NSMutableArray alloc] init];
    self.isHide = YES;
    
    [self setTitle:@"不让他(她)看朋友圈" andShowButton:YES];
    [self initRightBarButtonItem:[UIImage imageNamed:@"Blacklist_finish_btn_current"]
                highlightedImage:[UIImage imageNamed:@"Blacklist_finish_btn_press"]];
//    [self initScrollView];
    [self fillData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  更新朋友圈黑名单
 *
 *  @param button
 */
-(void)clickRightButton:(UIButton *)button
{
    NSString *ids = @"";
    if ([self.itemArray count]==2 || [self.itemArray count]==1 || [self.itemArray count]==0) {
        ids = @"";
    }else{
        for (int i=0; i<[self.itemArray count]-2; i++) {
            UserModel *model = [self.itemArray objectAtIndex:i];
            ids = [ids stringByAppendingFormat:@"%@,",model.userId];
        }
        ids = [ids substringToIndex:[ids length]-1];
    }
    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?updateWeiboBlacklist", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:ids forKey:@"userIds"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
/**
 *  初始化scrollView
 */
-(void)initScrollView
{
    self.addButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.addButton setImage:[UIImage imageNamed:@"Blacklist_add_btn_normal"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"Blacklist_add_btn_press"] forState:UIControlStateHighlighted];
    self.addButton.tag = 999;
    self.addButton.userInteractionEnabled = YES;
    [self.addButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.deleteButton setImage:[UIImage imageNamed:@"Blacklist_minus_btn_normal"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"Blacklist_minus_btn_press"] forState:UIControlStateHighlighted];
    self.deleteButton.tag = 888;
    self.deleteButton.userInteractionEnabled = YES;
    [self.deleteButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    //*
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, FRAME_WIDTH, height)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"letu_bg"]];
    self.scrollView.contentSize = CGSizeMake(320, height);
    [self.view addSubview:self.scrollView];
    
    self.blacklistBackground = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 290, 100)];
    //    self.blacklistBackground.image = [UIImage imageNamed:@"Blacklist_bg"];
    UIImage *image = [UIImage imageNamed:@"Blacklist_bg"];
    self.blacklistBackground.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.scrollView addSubview:self.blacklistBackground];
     //*/
    
//    self.addButton.frame = CGRectMake(10+15, 20+44+15, 60, 60);
    self.addButton.frame = CGRectMake(10+15, 20+15, 60, 60);
    [self.scrollView addSubview:self.addButton];
}
/**
 *  按钮事件
 *
 *  @param button
 */
-(void)clickButton:(UIButton*)button
{
    if (button.tag==999) {//添加按钮
        FriendsCircleBlacklistAddViewController *addVC = [[FriendsCircleBlacklistAddViewController alloc] initWithArray:self.itemArray];
        [self.navigationController pushViewController:addVC animated:YES];
        [addVC setCallBack:^(NSMutableArray *dataSource) {
            [self.itemArray removeAllObjects];
            [self.itemArray removeLastObject];
            [self.itemArray removeLastObject];
            [self.itemArray addObjectsFromArray:dataSource];
            [self.itemArray addObject:[[UserModel alloc] init]];
            [self.itemArray addObject:[[UserModel alloc] init]];

            self.isHide = YES;
            [self reloadData];
        }];
        
        
    }else if(button.tag == 888){//删除按钮
        for (UIView *view in [self.scrollView subviews]) {
            if ([view isKindOfClass:[FriendsCircleBlacklistView class]]) {
                FriendsCircleBlacklistView *blacklistView = (FriendsCircleBlacklistView*)view;
                blacklistView.deleteButton.hidden = ![blacklistView.deleteButton isHidden];
            }
        }
    }
}
/**
 *  刷新scrollView数据
 */
-(void)reloadData
{
    int column = 4;
//    float rows = (float)[self.indexPathArray count]/column;
    float rows = (float)[self.itemArray count]/column;
    int row = ceil(rows);
    
    for (UIView *view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    CGRect blacklistBackgroundFrame = self.blacklistBackground.frame;
    blacklistBackgroundFrame.size.height = 110+70*(row-1);
    self.blacklistBackground.frame = blacklistBackgroundFrame;
    [self.scrollView addSubview:self.blacklistBackground];
    
    FriendsCircleBlacklistView *blacklistView = nil;
    int index = 0;
    for (int j=0; j<row; j++) {
        for (int i=0; i<column; i++) {
            if (index == [self.itemArray count]) {
                return;
            }
            if (index == [self.itemArray count]-2) {
                self.addButton.frame = CGRectMake(25+60*i+10*i, 35+60*j+25*j, 60, 60);
                [self.scrollView addSubview:self.addButton];
            }else if (index == [self.itemArray count]-1){
                self.deleteButton.frame = CGRectMake(25+60*i+10*i, 35+60*j+25*j, 60, 60);
                [self.scrollView addSubview:self.deleteButton];
            }else{
                blacklistView = [[FriendsCircleBlacklistView alloc] initWithFrame:CGRectMake(25+60*i+10*i, 35+60*j+25*j, 60, 60)];
                blacklistView.tag = index;
                blacklistView.delegate = self;
                blacklistView.deleteButton.hidden = self.isHide;
                blacklistView.backgroundColor = [UIColor clearColor];
                /*
                NSIndexPath *indexPath = [self.indexPathArray objectAtIndex:index];
                NSString *userPhoto = [self.dataSource[indexPath.section][@"data"][indexPath.row]objectForKey:@"userPhoto"];
                [blacklistView.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,userPhoto]] placeholderImage:PLACEHOLDER];
                NSString *userName = [self.dataSource[indexPath.section][@"data"][indexPath.row]objectForKey:@"userName"];
                blacklistView.nameLabel.text = userName;
                */
                UserModel *model = [self.itemArray objectAtIndex:index];
                blacklistView.nameLabel.text = model.userName;
                [blacklistView.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.userPhoto]] placeholderImage:PLACEHOLDER];
    
                [self.scrollView addSubview:blacklistView];
            }
            
            index++;
        }
    }
}
#pragma mark FriendsCircleBlacklistViewDelegate
-(void)blacklistViewClickDelete:(FriendsCircleBlacklistView *)blacklistView
{
    [self.itemArray removeObjectAtIndex:blacklistView.tag];
    self.isHide = NO;
//    if (iOS_7_Above) {
//        self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
//    }
    [self reloadData];
    if ([self.itemArray count]==2) {
        for (UIView *view in [self.scrollView subviews]) {
            [view removeFromSuperview];
        }
        CGRect blacklistBackgroundFrame = self.blacklistBackground.frame;
        blacklistBackgroundFrame.size.height = 110;
        self.blacklistBackground.frame = blacklistBackgroundFrame;
        [self.scrollView addSubview:self.blacklistBackground];
        
        self.addButton.frame = CGRectMake(10+15, 20+15, 60, 60);
        [self.scrollView addSubview:self.addButton];
    }
}
/**
 *  查询朋友圈黑名单数据
 */
- (void)fillData
{
    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?weiboBlacklist", SERVERAPIURL];
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
    if (tag == 1) {
        UserModel *model = nil;
        NSDictionary *objDict = [data objectForKey:@"list"];
        for (NSDictionary *dict in objDict) {
            model = [[UserModel alloc] initWithDataDict:dict];
            [self.itemArray addObject:model];
        }
        [self stopLoading];
        [self initScrollView];
        if ([self.itemArray count]>0) {
            [self.itemArray addObject:[[UserModel alloc] init]];
            [self.itemArray addObject:[[UserModel alloc] init]];
            [self reloadData];
        }
    }else if (tag ==2){
        [self stopLoading];
        [self messageToast:@"更新成功"];
        CGRect frame = self.view.frame;
        if (iOS_7_Above) {
            frame.origin.y -=20;
        }
        self.view.frame = frame;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
