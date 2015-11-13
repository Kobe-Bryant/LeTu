//
//  MapCreateActivityViewController.m
//  LeTu
//
//  Created by DT on 14-6-19.
//
//

#import "MapCreateActivityViewController.h"
#import "MyselfDetailCell.h"
#import "MapActivityBoxViewController.h"
#import "MapPopupView.h"

@interface MapCreateActivityViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MapPopupView *popupView;
@property(nonatomic,strong)UIButton *publishButton;

@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,strong)UIImage *logImage;
@end

@implementation MapCreateActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"创建活动" andShowButton:YES];
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 60)];
    self.publishButton = [[UIButton alloc] initWithFrame:CGRectMake(45, 15, 230, 40)];
    [self.publishButton setImage:[UIImage imageNamed:@"fabu_normal"] forState:UIControlStateNormal];
    [self.publishButton setImage:[UIImage imageNamed:@"fabu_press"] forState:UIControlStateHighlighted];
    self.publishButton.tag = 5;
    [self.publishButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:self.publishButton];
    self.tableView.tableFooterView = tableFooterView;
    
    [self.view addSubview:self.tableView];
}
-(void)clickButton:(UIButton*)button
{
    self.publishButton.enabled = NO;
    [self createActivity:self.subject address:self.address count:self.count startTime:self.startTime logImage:self.logImage];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyselfDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[MyselfDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.keyLabel.textColor = RGBCOLOR(50, 161, 245);
    
    switch (indexPath.row) {
        case 0:{
            cell.keyLabel.text = @"主题";
            cell.valueLabel.textColor = [UIColor grayColor];
            cell.valueLabel.text = @"请填写活动主题";
            break;
        }case 1:{
            cell.keyLabel.text = @"时间";
            cell.valueLabel.textColor = [UIColor grayColor];
            cell.valueLabel.text = @"请选择活动时间";
            break;
        }case 2:{
            cell.keyLabel.text = @"地点";
            cell.valueLabel.textColor = [UIColor grayColor];
            cell.valueLabel.text = @"请填写活动地点";
            break;
        }case 3:{
            cell.keyLabel.text = @"人数";
            cell.valueLabel.textColor = [UIColor grayColor];
            cell.valueLabel.text = @"请填写参与活动人数";
            break;
        }case 4:{
            cell.keyLabel.text = @"图片";
            cell.faceUrl = @"";
            break;
        }
        default:
            break;
    }
    return cell;
    
}
#pragma mark UITableViewDelegate
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (indexPath.row==4) {
         return 75;
     }
     return 44;
 }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyselfDetailCell *cell = (MyselfDetailCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:{//主题
            MapActivityBoxViewController *boxVC =[[MapActivityBoxViewController alloc] initWithType:indexPath.row content:[cell.valueLabel.text isEqualToString:@"请填写活动主题"]?@"":cell.valueLabel.text block:^(NSString *value) {
                self.subject = value;
                cell.valueLabel.text = value;
                cell.valueLabel.textColor = [UIColor blackColor];
            }];
            [self.navigationController pushViewController:boxVC animated:YES];
            break;
        }case 1:{//时间
            [self showPopupView:2];
            break;
        }case 2:{//地点
            MapActivityBoxViewController *boxVC =[[MapActivityBoxViewController alloc] initWithType:indexPath.row content:[cell.valueLabel.text isEqualToString:@"请填写活动地点"]?@"":cell.valueLabel.text block:^(NSString *value) {
                self.address = value;
                cell.valueLabel.text = value;
                cell.valueLabel.textColor = [UIColor blackColor];
                
            }];
            [self.navigationController pushViewController:boxVC animated:YES];
            break;
        }case 3:{//人数
            MapActivityBoxViewController *boxVC =[[MapActivityBoxViewController alloc] initWithType:indexPath.row content:[cell.valueLabel.text isEqualToString:@"请填写参与活动人数"]?@"":cell.valueLabel.text block:^(NSString *value) {
                self.count = value;
                cell.valueLabel.text = value;
                cell.valueLabel.textColor = [UIColor blackColor];
            }];
            [self.navigationController pushViewController:boxVC animated:YES];
            break;
        }case 4:{//图片
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍照",@"从相册选择",nil];
            actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            break;
        }
        default:
            break;
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
}
//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:NO];
    self.logImage = image;
    MyselfDetailCell *cell = (MyselfDetailCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [cell.headImgView setImage:image forState:UIControlStateNormal];
}

