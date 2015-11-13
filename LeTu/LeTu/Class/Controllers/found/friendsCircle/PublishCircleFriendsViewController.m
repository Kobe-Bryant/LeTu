//
//  PublishCircleFriendsViewController.m
//  LeTu
//
//  Created by DT on 14-5-19.
//
//

#import "PublishCircleFriendsViewController.h"
#import "PublishPhotoView.h"
#import "KLSwitch.h"
#import "DTImage+Category.h"

@interface PublishCircleFriendsViewController ()<PublishPhotoViewDelegate,UIActionSheetDelegate,
    UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)PublishPhotoView *imageView;
@property(nonatomic,strong)UILabel *locationLabel;

@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UIImage *addImage;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,assign)BOOL isLocation;
@property(nonatomic,strong)KLSwitch *switchLocation;
@end

@implementation PublishCircleFriendsViewController

-(id)initWithImage:(UIImage *)image block:(CallBack)block;
{
    self = [super init];
    if (self) {
        callBack = block;
        self.image = image;
        self.addImage = [UIImage imageNamed:@"posting_dialogbox_icon_add"];
        self.imageArray = [[NSMutableArray alloc] init];
        self.isLocation = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    if (self.image != nil) {
        [self.imageArray addObject:self.image];
    }
    [self.imageArray addObject:self.addImage];
    
    [self setTitle:@"发布说说" andShowButton:YES];
    [self initRightBarButtonItem];
    [self initViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)initRightBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 9, 45, 26)];
    [backButton setImage:[UIImage imageNamed:@"posting_headbar_icon_send_current"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"posting_headbar_icon_send_press"] forState:UIControlStateHighlighted];
    backButton.tag = 0;
    [backButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)initViews
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, FRAME_WIDTH, 70)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = @"";
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
    
    self.imageView = [[PublishPhotoView alloc] initWithFrame:CGRectMake(0, 104, FRAME_WIDTH, 60)];
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.isAddImage = YES;
    self.imageView.parameter = self.imageArray;
    self.imageView.delegate = self;
    [self.view addSubview:self.imageView];
    
    /*
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 164, FRAME_WIDTH, 1)];
    lineImage.image = [UIImage imageNamed:@"posting_line@2x"];
    [self.view addSubview:lineImage];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 165, FRAME_WIDTH, 40)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    locationButton.tag = 1;
    [locationButton setImage:[UIImage imageNamed:@"posting_dialogbox_icon_location"] forState:UIControlStateNormal];
    [locationButton setImage:[UIImage imageNamed:@"posting_dialogbox_icon_location"] forState:UIControlStateHighlighted];
    [locationButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:locationButton];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, FRAME_WIDTH - 95, 30)];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.font = [UIFont systemFontOfSize:14.0f];
    self.locationLabel.textAlignment = UITextAlignmentCenter;
    self.locationLabel.text = self.appDelegate.address;
    [footView addSubview:self.locationLabel];
     
    self.switchLocation = [[KLSwitch alloc]
                           initWithFrame:CGRectMake(FRAME_WIDTH - 60, 5, 45, 30) didChangeHandler:^(BOOL isOn) {
                               if (isOn) {
                                   NSLog(@"定位开启");
                                   self.locationLabel.hidden = NO;
                               }else{
                                   NSLog(@"定位不开启");
                                   self.locationLabel.hidden = YES;
                               }
    }];
    [self.switchLocation setOn:YES animated:YES];
    self.switchLocation.backgroundColor = [UIColor clearColor];
    self.switchLocation.contrastColor = RGBCOLOR(196, 196, 196);
    self.switchLocation.onTintColor = RGBCOLOR(41, 159, 249);
    [footView addSubview:self.switchLocation];
    //*/
    
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    if (button.tag==0) {//发送按钮
        if ([[self.textView text] isEqualToString:@""] && [self.imageArray count] == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发布内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            [self.textView resignFirstResponder];
            [self submitConent];
        }
    }else if (button.tag==1){//定位按钮
    
    }
    /*
    else if (button.tag==2){//是否定位按钮
        if (self.isLocation) {
            self.isLocation = NO;
            [button setImage:[UIImage imageNamed:@"posting_dialogbox_icon_switch_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"posting_dialogbox_icon_switch_normal"] forState:UIControlStateHighlighted];
//            self.locationLabel.text = @"";
        }else{
            self.isLocation = YES;
            [button setImage:[UIImage imageNamed:@"posting_dialogbox_icon_switch_current"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"posting_dialogbox_icon_switch_current"] forState:UIControlStateHighlighted];
//            self.locationLabel.text = @"广州市彩频路11号广东科技园";
        }
    }
     //*/
}
#pragma mark PublishPhotoViewDelegate
- (void)photoView:(PublishPhotoView*)photoView index:(int)index isAddImage:(BOOL)isAddImage
{
    if (isAddImage) {
        UIActionSheet *actionSheetTemp = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍照",@"相册", nil];
        actionSheetTemp.tag = 9999;
        [actionSheetTemp showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        UIActionSheet *actionSheetTemp = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:nil
//                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"删除图片"
                                                            otherButtonTitles:@"查看", nil];
        actionSheetTemp.tag = index;
        [actionSheetTemp showInView:[UIApplication sharedApplication].keyWindow];
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==9999) {//添加图片
        if (buttonIndex==0) {//拍照
            //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = NO;//设置可编辑
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];//进入照相界面
        }else if (buttonIndex==1){//相册
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker animated:YES];
        }
    }else{//查看图片
        if (buttonIndex==0) {//删除图片
            [self.imageArray removeObjectAtIndex:actionSheet.tag];
            self.imageView.parameter = self.imageArray;
        }else if (buttonIndex==1){//全屏查看图片
            
        }
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    [self.imageArray removeLastObject];
    [self.imageArray addObject:[image imageWithMaxImagePix:500 compressionQuality:0.5]];
    [self.imageArray addObject:self.addImage];
    self.imageView.parameter = self.imageArray;
}
/**
 *  发布微博
 */
- (void)submitConent
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height +=20;
        self.view.frame = frame;
    }
    
    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@sns/miniBlogService.jws?add", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    if (self.isLocation) {
        [request setPostValue:self.locationLabel.text forKey:@"location"];
    }
    [request setPostValue:self.textView.text forKey:@"content"];
    
    [request setPostValue:[NSString stringWithFormat:@"%i",[self.imageArray count]-1] forKey:@"imgCount"];
    if ([self.imageArray count]>1) {
        for (int i=0; i<[self.imageArray count]-1; i++) {
            [request setData:UIImagePNGRepresentation([self.imageArray objectAtIndex:i]) forKey:[NSString stringWithFormat:@"imgFile%d", i + 1]];
        }
    }
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
    [self stopLoading];
    
    NSError *error = [request error];
    if (!error){
        //发送消息
        if (request.tag==888){
            JSONDecoder *decoder=[JSONDecoder decoder];
            NSDictionary *dict=[decoder objectWithData:request.responseData];
            NSDictionary *errDict=[dict objectForKey:@"error"];
            int err_code=[[errDict objectForKey:@"err_code"] intValue];
            if(err_code==0 || err_code==1){
                [[[[iToast makeText:@"提交成功！"] setDuration:iToastDurationNormal] setGravity:iToastGravityCenter] show];
                if (callBack) {
                    callBack(0);
                }
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
    [self stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (request.tag==888)
    {
        [self messageShow:@"网络繁忙，请稍后在试！"];
    }
}
@end
