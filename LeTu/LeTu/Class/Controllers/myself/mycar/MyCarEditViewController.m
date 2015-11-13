//
//  MyCarEditViewController.m
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "MyCarEditViewController.h"
#import "MyselfDetailCell.h"
#import "DTImage+Category.h"
#import "MyCarDetilUpdateViewController.h"
#import "MyCarEditCell.h"
#import "MyCarUpdateTableViewController.h"

@interface MyCarEditViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)TableView *tableView;
@property(nonatomic,strong)UIButton *senderButton;

@property(nonatomic,strong)NSArray *keyArray;
@property(nonatomic,strong)NSMutableArray *valueArray;

@property(nonatomic,strong)UIImage *carImage;

@property(nonatomic,strong)NSDictionary *dictionary;
@end

@implementation MyCarEditViewController


-(id)initWithDictionary:(NSDictionary *)dictionary array:(NSMutableArray*)array
{
    self = [super init];
    if (self) {
        self.valueArray = array;
        self.dictionary = dictionary;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self setTitle:@"填写车辆信息" andShowButton:YES];
    self.keyArray = [[NSArray alloc] initWithObjects:@"车辆地",@"牌照编码",@"座位数",@"车种",@"车型",@"照片", nil];
//    self.valueArray = [[NSMutableArray alloc] initWithObjects:@"粤",@"YB565787",@"5",@"家用轿车",@"奥迪A7",@"",nil];
    if ([self.valueArray count]!=5) {
        self.valueArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"5",@"",@"", nil];
    }
    [self initTableView];
    [self initRightBarButtonItem];
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
    if (indexPath.row==2) {
        static NSString *CellIdentifier = @"Cell";
        MyCarEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (! cell) {
            cell = [[MyCarEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.keyLabel.textColor = [UIColor grayColor];
        cell.valueLabel.textColor = [UIColor blackColor];
        cell.keyLabel.text = [self.keyArray objectAtIndex:indexPath.row];
        if ([self.valueArray count]>0 && [self.valueArray count]==5) {
            cell.valueLabel.text = [self.valueArray objectAtIndex:indexPath.row];
        }else{
            cell.valueLabel.text = @"0";
        }
        [cell setCallBack:^(int value) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%i",value]];
        }];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (! cell) {
            cell = [[MyselfDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        MyselfDetailCell *detailCell = (MyselfDetailCell*)cell;
//        detailCell.key = [self.keyArray objectAtIndex:indexPath.row];
        detailCell.valueLabel.textAlignment = NSTextAlignmentRight;
        detailCell.keyLabel.textColor = [UIColor grayColor];
        detailCell.valueLabel.textColor = [UIColor blackColor];
        detailCell.keyLabel.text = [self.keyArray objectAtIndex:indexPath.row];
        if (indexPath.row==5) {
            if (self.dictionary !=nil) {
                detailCell.faceUrl = [self.dictionary objectForKey:@"photo"];
            }else{
                detailCell.faceUrl = @"";
//                [detailCell.headImgView setImage:PLACEHOLDER forState:UIControlStateNormal];
                detailCell.headImgView.image = PLACEHOLDER;
            }
            detailCell.headImgView.userInteractionEnabled = NO;
        }else if (indexPath.row==4) {
            if ([self.valueArray count]>0 && [self.valueArray count]==5) {
                detailCell.valueLabel.text = [self.valueArray objectAtIndex:indexPath.row];
            }
        }else{
            if ([self.valueArray count]>0 && [self.valueArray count]==5) {
                detailCell.valueLabel.text = [self.valueArray objectAtIndex:indexPath.row];
            }
        }
        return detailCell;
    }
    
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==5) {
        return 70.0f;
    }
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==5) {//照片
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"相册",nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
        actionSheet.tag = 1;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }else if (indexPath.row==0){
        /*
        MyCarDetilUpdateViewController *updateVC = [[MyCarDetilUpdateViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] title:@"修改车辆地" block:^(NSString *content,NSString *brindId) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:content];
            [self.tableView reloadData];
            
        }];
        [self.navigationController pushViewController:updateVC animated:YES];
         //*/
        MyCarUpdateTableViewController *tableViewVC = [[MyCarUpdateTableViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] title:@"修改车辆地" type:@"1" block:^(NSString *content) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:content];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:tableViewVC animated:YES];
        
        
    }else if (indexPath.row==1){
        MyCarDetilUpdateViewController *updateVC = [[MyCarDetilUpdateViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] title:@"修改牌照编码" block:^(NSString *content,NSString *brindId) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:content];
            [self.tableView reloadData];
            
        }];
        [self.navigationController pushViewController:updateVC animated:YES];
    }else if (indexPath.row==3){
        /*
        MyCarDetilUpdateViewController *updateVC = [[MyCarDetilUpdateViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] title:@"修改车种" block:^(NSString *content,NSString *brindId) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:content];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:updateVC animated:YES];
         //*/
        MyCarUpdateTableViewController *tableViewVC = [[MyCarUpdateTableViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] title:@"修改车种" type:@"2" block:^(NSString *content) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:content];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:tableViewVC animated:YES];
        
    }else if (indexPath.row==4){
        /*
        MyCarDetilUpdateViewController *updateVC = [[MyCarDetilUpdateViewController alloc] initWithContent:[self.valueArray objectAtIndex:indexPath.row] title:@"修改车型" block:^(NSString *content) {
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:content];
            [self.tableView reloadData];
            
        }];
        [self.navigationController pushViewController:updateVC animated:YES];
         //*/
        MyCarDetilUpdateViewController *updateVC = [[MyCarDetilUpdateViewController alloc] initWithBrandAndblock:^(NSString *content,NSString *brindId) {
            self.brandId = brindId;
            [self.valueArray replaceObjectAtIndex:indexPath.row withObject:content];
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
    }
}
//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    
    MyselfDetailCell *cell = (MyselfDetailCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    self.carImage = [image imageWithMaxImagePix:500 compressionQuality:0.5];
//    [cell.headImgView setImage:self.carImage forState:UIControlStateNormal];
    cell.headImgView.image = self.carImage;
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self createMyCar];
}
/**
 *  创建我的汽车
 */
-(void)createMyCar
{
    NSString *string = @"";
    for (int i=0; i<4; i++) {
        NSString *valueString = [self.valueArray objectAtIndex:i];
        string = [NSString stringWithFormat:@"%@,%@",string,valueString];
    }
    string = [string substringFromIndex:1];
    /*
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?login", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:[self.valueArray objectAtIndex:4] forKey:@"name"];
    [paramDict setObject:string forKey:@"content"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
     //*/
    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar/myCarService.jws?createMyCar", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:[self.valueArray objectAtIndex:4] forKey:@"name"];
    [request setPostValue:self.brandId forKey:@"brandId"];
    [request setPostValue:string forKey:@"content"];
    [request setData:UIImagePNGRepresentation(self.carImage) forKey:@"carPhoto"];
    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:20];
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
//请求成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.callBack) {
        self.callBack();
    }
    [self messageToast:@"保存车辆信息成功!"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self messageShow:@"网络繁忙，请稍后在试！"];
}
@end
