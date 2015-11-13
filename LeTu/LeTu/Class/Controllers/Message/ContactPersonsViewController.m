//
//  ContactPersonsViewController.m
//  LeTu
//
//  Created by mac on 14-5-12.
//
//

#import "ContactPersonsViewController.h"
#import "EGOImageView.h"
#import "AddContactViewController.h"
#import "ChatViewController.h"
#import "AddMeListViewController.h"

#ifdef IMPORT_LETUIM_H
#import "LeTuIM.h"
#import "SearchContactViewController.h" // 暂时改为直接添加 乐途好友
#endif

@interface ContactPersonsViewController ()

@end

@implementation ContactPersonsViewController
@synthesize contactTableView;
@synthesize dataSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"联系人" andShowButton:YES];
    pictureDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    idDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self initViews];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    self.appDelegate.navigation.isSlide = NO;
    isOpen=NO;
    [self GetContactPersonData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.appDelegate.navigation.isSlide = YES;
    
    
}
- (void)initViews
{
    if (mContainer!=nil)
    {
        [mContainer removeFromSuperview];
    }
    
    
    //背景图
    UIImage *Img=[UIImage imageNamed:@"letu_bg"];
    
    mContainer =[[UIView alloc]initWithFrame:CGRectMake(0,44, 320, self.view.bounds.size.height-44)];
    
    mContainer.backgroundColor=[UIColor colorWithPatternImage:Img];
    
    [self.view addSubview:mContainer];
    
    
    
    //新的朋友
    newFriendBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    newFriendBtn.frame = CGRectMake(320 -70, 7, 60, 30);
    [newFriendBtn setTitle:@"有新朋友" forState:UIControlStateNormal];
    [newFriendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    newFriendBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//    [newFriendBtn setFont:[UIFont systemFontOfSize:15.f]];
//    newFriendBtn.frame = CGRectMake(250, 9, 21, 22);
//    [newFriendBtn setImage:[UIImage imageNamed:@"message1_icon_profile1"] forState:UIControlStateNormal];
    [newFriendBtn addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
    newFriendBtn.tag=4;
    newFriendBtn.hidden=YES;
    [self.view addSubview:newFriendBtn];
    
    
    //添加联系人
    addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(320 -70, 7, 60, 30);
    [addBtn setTitle:@"添加朋友" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//    [addBtn setFont:[UIFont systemFontOfSize:15.f]];
//    addBtn.frame = CGRectMake(575/2, 9, 21, 22);
//    [addBtn setImage:[UIImage imageNamed:@"contacts_headbar_icon_add"] forState:UIControlStateNormal];
    //[addBtn setImage:[UIImage imageNamed:@"ic_coach_top_add_btn_cur"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag=1;
    [self.view addSubview:addBtn];
    
    
    
    //搜索
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索"];
    //修改背景
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"letu_bg"]];
    [mySearchBar insertSubview:imageView atIndex:1];
    
    [mContainer addSubview:mySearchBar];
    
    
    
    CGFloat tableH;
    if ([[UIScreen mainScreen]bounds].size.height==480)
    {
        //        [[UIScreen mainScreen]bounds].size.height-20-44-40;
        tableH=376;
    }
    else {
        tableH=464;
    }
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsTableView.frame=CGRectMake(0, 0, 320, tableH);
    searchDisplayController.delegate=self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    
}
-(void)GetNewFriendRequestCount
{
    
    
    //192.168.0.234:8891/ms/friendService.jws?friendList&&l_key=ZTQxMXRLeTlFK0dHZE91VCtnWmloeTNtd2tHWTMyMkU
    
    //    NSString *requestURL = [NSString stringWithFormat:@"%@ms/friendService.jws?friendList&&",SERVERAPIURL] ;
    //    NSURL *url = [NSURL URLWithString:requestURL];
    //    NSLog(@"APIUrl---%@",url);
    //    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    //    [request setTag:333];
    //    [request buildPostBody];
    //    [request setDelegate:self];
    //    [request setTimeOutSeconds:240];
    //    [request startAsynchronous];
    
    NSString *requestURL = [NSString stringWithFormat:
                            @"%@ms/friendService.jws?checkNewApply&l_key=%@",SERVERAPIURL,[UserDefaultsHelper getStringForKey:@"key"]];
    
    NSLog(@"APIUrl---%@",requestURL);
    
    if (queue == nil ){
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation * operation=[[RequestParseOperation alloc] initWithURLString:requestURL delegate:self ];
    operation.RequestTag = 333;
    
    [queue addOperation :operation]; // 开始处理
    
    
}

//获取联系人信息
-(void)GetContactPersonData
{
    
    //192.168.0.234:8891/ms/friendService.jws?list&&l_key=bThBOVAzWnZIcHEvNVYwU2NYdGEwU2E5TENWTTFkQWc
    
    
    NSString *requestURL = [NSString stringWithFormat:
                            @"%@ms/friendService.jws?list&&l_key=%@",SERVERAPIURL,[UserDefaultsHelper getStringForKey:@"key"]];
    
    NSLog(@"APIUrl---%@",requestURL);
    
    if (queue == nil ){
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation * operation=[[RequestParseOperation alloc] initWithURLString:requestURL delegate:self ];
    operation.RequestTag = 111;
    
    [queue addOperation :operation]; // 开始处理
    
    
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    NSDictionary *errDict = [data objectForKey:@"error"];
    int errCode = [[errDict objectForKey:@"err_code"] intValue];
    switch (tag)
    {
            
            
        case 111:
        {
            if (errCode == 0 || errCode == 1)
            {
                
                
                if ([data objectForKey:@"list"]!=nil&&![[data objectForKey:@"list"] isKindOfClass:[NSNull class]])
                {
                    
                    //列表数据
                    //                self.dataSource=[NSArray arrayWithObjects:@{@"indexTitle": @"A",@"data":@[@"adam", @"alfred", @"ain", @"abdul", @"anastazja", @"angelica"]}, @{@"indexTitle": @"D",@"data":@[@"dennis" , @"deamon", @"destiny", @"dragon", @"dry", @"debug", @"drums"]},nil];
                    
                    self.dataSource=[data objectForKey:@"list"];
#ifdef IMPORT_LETUIM_H
                    LeTuIM *im = [LeTuIM sharedInstance];
                    NSDictionary *listDic = [data objectForKey:@"list"];
                    if (listDic) {
                        for (NSDictionary *keyDic in self.dataSource) {
                            
                            NSString *keyIndex = keyDic[@"indexTitle"];
                            NSArray *keyArr = keyDic[@"data"];
                            for (NSDictionary *userDic in keyArr) {
                                LeTuUser *user = [im findUserWithName:userDic[@"loginName"] update:NO];
                                [user updateInfomationWithDictionary:userDic];
                                user.indexString = keyIndex;
                                [LeTuUser updateUserInfomationWithUser:user];
                            }
                        }
                    }
#endif
                    
                    //搜索内容数据
                    dataArray = [NSMutableArray array];
                    for (NSDictionary * sectionDictionary in self.dataSource)
                    {
                        for (NSDictionary* dict in sectionDictionary[@"data"])
                        {
                            
                            [dataArray addObject:[dict objectForKey:@"userName"]];
                            
                            [pictureDict setValue:[NSString stringWithFormat:@"%@",[dict objectForKey:@"userPhoto"]] forKey:[NSString stringWithFormat:@"%@", [dict objectForKey:@"userName"]]];
                            
                            
                            [idDict setValue:[NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]] forKey:[NSString stringWithFormat:@"%@", [dict objectForKey:@"userName"]]];
                            
                        }
                        
                    }
                    
                    [self createTableView];
                    
                    [self GetNewFriendRequestCount];
                    
                }
            }
            break;
        }
        case 222:
        {
            
            if (errCode == 0 || errCode == 1)
            {
                [self.contactTableView reloadData];
                [self GetContactPersonData];
            }
            break;
        }
        case 333:
        {
            if (errCode == 0 || errCode == 1)
            {
                //                if ([[dict objectForKey:@"obj"] objectForKey:@"newFriendCount"] || [[[dict objectForKey:@"obj"] objectForKey:@"newFriendCount"] isKindOfClass:[NSArray class]])
                if ([[data objectForKey:@"obj"] objectForKey:@"newApplyCount"]!=nil&&![[[data objectForKey:@"obj"] objectForKey:@"newApplyCount"] isKindOfClass:[NSNull class]])
                {
                    
                    
                    int count=[[[data objectForKey:@"obj"] objectForKey:@"newApplyCount"]intValue];
                    
                    if(remindView != nil)
                        [remindView removeFromSuperview];
                    newFriendBtn.hidden=YES;
                    addBtn.hidden = NO;
                    
//                    remindView = [[UIView alloc] initWithFrame:CGRectMake(258, 4, 20, 20)];
                    remindView = [[UIView alloc] initWithFrame:CGRectMake(320 -20, 4, 20, 20)];
                    remindView.userInteractionEnabled = NO;
                    if (count>0)
                    {
                        newFriendBtn.hidden=NO;
                        addBtn.hidden = YES;
                        UIImage *TipImgBg = [UIImage imageNamed:
                                             count>9?@"2unit.png":@"1unit.png"];
                        
                        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(120, 18, 20, 20)];
                        [view setImage:TipImgBg];
                        
                        UILabel *tipLab;
                        if (count>9)
                            tipLab = [[UILabel alloc]initWithFrame:CGRectMake(view.bounds.origin.x+3,view.bounds.origin.y+4,12,9)];
                        else
                            tipLab = [[UILabel alloc]initWithFrame:CGRectMake(view.bounds.origin.x+6,view.bounds.origin.y+4,9,9)];
                        
                        tipLab.text =[NSString stringWithFormat:@"%d",count];
                        tipLab.backgroundColor = [UIColor clearColor];
                        tipLab.textColor = [UIColor whiteColor];
                        if (count>9)
                            tipLab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:10];
                        else
                            tipLab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
                        
                        [view addSubview:tipLab];
                        [headerView addSubview:view];
//                        [remindView addSubview:view];
//                        [self.view addSubview:remindView];
                    }
                }
            }
            break;
        }
        default:
            break;
    }
    
    
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSLog(@"-responseString--%@-----",responseString);
    
    NSError *error = [request error];
    if (!error)
    {
        JSONDecoder *decoder=[JSONDecoder decoder];
        NSDictionary *dict=[decoder objectWithData:request.responseData];
        NSDictionary *errDict=[dict objectForKey:@"error"];
        int errCode=[[errDict objectForKey:@"err_code"] intValue];
        switch (request.tag)
        {
            case 333:
            {
                if (errCode == 0 || errCode == 1)
                {
                    //                if ([[dict objectForKey:@"obj"] objectForKey:@"newFriendCount"] || [[[dict objectForKey:@"obj"] objectForKey:@"newFriendCount"] isKindOfClass:[NSArray class]])
                    if ([[dict objectForKey:@"obj"] objectForKey:@"newFriendCount"]!=nil&&![[[dict objectForKey:@"obj"] objectForKey:@"newFriendCount"] isKindOfClass:[NSNull class]])
                    {
                        int count=[[[dict objectForKey:@"obj"] objectForKey:@"newFriendCount"]intValue];
                        
                        if(remindView != nil)
                            [remindView removeFromSuperview];
                        newFriendBtn.hidden=YES;
                        
//                        remindView = [[UIView alloc] initWithFrame:CGRectMake(258, 4, 20, 20)];
                        remindView = [[UIView alloc] initWithFrame:CGRectMake(320 -30, 4, 20, 20)];
                        if (count>0)
                        {
                            newFriendBtn.hidden=NO;
                            UIImage *TipImgBg = [UIImage imageNamed:
                                                 count>9?@"2unit.png":@"1unit.png"];
                            
                            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                            view.userInteractionEnabled = NO;
                            [view setImage:TipImgBg];
                            
                            UILabel *tipLab;
                            if (count>9)
                                tipLab = [[UILabel alloc]initWithFrame:CGRectMake(view.bounds.origin.x+3,view.bounds.origin.y+4,12,9)];
                            else
                                tipLab = [[UILabel alloc]initWithFrame:CGRectMake(view.bounds.origin.x+6,view.bounds.origin.y+4,9,9)];
                            
                            tipLab.text =[NSString stringWithFormat:@"%d",count];
                            tipLab.backgroundColor = [UIColor clearColor];
                            tipLab.textColor = [UIColor whiteColor];
                            if (count>9)
                                tipLab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:10];
                            else
                                tipLab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
                            
                            [view addSubview:tipLab];
                            [remindView addSubview:view];
                            [self.view addSubview:remindView];
                        }
                    }
                }
            }
        }
    }
}

