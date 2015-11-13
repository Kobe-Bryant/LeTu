//
//  AddMeListViewController.m
//  LeTu
//
//  Created by mac on 14-7-3.
//
//

#import "AddMeListViewController.h"
#import "AddContactViewController.h"
#import "ApplyFriendModel.h"
#import "EGOImageView.h"

#ifdef IMPORT_LETUIM_H
#import "SearchContactViewController.h" // 暂时改为直接添加 乐途好友
#endif

@interface AddMeListViewController ()

@end

@implementation AddMeListViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"letu_bg"]];
    [self setTitle:@"新的朋友" andShowButton:YES];
    [self initViews];
    
    
}
-(void)initViews
{
    
    
    //添加联系人
    UIButton *addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(320 -70, 7, 60, 30);
    [addBtn setTitle:@"添加朋友" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addBtn setFont:[UIFont systemFontOfSize:15.f]];
//    addBtn.frame = CGRectMake(575/2, 9, 21, 22);
//    [addBtn setImage:[UIImage imageNamed:@"contacts_headbar_icon_add"] forState:UIControlStateNormal];
    //[addBtn setImage:[UIImage imageNamed:@"ic_coach_top_add_btn_cur"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag=1;
    [self.view addSubview:addBtn];
    
    
    
    CGFloat tableH=[[UIScreen mainScreen]bounds].size.height-20-44;
    //新朋友邀请处理列表
    mTableView = [[TableView alloc] initWithFrame:CGRectMake(0, 44, 320, tableH)];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.refreshDelegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [mTableView addMoreView];
//    [mTableView addRefreshView];
    [self.view addSubview:mTableView];
    
    [self loadData];
    
    
    
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
            
        default:
            break;
    }
}
//点击事件
- (void)accept:(UIButton *)button
{
    
    //192.168.0.234:8891/ms/friendService.jws?addFriend&&l_key=&loginName=
    
    NSArray *views =button.superview.subviews;
    UILabel *loginName;
    for(UIView * view in views)
    {
        if (view.tag==1000)
        {
            loginName=(UILabel*)view;
        }
    }
    
//    NSString *requestURL = [NSString stringWithFormat:@"%@ms/friendService.jws?addFriend&&",SERVERAPIURL] ;
//    NSURL *url = [NSURL URLWithString:requestURL];
//    NSLog(@"APIUrl---%@",url);
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
//    [request setPostValue:loginName.text forKey:@"loginName"];
//    [request setTag:222];
//    [request buildPostBody];
//    [request setDelegate:self];
//    [request setTimeOutSeconds:240];
//    [request startAsynchronous];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@ms/friendService.jws?addFriend&l_key=%@&loginName=%@",
                            SERVERAPIURL,[UserDefaultsHelper getStringForKey:@"key"], loginName.text];
    
    NSLog(@"APIUrl---%@",requestURL);
    
    if (queue == nil ){
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation * operation=[[RequestParseOperation alloc] initWithURLString:requestURL delegate:self ];
    operation.RequestTag = 222;
    
    [queue addOperation :operation]; // 开始处理
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return mTableView.tableArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.5;
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
    
    ApplyFriendModel *applyFriendModel= [mTableView.tableArray objectAtIndex:indexPath.row];
    

    
    UIImage *contentBG = [UIImage imageNamed:@"newFriend_itemlist_normal1"];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 67.5)];

    [contentView setBackgroundColor:[UIColor colorWithPatternImage:contentBG]];
    
    
    
    
    //头像
    EGOImageView *headimageView = [[EGOImageView alloc] init];
    headimageView.frame = CGRectMake(7.5, 13.5, 50, 50);
    headimageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[applyFriendModel userPhoto]]];
    //后台还无此字段，等待字段....
//    [headimageView setImage:[UIImage imageNamed:@"message1_photo"]];
    [contentView addSubview:headimageView];
    
    
    
    //name
    UILabel * nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(70, 18, 180, 20)];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.textColor=[Utility colorWithHexString:@"#222222"];
    nameLabel.font = [UIFont fontWithName:@"Arial" size:15];
    nameLabel.text=[applyFriendModel userName];
    [contentView addSubview:nameLabel];
    
    
    
    
    //验证消息
    UILabel * contentLab =[[UILabel alloc]initWithFrame:CGRectMake(70, 38, 200, 20)];
    contentLab.backgroundColor=[UIColor clearColor];
    contentLab.textColor=[Utility colorWithHexString:@"#666666"];
    contentLab.font = [UIFont fontWithName:@"Arial" size:13];
    //    contentLab.text=[applyFriendModel];
    //后台还无此字段，等待字段....
    contentLab.text=applyFriendModel.sign;
    [contentView addSubview:contentLab];
    
    
    
    //接受联系人
    UIButton *addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(320-53, 21, 45, 26);
    [addBtn setImage:[UIImage imageNamed:@"Addcontacts_btn_accept_normal"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"Addcontacts_btn_accept_press"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:addBtn];
    
    
    UILabel * loginnameLab =[[UILabel alloc]initWithFrame:CGRectMake(85, 11, 140, 25)];
    loginnameLab.backgroundColor=[UIColor clearColor];
    [loginnameLab setTag:1000];
    loginnameLab.text=[applyFriendModel loginName];
    loginnameLab.hidden=YES;
    [contentView addSubview:loginnameLab];
    
    

    [cell addSubview:contentView];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}

