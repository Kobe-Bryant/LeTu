//
//  MonitorTableView.m
//  Monitor
//
//  Created by Cyberway on 13-9-5.
//
//

#import "MonitorTableView.h"
#import "MonitorViewController.h"
#import "EGOImageView.h"

@implementation MonitorTableView


-(id)initWithViewController:(UIViewController *)viewController
{
    if(self=[super init])
    {
        mViewController=viewController;
        [self initialization];
    }
    return self;
}
-(void)initialization
{
    CGFloat height=[UIScreen mainScreen].bounds.size.height;
    if (height==480) {
        mTableView=[[TableView alloc]initWithFrame:CGRectMake(0, 0, 320, 376)];
    }else if (height==568)
    {
        mTableView=[[TableView alloc]initWithFrame:CGRectMake(0, 0, 320, 463)];
    }
    mTableView.backgroundColor=[Utility colorWithHexString:@"f6f6f6"];
    mTableView.dataSource=self;
    mTableView.delegate=self;
    mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [mTableView addMoreView];
    mTableView.refreshDelegate=self;
    [mTableView addRefreshView];
    [self addSubview:mTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mTableView.tableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@""];
    if(!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 71)];
        contentView.tag=100;
        contentView.backgroundColor=[UIColor whiteColor];

        UILabel *companyNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 230, 30)];
        companyNameLabel.backgroundColor=[UIColor clearColor];
        companyNameLabel.tag=1;
        companyNameLabel.font=[UIFont systemFontOfSize:16];
        [contentView addSubview:companyNameLabel];
        
        UILabel *purifierLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 35, 85, 30)];
        purifierLabel.backgroundColor=[UIColor grayColor];
        purifierLabel.tag=2;
        purifierLabel.font=[UIFont systemFontOfSize:16];
        [contentView addSubview:purifierLabel];

        EGOImageView *imgView=[[EGOImageView alloc]initWithFrame:CGRectMake(90, 60, 60, 30)];
        imgView.tag=3;
        [contentView addSubview:imgView];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, 320, 1)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [contentView addSubview:lineView];
        
        [cell addSubview:contentView];
    }
    //赋值
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(NSMutableArray *)getTableArray
{
    return mTableView.tableArray;
}
-(void)reloadRefreshDataSource:(int)pageIndex
{
    
}
-(void)reloadData:(int)count
{
    [mTableView reload:count];
    if(count<10)
    {
    
    }
}
-(int)getPageIndex
{
    return mPageIndex;
}
-(TableView *)getTableView
{
    return mTableView;
}


-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    TableView *tb=[self getTableView];
    if(tb)
    {
        [tb scrollViewWillBeginDecelerating:scrollView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    TableView *tb=[self getTableView];
    if(tb)
    {
        [tb scrollViewDidScroll:scrollView];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    TableView *tb=[self getTableView];
    if(tb)
    {
        [tb scrollViewDidEndDragging:scrollView];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