// 创建tableView
- (void) createTableView
{
    
    CGFloat tableH;
    if ([[UIScreen mainScreen]bounds].size.height==480)
    {
        //        [[UIScreen mainScreen]bounds].size.height-20-44-40;
        tableH=376;
    }
    else {
        tableH=464;
    }
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 12, 41, 41)];
    faceImageView.image = [UIImage imageNamed:@"contacts_pic"];
    [headerView addSubview:faceImageView];
    UILabel * nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(58, 18, 180, 20)];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.textColor=[Utility colorWithHexString:@"#222222"];
    nameLabel.font = [UIFont fontWithName:@"Arial" size:15];
    nameLabel.text = @"新的朋友";
    [headerView addSubview:nameLabel];
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, (headerView.frame.size.height-13)/2, 9, 13)];
    arrowImage.image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
    [headerView addSubview:arrowImage];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    headerView.userInteractionEnabled = YES;
    [headerView addGestureRecognizer:gesture];
    
    
    self.contactTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 45, 320, tableH)];
    self.contactTableView.delegate = self;
    self.contactTableView.tableView.tableHeaderView = headerView;
    [mContainer addSubview:self.contactTableView];
    
}


#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView
{
    NSMutableArray *arr=Nil;
    if ((UITableView*)tableView != self.searchDisplayController.searchResultsTableView)
    {
        NSMutableArray * indexTitles = [NSMutableArray array];
        for (NSDictionary * sectionDictionary in self.dataSource) {
            [indexTitles addObject:sectionDictionary[@"indexTitle"]];
        }
        arr= indexTitles;
    }
    return arr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title=nil;
    if (tableView != self.searchDisplayController.searchResultsTableView)
    {
        title=self.dataSource[section][@"indexTitle"];
    }
    return title;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != self.searchDisplayController.searchResultsTableView)
    {
        return self.dataSource.count;
    }
    else
    {
        return 1;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return searchResults.count;
    }
    else
    {
        return [self.dataSource[section][@"data"] count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    
    //删除按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(491/2, 0, 74, 60);
    [button setImage:[UIImage imageNamed:@"contacts_btn_cancel_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"contacts_btn_cancel_current"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:button];
    
    
    UIImage *contentBG = [UIImage imageNamed:@"message1_itemlist_normal"];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [contentView setBackgroundColor:[UIColor colorWithPatternImage:contentBG]];
    
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectItem:)];
    swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectItem:)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [contentView addGestureRecognizer:tapGes];
    [contentView addGestureRecognizer:swipeGes];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        contentView.tag=20;
        
    }
    else
    {
        contentView.tag=30;
    }
    
    //头像
    EGOImageView *headimageView = [[EGOImageView alloc] init];
    headimageView.frame = CGRectMake(7, 12, 41, 41);
    [contentView addSubview:headimageView];
    
    NSString *headImage;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        headImage= [pictureDict valueForKey:[NSString stringWithFormat:@"%@",searchResults[indexPath.row]]];
        
        headimageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,headImage]];
        
        button.tag = 2;
    }
    else
    {
        
        button.tag = 3;
        
        headImage= [pictureDict valueForKey:[NSString stringWithFormat:@"%@",[self.dataSource[indexPath.section][@"data"][indexPath.row]objectForKey:@"userName"]]];
        
        headimageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,headImage]];
    }
    
    
    
    //name
    UILabel * nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(58, 18, 180, 20)];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.textColor=[Utility colorWithHexString:@"#222222"];
    nameLabel.font = [UIFont fontWithName:@"Arial" size:15];
    [contentView addSubview:nameLabel];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        nameLabel.text= searchResults[indexPath.row];
    }
    else
    {
        nameLabel.text = [self.dataSource[indexPath.section][@"data"][indexPath.row]objectForKey:@"userName"];
    }
    
    
    
    cell.tag=indexPath.section;
    
    itemView.tag=indexPath.row;
    
    [cell addSubview:itemView];
    
    [itemView addSubview:contentView];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)selectItem:(UIGestureRecognizer *)ges
{
    UIView *selectView = ges.view;
    if ([ges isKindOfClass:[UITapGestureRecognizer class]])
    {
        if (isOpen)
        {
            [UIView animateWithDuration:0.1 animations:^{
                selectView.center = CGPointMake(selectView.center.x + 74, selectView.center.y);
            } completion:^(BOOL finished) {
                
            }];
            isOpen=NO;
            
            
            [selectView removeGestureRecognizer:swipeGes];
            swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectItem:)];
            swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
            [selectView addGestureRecognizer:swipeGes];
        }
        else
        {
            
            selectView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"message1_itemlist_current"]];
            
            
            int indexRow=selectView.superview.tag;
            int indexSection;
            indexSection =selectView.superview.superview.tag;
            if([[UIDevice currentDevice].systemVersion intValue]>=7.0)
            {
                indexSection= selectView.superview.superview.superview.tag;
            }
            
            if (selectView.tag==30)
            {
                
                
                
                //跳转到聊天窗口
                ChatViewController *vc= [[ChatViewController alloc]init];
                vc.titleString=[self.dataSource[indexSection][@"data"][indexRow] objectForKey:@"userName"];
#ifdef IMPORT_LETUIM_H
                vc.chatWith = [self.dataSource[indexSection][@"data"][indexRow] objectForKey:@"loginName"];
                vc.updateBuddyInfomation = YES; // !
#endif
                vc.targetType=@"1";
                vc.targetId=[self.dataSource[indexSection][@"data"][indexRow] objectForKey:@"userId"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                //搜索结果，跳转到聊天窗口
                
                
                ChatViewController *vc= [[ChatViewController alloc]init];
                vc.titleString=searchResults[indexRow];
#ifdef IMPORT_LETUIM_H
                vc.chatWith = [self.dataSource[indexSection][@"data"][indexRow] objectForKey:@"loginName"];
                vc.updateBuddyInfomation = YES; // !
#endif
                vc.targetType=@"1";
                vc.targetId=[idDict valueForKey:[self.dataSource[indexSection][@"data"][indexRow]objectForKey:@"userName"]];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
            
        }
        
    }
    else
    {
        UISwipeGestureRecognizer *swGes = (UISwipeGestureRecognizer *)ges;
        if (swGes.direction == UISwipeGestureRecognizerDirectionLeft)
        {
            isOpen=YES;
            swGes.direction = UISwipeGestureRecognizerDirectionRight;
            [UIView animateWithDuration:0.1 animations:^{
                selectView.center = CGPointMake(selectView.center.x - 74, selectView.center.y);
            } completion:^(BOOL finished) {
                
            }];
            
            
        }
        else
        {
            isOpen=NO;
            swGes.direction = UISwipeGestureRecognizerDirectionLeft;
            [UIView animateWithDuration:0.1 animations:^{
                selectView.center = CGPointMake(selectView.center.x + 74, selectView.center.y);
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
}



//点击事件
- (void)buttonEvents:(UIButton *)button
{
    switch (button.tag)
    {
            // 添加联系人页面
        case 1:
        {
#ifdef IMPORT_LETUIM_H
            SearchContactViewController *vc = [[SearchContactViewController alloc] init];
#else
            AddContactViewController *vc= [[AddContactViewController alloc]init];
#endif
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
            // 删除搜索结果的
        case 2:
        {
            int delIndex= button.superview.tag;
            NSString *userid= [idDict valueForKey:[NSString stringWithFormat:@"%@",searchResults[delIndex]]];
            [self DelContactPerson:userid];
            break;
        }
            //删除正常的
        case 3:
        {
            
            int delIndex= button.superview.tag;
            int section;
            if([[UIDevice currentDevice].systemVersion intValue]>=7.0)
            {
                section= button.superview.superview.superview.tag;
            }else{
                section = button.superview.superview.tag;
            }
            NSString *userid= [idDict valueForKey:[self.dataSource[section][@"data"][delIndex]objectForKey:@"userName"]];
            [self DelContactPerson:userid];
            break;
            
        }
            
            //新联系人
        case 4:
        {
            
            AddMeListViewController *vc= [[AddMeListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
            
        }
            
            
        default:
            break;
    }
}
-(void)DelContactPerson:(NSString*)userid
{
    
    //192.168.0.234:8891/ms/friendService.jws?update&&l_key=&action=&loginName=&userIds=
    
    
    NSString *requestURL = [NSString stringWithFormat:
                            @"%@ms/friendService.jws?update&&l_key=%@&action=%@&loginName=%@&userIds=%@",SERVERAPIURL,[UserDefaultsHelper getStringForKey:@"key"],@"0",@"",userid];
    
    NSLog(@"APIUrl---%@",requestURL);
    
    if (queue == nil ){
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation * operation=[[RequestParseOperation alloc] initWithURLString:requestURL delegate:self ];
    operation.RequestTag = 222;
    
    [queue addOperation :operation]; // 开始处理
    
    
    
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text])
    {
        for (int i=0; i<dataArray.count; i++)
        {
            if ([ChineseInclude isIncludeChineseInString:dataArray[i]])
            {
                //                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dataArray[i]];
                //                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                //                if (titleResult.length>0) {
                //                    [searchResults addObject:dataArray[i]];
                //                }
                //                else
                //                {
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:dataArray[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
                else
                {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:dataArray[i]];
                    NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults addObject:dataArray[i]];
                    }
                }
                //                }
            }
            else
            {
                NSRange titleResult=[dataArray[i] rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:dataArray[i]];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (NSString *tempStr in dataArray) {
            NSRange titleResult=[tempStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tempStr];
            }
        }
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetFrame)
                                                 name:UIKeyboardWillShowNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)resetFrame
{
    
    CGFloat tableH;
    if ([[UIScreen mainScreen]bounds].size.height==480)
    {
        //        [[UIScreen mainScreen]bounds].size.height-20-44-40;
        tableH=376;
    }
    else {
        tableH=464;
    }
    
    CGRect bounds =  searchDisplayController.searchResultsTableView.superview.bounds;
    CGFloat offset = CGRectGetMinY(bounds);
    if (offset == 0)
    {
        searchDisplayController.searchResultsTableView.superview.bounds =CGRectMake(0,20,320,tableH);
    }
    
    for(UIView * v in searchDisplayController.searchResultsTableView.superview.subviews)
    {
        NSLog(@"%@",[v class]);
        if([v isKindOfClass:NSClassFromString(@"_UISearchDisplayControllerDimmingView")])
        {
            v.frame = CGRectMake(0,0,320,tableH); //
        }
    }
    
    searchDisplayController.searchResultsTableView.frame=CGRectMake(0, 0, 320, tableH);
    [searchDisplayController.searchResultsTableView setContentInset:UIEdgeInsetsZero];
    [searchDisplayController.searchResultsTableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
    
    NSLog(@"resetFrame---tableview--%f,%f",searchDisplayController.searchResultsTableView.frame.origin.y,searchDisplayController.searchResultsTableView.frame.size.height);
    NSLog(@"resetFrame---tableviewsuper--%f,%f",searchDisplayController.searchResultsTableView.superview.frame.origin.y,searchDisplayController.searchResultsTableView.frame.size.height);
    
    
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    
    [self resetFrame];
    NSLog(@"resetFrame---tableview--%f,%f",searchDisplayController.searchResultsTableView.frame.origin.y,searchDisplayController.searchResultsTableView.frame.size.height);
    NSLog(@"resetFrame---tableviewsuper--%f,%f",searchDisplayController.searchResultsTableView.superview.frame.origin.y,searchDisplayController.searchResultsTableView.frame.size.height);
    
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    
    
    
    [self resetFrame];
    NSLog(@"resetFrame---tableview--%f,%f",searchDisplayController.searchResultsTableView.frame.origin.y,searchDisplayController.searchResultsTableView.frame.size.height);
    NSLog(@"resetFrame---tableviewsuper--%f,%f",searchDisplayController.searchResultsTableView.superview.frame.origin.y,searchDisplayController.searchResultsTableView.frame.size.height);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  新朋友按钮事件
 *
 *  @param tap
 */
- (void)tapHandle:(UITapGestureRecognizer *)tap
{
    AddMeListViewController *vc= [[AddMeListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