- (TableView *) getTableView
{
 
    return mTableView;
  
    
}

//开始移动
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)sv
{
    TableView *tb = [self getTableView];
    if (tb)
    {
        [tb scrollViewWillBeginDecelerating:sv];
    }
}

//下拉table
- (void)scrollViewDidScroll:(UIScrollView *)sv
{
    TableView *tb = [self getTableView];
    if (tb)
    {
        [tb scrollViewDidScroll:sv];
    }
}

//刷新table  当scrollView 停止滚动拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate{
    TableView *tb = [self getTableView];
    
    if (tb)
    {
        [tb scrollViewDidEndDragging:sv];
    }
}

-(void)loadData
{
    //192.168.0.234:8891/ms/friendService.jws?friendList&&l_key=ZTQxMXRLeTlFK0dHZE91VCtnWmloeTNtd2tHWTMyMkU
//    NSString *requestURL = [NSString stringWithFormat:@"%@ms/friendService.jws?friendList&&",SERVERAPIURL] ;
//    NSURL *url = [NSURL URLWithString:requestURL];
//    NSLog(@"APIUrl---%@",url);
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
//    [request setTag:111];
//    [request buildPostBody];
//    [request setDelegate:self];
//    [request setTimeOutSeconds:240];
//    [request startAsynchronous];
    
    NSString *requestURL = [NSString stringWithFormat:
                            @"%@ms/friendService.jws?friendList&l_key=%@",SERVERAPIURL,[UserDefaultsHelper getStringForKey:@"key"]];
    
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
                if ([[data objectForKey:@"obj"] objectForKey:@"applyFriend"] || [[[data objectForKey:@"obj"] objectForKey:@"applyFriend"] isKindOfClass:[NSArray class]])
                {
                    
                    [mTableView.tableArray removeAllObjects];
                    NSArray *datas = [[data objectForKey:@"obj"] objectForKey:@"applyFriend"];
                    for (NSDictionary *dict in datas)
                    {
                        ApplyFriendModel *applyFriendModel = [[ApplyFriendModel alloc] initWithDataDict:dict];
                        [mTableView.tableArray addObject:applyFriendModel];
                    }
                    
                    [mTableView reload:datas.count];
                }
                else
                {
                    [mTableView reload:0];
                }
            }
            break;
        }
        case 222:
        {
            if (errCode == 0 || errCode == 1)
            {
                [self messageShow:@"添加成功！"];
                //                    [self reloadRefreshDataSource:0];
                [self loadData];
                break;
            }
            
        }
        default:
            break;
    }
}


- (void)reloadRefreshDataSource:(int)pageIndex
{

    
}
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSString *responseString = [request responseString];
//    
//    NSLog(@"-responseString--%@-----",responseString);
//    
//    NSError *error = [request error];
//    if (!error)
//    {
//        
//        
//        JSONDecoder *decoder=[JSONDecoder decoder];
//        NSDictionary *dict=[decoder objectWithData:request.responseData];
//        NSDictionary *errDict=[dict objectForKey:@"error"];
//        int errCode=[[errDict objectForKey:@"err_code"] intValue];
//        switch (request.tag)
//        {
//                
//                
//            case 111:
//            {
//                if (errCode == 0 || errCode == 1)
//                {
//                    if ([[dict objectForKey:@"obj"] objectForKey:@"applyFriend"] || [[[dict objectForKey:@"obj"] objectForKey:@"applyFriend"] isKindOfClass:[NSArray class]])
//                    {
//                     
//                        [mTableView.tableArray removeAllObjects];
//                        NSArray *datas = [[dict objectForKey:@"obj"] objectForKey:@"applyFriend"];
//                        for (NSDictionary *dict in datas)
//                        {
//                            ApplyFriendModel *applyFriendModel = [[ApplyFriendModel alloc] initWithDataDict:dict];
//                            [mTableView.tableArray addObject:applyFriendModel];
//                        }
//                        
//                        [mTableView reload:datas.count];
//                    }
//                    else
//                    {
//                        [mTableView reload:0];
//                    }
//                }
//       
//            }
//            case 222:
//            {
//                if (errCode == 0 || errCode == 1)
//                {
////                    [self messageShow:@"成功同意添加对方为好友"];
////                    [self reloadRefreshDataSource:0];
//                      [self loadData];
//                }
//                
//            }
//        }
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}



@end
