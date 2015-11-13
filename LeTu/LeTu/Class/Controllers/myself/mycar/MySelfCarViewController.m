//
//  MySelfCarViewController.m
//  LeTu
//
//  Created by DT on 14-6-5.
//
//

#import "MySelfCarViewController.h"
#import "EGOImageView.h"
#import "UserModel.h"
#import "DTImage+Category.h"

@interface MySelfCarViewController()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSOperationQueue *queue;
    BOOL isScaled;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)EGOImageView *carImageView;
@property(nonatomic,strong)UserModel *model;
@end

@implementation MySelfCarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self setTitle:@"我的汽车" andShowButton:YES];
    [self initRightBarButtonItem:@"选择"];
    [self initScrollView];
    self.model = self.appDelegate.userModel;
    self.carImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,self.model.carPhoto]];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HIDETABBAR;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)clickRightButton:(UIButton *)button
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"相册",nil];
    actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
    actionSheet.tag = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
/**
 *  初始化scrollView
 */
- (void)initScrollView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, FRAME_WIDTH, height)];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.carImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, height)];
    self.carImageView.backgroundColor = [UIColor clearColor];
//    self.carImageView.image = [UIImage imageNamed:@"me_headphoto"];
//    self.carImageView.clipsToBounds = YES;
    self.carImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.carImageView];
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 3.0;
    [self.scrollView setZoomScale:scroll.minimumZoomScale];
    UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGR.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapGR];//双击事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self.scrollView addGestureRecognizer:longPress];//长按事件
    [self.view addSubview:self.scrollView];
}
#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.carImageView;
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {//相机
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
    }else if (actionSheet.tag ==2){
        if (buttonIndex ==0) {//保存
            UIImage *image = self.carImageView.image;
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
	NSString *msg = nil ;
	if(error != NULL){
		msg = @"保存图片失败" ;
	}else{
		msg = @"保存图片成功" ;
	}
    [self messageToast:msg];
}
//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    self.carImageView.image = image;
    [self carPhotoUpdate:[image imageWithMaxImagePix:600 compressionQuality:0.5]];
}
//长按事件的实现方法
- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"UIGestureRecognizerStateBegan");
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"保存到相册",nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
        actionSheet.tag = 2;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged");
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded");
    }
}
//双击事件
-(void)doubleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.scrollView];
    if(isScaled == YES){
        [self zoomToPointInRootView:point atScale:1];
        isScaled = NO;
    }else{
        [self zoomToPointInRootView:point atScale:2];
        isScaled = YES;
    }
}
- (void)zoomToPointInRootView:(CGPoint)center atScale:(float)scale {
    CGRect zoomRect;
    zoomRect.size.height = [self.scrollView frame].size.height / scale;
    zoomRect.size.width  = [self.scrollView frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    [self.scrollView zoomToRect:zoomRect animated:YES];
}
/**
 *  我的汽车图片修改
 *
 *  @param image 修改图片
 */
- (void)carPhotoUpdate:(UIImage*)image
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:@"carPhoto" forKey:@"item"];
    [request setData:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"carPhoto"]];
    [request buildPostBody];
    request.tag=888;
    [request setDelegate:self];
    [request setTimeOutSeconds:60];
    [request startAsynchronous];
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
                NSString *photo = [dict objectForKey:@"obj"];
                UserModel *model = self.appDelegate.userModel;
                model.carPhoto = photo;
                [[[[iToast makeText:@"我的汽车图片修改成功！"] setDuration:iToastDurationNormal] setGravity:iToastGravityCenter] show];
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
