//
//  MyCarUpdateTableViewController.m
//  LeTu
//
//  Created by DT on 14-8-1.
//
//
// ┏ ┓　　　┏ ┓
//┏┛ ┻━━━━━┛ ┻┓
//┃　　　　　　 ┃
//┃　　　━　　　┃
//┃　┳┛　  ┗┳　┃
//┃　　　　　　 ┃
//┃　　　┻　　　┃
//┃　　　　　　 ┃
//┗━┓　　　┏━━━┛
//  ┃　　　┃   DT专属
//  ┃　　　┃   神兽镇压
//  ┃　　　┃   代码无BUG！
//  ┃　　　┗━━━━━━━━━┓
//  ┃　　　　　　　    ┣┓
//  ┃　　　　         ┏┛
//  ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//    ┃ ┫ ┫   ┃ ┫ ┫
//    ┗━┻━┛   ┗━┻━┛
//

#import "MyCarUpdateTableViewController.h"

@interface MyCarUpdateTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CallBack1 callBack;
}
@property(nonatomic,strong)UIButton *senderButton;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *type;

@property(nonatomic,strong)NSArray *array;
@end

@implementation MyCarUpdateTableViewController

-(id)initWithContent:(NSString *)content title:(NSString *)title type:(NSString*)type block:(CallBack1)block
{
    self = [super init];
    if (self) {
        callBack = block;
        self.content = content;
        self.titleName = title;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:self.titleName andShowButton:YES];
    [self initRightBarButtonItem];
    if ([self.type isEqualToString:@"1"]) {
        self.array = [[NSArray alloc] initWithObjects:@"京",@"沪",@"津",@"渝",@"黑",@"吉",@"辽",@"蒙",@"冀",@"新",@"甘",@"青",@"陕",@"宁",@"豫",@"鲁",@"晋",@"皖",@"鄂",@"湘",@"苏",@"川",@"贵",@"云",@"桂",@"藏",@"浙",@"赣",@"粤",@"闽",@"台",@"琼",@"港",@"澳", nil];
    }else if ([self.type isEqualToString:@"2"]) {
        self.array = [[NSArray alloc] initWithObjects:@"轿车",@"SUV",@"越野车",@"跑车",@"商务车", nil];
    }
    [self initTableView];
    for (int i=0; i<[self.array count]; i++) {
        NSString *value = [self.array objectAtIndex:i];
        if ([value isEqualToString:self.content]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化发送按钮
 */
- (void)initRightBarButtonItem
{
    self.senderButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 7, 45, 30)];
    [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_press"] forState:UIControlStateNormal];
    [self.senderButton setImage:[UIImage imageNamed:@"myinformation_save_press1"] forState:UIControlStateHighlighted];
    [self.senderButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    self.senderButton.tag = 0;
    [self.view addSubview:self.senderButton];
    
    self.senderButton.enabled = NO;
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    if (callBack) {
        callBack(self.content);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  初始化tableView
 */
-(void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height - STATUSBAR_HEIGHT -NAVBAR_HEIGHT;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, 320, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tag = 1;
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.senderButton.enabled = YES;
    self.content = [self.array objectAtIndex:indexPath.row];
}
@end
