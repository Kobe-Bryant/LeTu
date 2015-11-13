//
//  MapActivityPeoplesViewController.m
//  LeTu
//
//  Created by DT on 14-7-1.
//
//

#import "MapActivityPeoplesViewController.h"
#import "MapActivityPeoplesCell.h"
#import "MapActivityApplysModel.h"
#import "MyselfDetailViewController.h"


@interface MapActivityPeoplesViewController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *activityAppls;
@end

@implementation MapActivityPeoplesViewController


-(id)initWithActivityAppls:(NSMutableArray *)activityAppls;
{
    self = [super init];
    if (self) {
        self.activityAppls = activityAppls;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"查看报名人数" andShowButton:YES];
    [self initTableView];
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
    
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.rowHeight = 75;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activityAppls count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MapActivityPeoplesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[MapActivityPeoplesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%i",indexPath.row];
    MapActivityApplysModel *model = [self.activityAppls objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
    
}
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MapActivityApplysModel *model = [self.activityAppls objectAtIndex:indexPath.row];
    MyselfDetailViewController *detail = [[MyselfDetailViewController alloc] initWithTitle:model.userName userId:model.userId userKey:@""];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
