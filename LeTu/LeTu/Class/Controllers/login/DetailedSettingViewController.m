//
//  DetailedSettingViewController.m
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "DetailedSettingViewController.h"
#import "MyselfDetailCell.h"
#import "MyselfDetilUpdateViewController.h"
#import "DTImage+Category.h"

@interface DetailedSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,copy)NSString *userKey;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *account;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *gender;

@property(nonatomic,strong)NSArray *keyArray;
@property(nonatomic,strong)NSMutableArray *valueArray;
@property(nonatomic,strong)UIImage *image;
@end

@implementation DetailedSettingViewController


-(id)initWithAccount:(NSString *)account password:(NSString*)password
{
    self = [super init];
    if (self) {
        self.account = account;
        self.password = password;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"详细设置" andShowButton:NO];
    [self initRightBarButtonItem:[UIImage imageNamed:@"Blacklist_finish_btn_current"]
                highlightedImage:[UIImage imageNamed:@"Blacklist_finish_btn_press"]];
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    self.keyArray = [[NSArray alloc] initWithObjects:@"头像",@"昵称",@"性别",@"年龄",@"个性签名",@"地区", nil];
    self.valueArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"", nil];
    self.image = PLACEHOLDER;
    
    [self getUserKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)clickRightButton:(UIButton *)button
{
//    [self.appDelegate showLoginView];
    [self.appDelegate showMainView];
}
/**
 *  获取用户验证码
 */
-(void)getUserKey
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?login", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:self.account forKey:@"login_name"];
    [paramDict setObject:self.password forKey:@"password"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
//请求成功
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag==1) {
        NSDictionary *objDict = [data objectForKey:@"obj"];
        self.userKey = [objDict objectForKey:@"key"];
        self.userId = [objDict objectForKey:@"id"];
        
        [self initTableView];
    }else if (tag==4){//修改性别
        UserModel *model = self.appDelegate.userModel;
        model.gender = self.gender;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"informationRevised" object:nil];
        [self messageToast:@"性别修改成功"];
    }
}
/**
 *  初始化tableView
 */
- (void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[MyselfDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MyselfDetailCell *detailCell = (MyselfDetailCell*)cell;
    detailCell.key = [self.keyArray objectAtIndex:indexPath.row];
    detailCell.valueLabel.textAlignment = NSTextAlignmentRight;
    detailCell.keyLabel.textColor = [UIColor blackColor];
    detailCell.valueLabel.textColor = [UIColor grayColor];
    switch (indexPath.row) {
        case 0:{
            detailCell.faceUrl = [self.valueArray objectAtIndex:indexPath.row];
//            [detailCell.headImgView setImage:self.image forState:UIControlStateNormal];
            detailCell.headImgView.image = self.image;
            break;
        }
        case 1:{
            detailCell.value = [self.valueArray objectAtIndex:indexPath.row];
            break;
        }case 2:{
            detailCell.value = [self.valueArray objectAtIndex:indexPath.row];
            break;
        }case 3:{
            detailCell.value = [self.valueArray objectAtIndex:indexPath.row];
            break;
        }case 4:{
            detailCell.value = [self.valueArray objectAtIndex:indexPath.row];
            break;
        }case 5:{
            detailCell.value = [self.valueArray objectAtIndex:indexPath.row];
            break;
        }
        default:
            break;
    }
    return detailCell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 70.0f;
    }
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {//头像
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"相册",nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
        actionSheet.tag = 1;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.row==1){//昵称
        MyselfDetilUpdateViewController *updateVC = [[MyselfDetilUpdateViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] type:@"0" userKey:self.userKey];
        [updateVC setBlockBack:^(NSString *string) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:string];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:updateVC animated:YES];
    }else if (indexPath.row==2){//性别
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"男",@"女",nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
        actionSheet.tag = 2;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.row==3){//年龄
        MyselfDetilUpdateViewController *updateVC = [[MyselfDetilUpdateViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] type:@"3" userKey:self.userKey];
        [updateVC setBlockBack:^(NSString *string) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:string];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:updateVC animated:YES];
    }else if (indexPath.row==4){//个性签名
        MyselfDetilUpdateViewController *updateVC = [[MyselfDetilUpdateViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] type:@"1" userKey:self.userKey];
        [updateVC setBlockBack:^(NSString *string) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:string];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:updateVC animated:YES];
    }else if (indexPath.row==5){//地区
        MyselfDetilUpdateViewController *updateVC = [[MyselfDetilUpdateViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] type:@"2" userKey:self.userKey];
        [updateVC setBlockBack:^(NSString *string) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:string];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:updateVC animated:YES];
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {//头像
        if (buttonIndex==0) {//拍照
            //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];//进入照相界面
        }else if (buttonIndex==1){//相册
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker animated:YES];
        }
    }else if (actionSheet.tag==2){//性别
        MyselfDetailCell *cell = (MyselfDetailCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        if (buttonIndex==0) {//男
            [self.valueArray replaceObjectAtIndex:2 withObject:@"男"];
            cell.valueLabel.text = @"男";
            self.gender = @"1";
            [self updateSex:self.gender];
        }else if (buttonIndex==1){//女
            [self.valueArray replaceObjectAtIndex:2 withObject:@"女"];
            cell.valueLabel.text = @"女";
            self.gender = @"2";
            [self updateSex:self.gender];
        }
    }
}
//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    
    MyselfDetailCell *cell = (MyselfDetailCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.image = [image imageWithMaxImagePix:500 compressionQuality:0.5];
//    [cell.headImgView setImage:[image imageWithMaxImagePix:500 compressionQuality:0.5] forState:UIControlStateNormal];
    cell.headImgView.image = [image imageWithMaxImagePix:500 compressionQuality:0.5];
    
    [self upLoadSalesBigImage:[image imageWithMaxImagePix:500 compressionQuality:0.5]];
}

/**
 *  修改性别
 *
 *  @param gender 性别类型 1:男 2:女
 */
-(void)updateSex:(NSString*)gender
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [paramDict setObject:self.userKey forKey:@"l_key"];
    [paramDict setObject:@"gender" forKey:@"item"];
    [paramDict setObject:gender forKey:@"gender"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 4;
    [queue addOperation :operation];
}

// 修改头像
- (void)upLoadSalesBigImage:(UIImage*)image
{
    //    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:@"userPhoto" forKey:@"item"];
    [request setPostValue:self.userKey forKey:@"l_key"];
    [request setData:UIImagePNGRepresentation(image) forKey:@"userPhoto"];
    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:120];
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
//请求成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[[[iToast makeText:@"修改头像成功"] setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
}
@end