/**
 *  显示弹出试图
 */
-(void)showPopupView:(int)type
{
    if (!self.popupView) {
        int height = [UIScreen mainScreen].bounds.size.height - STATUSBAR_HEIGHT;
        self.popupView = [[MapPopupView alloc] initWithFrame:CGRectMake(0, 20, 320, height)];
        self.popupView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.appDelegate.window addSubview:self.popupView];
        
        __block MapCreateActivityViewController *blockSelf = self;
        [self.popupView setCallBack:^(int type, int status,NSString *value) {
            if (status ==2) {
                [blockSelf hidePopupView];
            }else{
                if (type==2) {//时间
                    blockSelf.startTime = value;
                    MyselfDetailCell *cell = (MyselfDetailCell*)[blockSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    cell.valueLabel.text = value;
                    cell.valueLabel.textColor = [UIColor blackColor];
                    [cell setNeedsLayout];
                }
                [blockSelf hidePopupView];
            }
        }];
    }
    self.popupView.type = type;
    
    self.popupView.hidden = NO;
    CGRect frame = self.popupView.showView.frame;
    frame.origin.y +=self.popupView.showView.frame.size.height;
    self.popupView.showView.frame = frame;
    [UIView animateWithDuration:0.25 animations:^{
        int height = [UIScreen mainScreen].bounds.size.height - STATUSBAR_HEIGHT;
        self.popupView.showView.frame = CGRectMake(0, height-250, 320, 250);
    }];
}
-(void)hidePopupView
{
    [UIView animateWithDuration:0.25 animations:^{
        int height = [UIScreen mainScreen].bounds.size.height - STATUSBAR_HEIGHT;
        self.popupView.showView.frame = CGRectMake(0, height, 320, 250);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.popupView.hidden = YES;
        }];
    }];
}
/**
 *  创建活动
 *
 *  @param subject   主题
 *  @param address   地址
 *  @param count     人数
 *  @param startTime 时间
 *  @param logImage  照片
 */
-(void)createActivity:(NSString*)subject address:(NSString*)address count:(NSString*)count startTime:(NSString*)startTime logImage:(UIImage*)logImage
{
    NSLog(@"%@",subject);
    NSLog(@"%@",address);
    NSLog(@"%@",count);
    NSLog(@"%@",startTime);
    
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@activity/activityService.jws?create", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:subject forKey:@"subject"];
    [request setPostValue:address forKey:@"address"];
    [request setPostValue:count forKey:@"count"];
    [request setPostValue:[startTime stringByAppendingString:@":00"] forKey:@"startTime"];
    [request setData:UIImagePNGRepresentation(logImage) forKey:@"logPath"];
    
    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:120];
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.publishButton.enabled = YES;
    
    NSError *error = [request error];
    if (!error){
        //发送消息
        if (request.tag==888){
            JSONDecoder *decoder=[JSONDecoder decoder];
            NSDictionary *dict=[decoder objectWithData:request.responseData];
            NSDictionary *errDict=[dict objectForKey:@"error"];
            int err_code=[[errDict objectForKey:@"err_code"] intValue];
            if(err_code==0 || err_code==1){
                if (self.callBack) {
                    self.callBack();
                }
                [[[[iToast makeText:@"创建活动成功！"] setDuration:iToastDurationNormal] setGravity:iToastGravityCenter] show];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSString *errMsg = [errDict objectForKey:@"err_msg"];
                if (!errMsg || [errMsg isEqualToString:@""]){
                    errMsg = @"提交失败！";
                }
                [self messageShow:errMsg];
            }
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.publishButton.enabled = YES;
    if (request.tag==888)
    {
        [self messageShow:@"网络繁忙，请稍后在试！"];
    }
}
@end
