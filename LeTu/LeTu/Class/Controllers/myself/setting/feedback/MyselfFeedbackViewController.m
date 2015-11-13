//
//  MyselfFeedbackViewController.m
//  LeTu
//
//  Created by DT on 14-7-3.
//
//

#import "MyselfFeedbackViewController.h"
#import "PublishPhotoView.h"
#import "DTImage+Category.h"
#import "GCPlaceholderTextView.h"

@interface MyselfFeedbackViewController()<PublishPhotoViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)GCPlaceholderTextView *textView;
@property(nonatomic,strong)PublishPhotoView *imageView;

@property(nonatomic,strong)UIImage *addImage;
@property(nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation MyselfFeedbackViewController

-(id)initWithImage:(UIImage*)image
{
    self = [super init];
    if (self) {
        self.image = image;
        self.addImage = [UIImage imageNamed:@"posting_dialogbox_icon_add"];
        self.imageArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self setTitle:@"意见反馈" andShowButton:YES];
    if (self.image != nil) {
        [self.imageArray addObject:self.image];
    }else{
        [self.imageArray addObject:self.addImage];
    }
    
    [self initRightBarButtonItem:[UIImage imageNamed:@"posting_headbar_icon_send_current"]
                highlightedImage:[UIImage imageNamed:@"posting_headbar_icon_send_press"]];
    [self initViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)clickRightButton:(UIButton *)button
{
    if ([[self.textView text] isEqualToString:@""] && [self.imageArray count] == 1) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发布内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}else{
    [self.textView resignFirstResponder];
    [self submitConent];
}
}
/**
 *  初始化界面
 */
- (void)initViews
{
    self.textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(0, 44, FRAME_WIDTH, 70)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.placeholder = @"欢迎您提出使用搭一程客户端感受和意见,期待您的声音～";
//    self.textView.text = @"";
    self.textView.font = [UIFont systemFontOfSize:15.0f];
//    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
    
    self.imageView = [[PublishPhotoView alloc] initWithFrame:CGRectMake(0, 104, FRAME_WIDTH, 60)];
    self.imageView.backgroundColor = [UIColor whiteColor];
    if (self.image==nil) {
        self.imageView.isAddImage = YES;
    }else{
        self.imageView.isAddImage = NO;
    }
    self.imageView.parameter = self.imageArray;
    self.imageView.delegate = self;
    [self.view addSubview:self.imageView];
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
        /*
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
         //*/
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
    if (actionSheet.tag==9999) {
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
    }else{
        if (buttonIndex==0) {//删除图片
            [self.imageArray removeObjectAtIndex:actionSheet.tag];
            [self.imageArray addObject:self.addImage];
            self.imageView.isAddImage = YES;
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
//    [self.imageArray addObject:self.addImage];
    self.imageView.isAddImage = NO;
    self.imageView.parameter = self.imageArray;
}

/**
 *  发布意见反馈
 */
- (void)submitConent
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height +=20;
        self.view.frame = frame;
    }
    
    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@suggestion/suggestionService.jws?create", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    [request setPostValue:self.textView.text forKey:@"content"];
    
    if ([self.imageArray count] >=1) {
        [request setData:UIImagePNGRepresentation([self.imageArray objectAtIndex:0]) forKey:@"logPic"];
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
