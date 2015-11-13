//
//  AddContactViewController.m
//  LeTu
//
//  Created by mac on 14-5-15.
//
//

#import "AddContactViewController.h"
#import "SearchContactViewController.h"
@interface AddContactViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation AddContactViewController

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
    
    [self setTitle:@"添加联系人" andShowButton:YES];
    [self initViews];
    
}
- (void)initViews
{
    int height = [UIScreen mainScreen].bounds.size.height - STATUSBAR_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStyleGrouped];
    self.tableView.backgroundView= nil;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    if (iOS_7_Above) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }

}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 17.5;
    }
    return 18;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return 5;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    if (indexPath.section==0)
    {
        cell.textLabel.text = @"通过乐途号添加";
        cell.imageView.image = [UIImage imageNamed:@"Add contacts_icon_letu"];
    }else if (indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"通讯录好友";
                cell.imageView.image = [UIImage imageNamed:@"Add contacts_icon_phone"];
                break;
            case 1:
                cell.textLabel.text = @"新浪微博好友";
                cell.imageView.image = [UIImage imageNamed:@"Add contacts_icon_xinl"];
                break;
            case 2:
                cell.textLabel.text = @"微信好友";
                cell.imageView.image = [UIImage imageNamed:@"Add contacts_icon_weixin"];
                break;
            case 3:
                cell.textLabel.text = @"腾讯微博好友";
                cell.imageView.image = [UIImage imageNamed:@"Add contacts_icon_tengxun"];
                break;
            case 4:
                cell.textLabel.text = @"人人网好友";
                cell.imageView.image = [UIImage imageNamed:@"Add contacts_icon_renren"];
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section==2)
    {
        cell.textLabel.text = @"创建群组";
        cell.imageView.image = [UIImage imageNamed:@"Add contacts_icon_group"];
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section==0) {
        

        SearchContactViewController *VC = [[SearchContactViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
