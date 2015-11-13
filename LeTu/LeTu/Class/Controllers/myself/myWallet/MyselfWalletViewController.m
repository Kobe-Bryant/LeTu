//
//  MyselfWalletViewController.m
//  LeTu
//
//  Created by DT on 14-5-20.
//
//

#import "MyselfWalletViewController.h"
#import "MyselfWalletCell.h"

@interface MyselfWalletViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)TableView *tableView;
@property(nonatomic,strong)UIView *tableHeaderView;
@end

@implementation MyselfWalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"我的红包" andShowButton:YES];
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化tableHeaderView
 */
- (void)initTableHeaderView
{
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 88)];
    self.tableHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mypacket_item_bg"]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.text = @"总余额 (元)";
    [self.tableHeaderView addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 160, 30)];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.font = [UIFont systemFontOfSize:25.0f];
    moneyLabel.text = @"1315.00";
    [self.tableHeaderView addSubview:moneyLabel];
    
    UIButton *extractButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 45, 56, 26)];
    [extractButton setImage:[UIImage imageNamed:@"mypacket_tixian_btn_normal"] forState:UIControlStateNormal];
    [extractButton setImage:[UIImage imageNamed:@"mypacket_tixian_btn_press"] forState:UIControlStateHighlighted];
    [extractButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    extractButton.tag = 1;
    [self.tableHeaderView addSubview:extractButton];
    
}
/**
 *  初始化tableView
 */
- (void)initTableView
{
    [self initTableHeaderView];
    
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, FRAME_WIDTH, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.rowHeight = 62.0f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[MyselfWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyselfWalletCell *walletCell = (MyselfWalletCell*)cell;
    return walletCell;
}
/**
 *  按钮点击事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    if (button.tag==1) {//提现按钮
        
    }
}
@end
