//
//  FriendsCircleViewController.m
//  LeTu
//
//  Created by DT on 14-5-7.
//
//

#import "FriendsCircleViewController.h"
#import "FriendsCircleHeadView.h"
#import "TableView.h"
#import "FriendsCircleOtherCell.h"
#import "FriendsCircleMECell.h"
#import "ClassModel.h"
#import "FriendsCircleDetailViewController.h"
#import "PublishCircleFriendsViewController.h"
#import "MiniBlogModel.h"
#import "MyselfDetailViewController.h"
#import "BlogOverheadModel.h"
#import "XHPathCover.h"
#import "DTImage+Category.h"

//static CGFloat kImageOriginHight = 104.f;

@interface FriendsCircleViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,
                                            UIImagePickerControllerDelegate,UINavigationControllerDelegate,FriendsCircleOtherCellDelegate,UITextFieldDelegate>
{
    NSOperationQueue *queue;
    CGRect frame;
    NSString *_action;
    int _index;
}
@property(nonatomic,retain) DTTableView *tableView;
//@property(nonatomic,retain) FriendsCircleHeadView *headView;
/**
 *  视觉差的TableViewHeaderView
 */
@property (nonatomic, strong) XHPathCover *albumHeaderContainerViewPathCover;
//是否是个人的朋友圈
@property(nonatomic,assign)BOOL isMe;
@property(nonatomic,copy)NSString *userId;
//@property(nonatomic,retain)NSMutableArray *itemsArray;
@property(nonatomic,assign)BOOL hasPublish;//是否发布新说说
@property(nonatomic,strong)BlogOverheadModel *model;
@property(nonatomic,strong)MiniBlogModel *blogModel;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)int commentCell;

@property(nonatomic,retain)UIView *commentBoxView;
@property(nonatomic,retain)UIButton *commentBoxButton;
@property(nonatomic,retain)UITextField *commentBoxTextField;


@end

@implementation FriendsCircleViewController

-(id)initWithIsMe:(BOOL)isMe userId:(NSString*)userId;
{
    self = [super init];
    if (self) {
        self.hasPublish = NO;
        self.isMe = isMe;
        self.userId = userId;
//        self.itemsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitle:@"朋友圈" andShowButton:YES];
    if ([self.userId isEqualToString:self.appDelegate.userModel.userId]) {
        [self initRightBarButtonItem:[UIImage imageNamed:@"friendscircle_others_camera_btn_normal"]
                    highlightedImage:[UIImage imageNamed:@"friendscircle_others_camera_btn_current"]];
    }
    if (!self.isMe) {
        [self initRightBarButtonItem:[UIImage imageNamed:@"friendscircle_others_camera_btn_normal"]
                    highlightedImage:[UIImage imageNamed:@"friendscircle_others_camera_btn_current"]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//键盘改变的通知
    [self initTableView];
//    [self BlogOverheadData];
//    [self initCommentBox];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.commentBoxTextField resignFirstResponder];
}
/**
 *  点击照相机事件
 */
- (void)clickRightButton:(UIButton *)button
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"文字",@"拍照",@"从相册选择",nil];
    actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
    actionSheet.tag = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag ==1) {//相机按钮
        if (buttonIndex==0) {//文字
            PublishCircleFriendsViewController *publishVC = [[PublishCircleFriendsViewController alloc] initWithImage:nil block:^(int i) {
                self.hasPublish = YES;
                self.tableView.pageNumber = 0;
                [self fillData];
            }];
            [self.navigationController pushViewController:publishVC animated:YES];
        }else if (buttonIndex==1) {//拍照
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
        }else if (buttonIndex==2){//相册
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker animated:YES];
        }
    }else if (actionSheet.tag ==2){//背景按钮
        
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
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([picker allowsEditing]) {//表示背景相片
        [picker dismissModalViewControllerAnimated:NO];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self hbgPhotoUpdate:image];
        //        self.headView.bgImage.image = image;
        [self.albumHeaderContainerViewPathCover setBackgroundImage:image];
    }else{//表示相机按钮相片
        [picker dismissModalViewControllerAnimated:NO];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        PublishCircleFriendsViewController *publishVC = [[PublishCircleFriendsViewController alloc] initWithImage:image block:^(int i) {
            self.hasPublish = YES;
            [self fillData];
        }];
        [self.navigationController pushViewController:publishVC animated:YES];
    }
    
//    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}
//*/

//*
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:NO];
    if ([picker allowsEditing]) {//表示背景相片
        [self hbgPhotoUpdate:image];
//        self.headView.bgImage.image = image;
        [self.albumHeaderContainerViewPathCover setBackgroundImage:image];
    }else{//表示相机按钮相片
        [picker dismissModalViewControllerAnimated:NO];
        
//        [image imageWithMaxImagePix:500 compressionQuality:0.5]
//        [image imageWithProportion:CGSizeMake(640, 960) percent:0.00001]
        PublishCircleFriendsViewController *publishVC = [[PublishCircleFriendsViewController alloc] initWithImage:[image imageWithMaxImagePix:500 compressionQuality:0.5] block:^(int i) {
            self.hasPublish = YES;
            self.tableView.pageNumber = 0;
            [self fillData];
        }];
        [self.navigationController pushViewController:publishVC animated:YES];
    }
}
 //*/

/**
 *  初始化评论框
 */
- (void)initCommentBox
{
    self.commentBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-23, self.view.frame.size.width, 53)];
    self.commentBoxView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pengyouquan_comment_blank bg"]];
    [self.view addSubview:self.commentBoxView];
    
    self.commentBoxTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 13, 235, 34)];
    self.commentBoxTextField.background = [UIImage imageNamed:@"pengyouquan_content_blank"];
    self.commentBoxTextField.delegate = self;
    self.commentBoxTextField.returnKeyType = UIReturnKeySend;
    self.commentBoxTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.commentBoxTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.commentBoxTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.commentBoxView addSubview:self.commentBoxTextField];
    
    self.commentBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentBoxButton.frame = CGRectMake(251, 13, 59, 34);
    [self.commentBoxButton setImage:[UIImage imageNamed:@"pengyouquan_commet_send_normal"] forState:UIControlStateNormal];
    [self.commentBoxButton setImage:[UIImage imageNamed:@"pengyouquan_commet_send_press"] forState:UIControlStateHighlighted];
    [self.commentBoxButton setTitleColor:[Utility colorWithHexString:@"#F33F6F"] forState:UIControlStateNormal];
    [self.commentBoxButton setTitleColor:[Utility colorWithHexString:@"#FBC3D2"] forState:UIControlStateHighlighted];
    [self.commentBoxButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBoxView addSubview:self.commentBoxButton];
}
/**
 *  初始化tableView
 */
- (void)initTableView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    
    self.tableView = [[DTTableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
//    self.tableView.separatorColor = [UIColor clearColor];
    
    WEAKSELF
    [self.tableView addFooterWithCallback:^{
        [weakSelf fillData];
    }];
    
    /*
    self.headView = [[FriendsCircleHeadView alloc] initWithFrame:CGRectMake(0, -kImageOriginHight, frame.size.width, kImageOriginHight) block:^(int type,NSString *userId, NSString *userName) {
        if (type==2) {//表示点击背景
            if (!self.isMe) {
                UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"拍照",@"从相册选择",nil];
                actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
                actionSheet.tag = 2;
                [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            }
        }else if (type==1){//表示点击头像
            if (self.isMe) {
                MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] initWithTitle:userName userId:userId userKey:@""];
                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                FriendsCircleViewController *friendsCircleVC = [[FriendsCircleViewController alloc] initWithIsMe:YES userId:userId];
                [self.navigationController pushViewController:friendsCircleVC animated:YES];
            }
        }
    }];
    self.headView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.headView];
    
    self.headView.frame = CGRectMake(0, -kImageOriginHight, self.tableView.frame.size.width, kImageOriginHight);
    self.tableView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    
    [self.view addSubview:self.tableView];
    
    __weak FriendsCircleViewController* wself = self;
    [_headView setHandleRefreshEvent:^{
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [wself.headView stopRefresh];
        });
    }];
     //*/
    
    self.tableView.tableHeaderView = self.albumHeaderContainerViewPathCover;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    if (self.isMe) {
        [self fillData];
        [self BlogOverheadData];
    }else{
        [self CheckCacheData];
    }
    
}
- (XHPathCover *)albumHeaderContainerViewPathCover {
    if (!_albumHeaderContainerViewPathCover) {
        _albumHeaderContainerViewPathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150)];
        
        WEAKSELF
        [_albumHeaderContainerViewPathCover setCallBack:^(int type) {
            if (type==1) {//头像
                if (weakSelf.isMe) {
                    MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] initWithTitle:weakSelf.model.userName userId:weakSelf.model.userId userKey:@""];
                    [weakSelf.navigationController pushViewController:detailVC animated:YES];
                }else{
                    FriendsCircleViewController *friendsCircleVC = [[FriendsCircleViewController alloc] initWithIsMe:YES userId:weakSelf.model.userId];
                    [weakSelf.navigationController pushViewController:friendsCircleVC animated:YES];
                }
            }else if (type==2){//背景
                if (!weakSelf.isMe) {
                    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                             delegate:weakSelf
                                                                    cancelButtonTitle:@"取消"
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles:@"拍照",@"从相册选择",nil];
                    actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
                    actionSheet.tag = 2;
                    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
                }
            }
        }];
        
        [_albumHeaderContainerViewPathCover setHandleRefreshEvent:^{
            //            [weakSelf loadDataSource];
            weakSelf.hasPublish = YES;
            weakSelf.tableView.pageNumber = 0;
            [weakSelf fillData];
            [weakSelf BlogOverheadData];
        }];
        
    }
    return _albumHeaderContainerViewPathCover;
}
- (void)loadDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.hasPublish = YES;
        weakSelf.tableView.pageNumber = 0;
        [weakSelf fillData];
        [weakSelf BlogOverheadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.albumHeaderContainerViewPathCover stopRefresh];
            weakSelf.tableView.scrollEnabled = YES;
        });
    });
}

#pragma mark- UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_albumHeaderContainerViewPathCover scrollViewDidScroll:scrollView];
    [self.commentBoxTextField resignFirstResponder];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_albumHeaderContainerViewPathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_albumHeaderContainerViewPathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_albumHeaderContainerViewPathCover scrollViewWillBeginDragging:scrollView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableView.tableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isMe) {//个人朋友圈
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (! cell) {
            cell = [[FriendsCircleMECell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        FriendsCircleMECell *meCell = (FriendsCircleMECell*)cell;
        meCell.tag = indexPath.row;
        if (indexPath.row == [self.self.tableView.tableArray count]-1) {
            meCell.isFinal = YES;
        }else{
            meCell.isFinal = NO;
        }
        if (indexPath.row < [self.self.tableView.tableArray count]) {
            MiniBlogModel *model = [self.tableView.tableArray objectAtIndex:indexPath.row];
            meCell.model = model;
        }
        return meCell;
    }else{//好友朋友圈
        /*
        UITableViewCell *cell = [[FriendsCircleOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         //*/
        //*
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (! cell) {
            cell = [[FriendsCircleOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
         //*/
        FriendsCircleOtherCell *otherCell = (FriendsCircleOtherCell*)cell;
        otherCell.tag = indexPath.row;
        otherCell.delegate = self;
        if (indexPath.row == [self.tableView.tableArray count]-1) {
            otherCell.isFinal = YES;
        }else{
            otherCell.isFinal = NO;
        }
        if (indexPath.row < [self.tableView.tableArray count]) {
            MiniBlogModel *model = [self.tableView.tableArray objectAtIndex:indexPath.row];
            otherCell.model = model;
        }
        return otherCell;
    }
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //*
    if (self.isMe) {
        FriendsCircleMECell *cell = (FriendsCircleMECell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else{
//        FriendsCircleOtherCell *cell = (FriendsCircleOtherCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//        return cell.frame.size.height;
        BOOL isFinal = NO;
        if (indexPath.row < [self.tableView.tableArray count]) {
            MiniBlogModel *model = [self.tableView.tableArray objectAtIndex:indexPath.row];
            if (indexPath.row == [self.tableView.tableArray count]-1) {
                isFinal = YES;
            }else{
                isFinal = NO;
            }
            return [FriendsCircleOtherCell calculateCellHeightWithAlbum:model isFinal:isFinal];
        }
    }
    return 0.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.commentBoxTextField resignFirstResponder];
    MiniBlogModel *model = [self.self.tableView.tableArray objectAtIndex:indexPath.row];
    
    FriendsCircleDetailViewController *detailVC = [[FriendsCircleDetailViewController alloc]
                                                   initWithModel:model block:^(int type) {
                                                       if (!self.isMe) {
                                                           if (type==1) {//表示评论了
                                                               model.hasComment = @"1";
                                                               model.commentNum = [NSString stringWithFormat:@"%i",[model.commentNum intValue]];
                                                               FriendsCircleOtherCell *cell = (FriendsCircleOtherCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                                                               cell.bubbleButton.isSelect = YES;
                                                               [cell.bubbleButton setTitle:model.commentNum forState:UIControlStateNormal];
                                                               [cell setNeedsDisplay];
                                                           }else if(type ==2){//表示点赞了
                                                               model.hasCommend = @"1";
                                                               model.commendNum = [NSString stringWithFormat:@"%i",[model.commendNum intValue]];
                                                               FriendsCircleOtherCell *cell = (FriendsCircleOtherCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                                                               cell.heartButton.isSelect = YES;
                                                               [cell.heartButton setTitle:model.commendNum forState:UIControlStateNormal];
                                                               [cell setNeedsDisplay];
                                                           }else if (type ==3){//表示取消赞
                                                               model.hasCommend = @"0";
                                                               model.commendNum = [NSString stringWithFormat:@"%i",[model.commendNum intValue]];
                                                               FriendsCircleOtherCell *cell = (FriendsCircleOtherCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                                                               cell.heartButton.isSelect = NO;
                                                               [cell.heartButton setTitle:model.commendNum forState:UIControlStateNormal];
                                                               [cell setNeedsDisplay];
                                                           }
                                                       }
    }];
    [detailVC setCallBack:^{
        self.hasPublish = YES;
        self.tableView.pageNumber = 0;
        [self fillData];
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}
/**
 *  填充数据
 */
- (void)fillData
{
    if (!self.hasPublish) {
        if (self.tableView.pageNumber==0) {
            [self startLoading];
            self.tableView.hidden = YES;
        }
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@sns/miniBlogService.jws?list", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    if (self.isMe) {
        [paramDict setObject:self.userId forKey:@"userId"];
    }
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",self.tableView.pages] forKey:@"page_size"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",self.tableView.pageNumber] forKey:@"page_no"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag == 1) {//微博列表数据
        MiniBlogModel *model = nil;
        NSDictionary *objDict = [data objectForKey:@"list"];
        
        if (self.tableView.pageNumber==0) {//第一批数据
            if (!self.isMe) {
                [UserDefaultsHelper setArrayForKey:[data objectForKey:@"list"] :@"blogList"];
            }
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in objDict) {
                model = [[MiniBlogModel alloc] initWithDataDict:dict];
                model.mid = [dict objectForKey:@"id"];
                model.imagesArray = [NSMutableArray arrayWithCapacity:3];
                for (NSDictionary *imgDict in [dict objectForKey:@"images"]) {
                    [model.imagesArray addObject:[[ImageModel alloc] initWithDataDict:imgDict]];
                }
//                [self.tableView.tableArray addObject:model];
                [array addObject:model];
            }
            [self stopLoading];
//            self.tableView.scrollEnabled = YES;
            self.tableView.hidden = NO;
            [self.tableView addFirstArray:array];
            self.tableView.pageNumber++;
            [self.albumHeaderContainerViewPathCover stopRefresh];
        }else{
            if ([objDict count]==0) {
                [self.tableView footerEndRefreshing];
            }else{
                if (!self.isMe) {
                    [self addCacheData:[data objectForKey:@"list"]];
                }
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in objDict) {
                    model = [[MiniBlogModel alloc] initWithDataDict:dict];
                    model.mid = [dict objectForKey:@"id"];
                    model.imagesArray = [NSMutableArray arrayWithCapacity:3];
                    for (NSDictionary *imgDict in [dict objectForKey:@"images"]) {
                        [model.imagesArray addObject:[[ImageModel alloc] initWithDataDict:imgDict]];
                    }
                    [array addObject:model];
                }
                NSArray *indexPaths = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:[self.tableView.tableArray count]-1 inSection:0], nil];
                [self.tableView addMoreArray:array];
                self.tableView.pageNumber++;
                [self.tableView footerEndRefreshing];
                //                [self.tableView reloadData];
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
    }else if (tag ==2){//点赞
        
    }else if (tag ==3){//微博顶置
        NSDictionary *objDict = [data objectForKey:@"obj"];
        if (!self.isMe) {
            [UserDefaultsHelper setDictForKey:objDict :@"blogOverhead"];
        }
        
        BlogOverheadModel *model = [[BlogOverheadModel alloc] initWithDataDict:objDict];
        if (![model.hbgPhoto isEqualToString:@""]) {
            [self.albumHeaderContainerViewPathCover setBackgroundImageUrlString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.hbgPhoto]];
        }
        [self.albumHeaderContainerViewPathCover setAvatarUrlString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto]];
        self.albumHeaderContainerViewPathCover.userNameLabel.text = model.userName;
        self.albumHeaderContainerViewPathCover.birthdayLabel.text = model.sign;
        self.model = model;
//        self.headView.model = model;
    }else if (tag ==4){//评论
        self.blogModel.hasComment = @"1";
        self.blogModel.commentNum = [NSString stringWithFormat:@"%i",[self.blogModel.commentNum intValue]+1];
        FriendsCircleOtherCell *cell = (FriendsCircleOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.commentCell inSection:0]];
        cell.bubbleButton.isSelect = YES;
        [cell.bubbleButton setTitle:self.blogModel.commentNum forState:UIControlStateNormal];
        [cell.bubbleButton setTitle:self.blogModel.commentNum forState:UIControlStateHighlighted];
    }
}
- (void)reponseFaild:(NSInteger)tag
{
    if (tag == 1) {//微博列表数据
        [self.tableView footerEndRefreshing];
    }
}
#pragma mark FriendsCircleOtherCellDelegate
- (void)otherCell:(FriendsCircleOtherCell*)otherCell didClickAtIndex:(NSInteger)index
{
    MiniBlogModel *model = [self.tableView.tableArray objectAtIndex:otherCell.tag];
    if (index == 3) {//头像
        FriendsCircleViewController *friendsCircleVC = [[FriendsCircleViewController alloc] initWithIsMe:YES userId:model.userId];
        [self.navigationController pushViewController:friendsCircleVC animated:YES];
    }else if(index ==1){//赞
        _index = otherCell.tag;
        if ([otherCell.heartButton isSelect]) {
            MiniBlogModel *model = [self.tableView.tableArray objectAtIndex:_index];
            model.commendNum = [NSString stringWithFormat:@"%i",[model.commendNum intValue]+1];
            model.hasCommend = @"1";
            [self submitCommend:model.mid action:@"1"];//点赞
        }else{
            MiniBlogModel *model = [self.tableView.tableArray objectAtIndex:_index];
            model.commendNum = [NSString stringWithFormat:@"%i",[model.commendNum intValue]-1];
            model.hasCommend = @"0";
            [self submitCommend:model.mid action:@"0"];//取消点赞
        }
    }else if(index ==2){//评论
        /*
        self.commentCell = otherCell.tag;
        self.blogModel = model;
        [self.commentBoxTextField becomeFirstResponder];
         //*/
        MiniBlogModel *model = [self.self.tableView.tableArray objectAtIndex:otherCell.tag];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:otherCell.tag inSection:0];
        FriendsCircleDetailViewController *detailVC = [[FriendsCircleDetailViewController alloc]
                                                       initWithModel:model block:^(int type) {
                                                           if (!self.isMe) {
                                                               if (type==1) {//表示评论了
                                                                   model.hasComment = @"1";
                                                                   model.commentNum = [NSString stringWithFormat:@"%i",[model.commentNum intValue]];
                                                                   FriendsCircleOtherCell *cell = (FriendsCircleOtherCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                                                                   cell.bubbleButton.isSelect = YES;
                                                                   [cell.bubbleButton setTitle:model.commentNum forState:UIControlStateNormal];
                                                                   [cell setNeedsDisplay];
                                                               }else if(type ==2){//表示点赞了
                                                                   model.hasCommend = @"1";
                                                                   model.commendNum = [NSString stringWithFormat:@"%i",[model.commendNum intValue]];
                                                                   FriendsCircleOtherCell *cell = (FriendsCircleOtherCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                                                                   cell.heartButton.isSelect = YES;
                                                                   [cell.heartButton setTitle:model.commendNum forState:UIControlStateNormal];
                                                                   [cell setNeedsDisplay];
                                                               }else if (type ==3){//表示取消赞
                                                                   model.hasCommend = @"0";
                                                                   model.commendNum = [NSString stringWithFormat:@"%i",[model.commendNum intValue]];
                                                                   FriendsCircleOtherCell *cell = (FriendsCircleOtherCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                                                                   cell.heartButton.isSelect = NO;
                                                                   [cell.heartButton setTitle:model.commendNum forState:UIControlStateNormal];
                                                                   [cell setNeedsDisplay];
                                                               }
                                                           }
                                                       }];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
/**
 *  提交赞
 *
 *  @param blogId 微博id
 *  @param action 赞状态 1:点赞 2:取消点赞
 */
-(void)submitCommend:(NSString*)blogId action:(NSString*)action
{
    _action = action;
    NSString *requestUrl = [NSString stringWithFormat:@"%@sns/miniBlogService.jws?commend", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:blogId forKey:@"blogId"];
    [paramDict setObject:action forKey:@"action"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}
/**
 *  微博列表顶置数据
 */
- (void)BlogOverheadData
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@ms/friendService.jws?get", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (self.isMe) {
        [paramDict setObject:self.userId forKey:@"userId"];
    }else{
        [paramDict setObject:[UserDefaultsHelper getStringForKey:@"userId"] forKey:@"userId"];
    }
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 3;
    [queue addOperation :operation];
}
/**
 *  朋友圈顶部背景图修改
 *
 *  @param image 修改图片
 */
- (void)hbgPhotoUpdate:(UIImage*)image
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@user/userService.jws?update", SERVERAPIURL];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:@"hbgPhoto" forKey:@"item"];
    [request setData:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"hbgPhoto"]];
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
                [[[[iToast makeText:@"顶部背景图修改成功！"] setDuration:iToastDurationNormal] setGravity:iToastGravityCenter] show];
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
/*
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[SDImageCache sharedImageCache] clearMemory];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window){// 是否是正在使用的视图
            
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
        [self viewDidUnload];
    }
}
 //*/

#pragma mark UITextFieldDelegate

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSLog(@"keyboardWillChangeFrame");
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    //    CGRect tableViewRect = self.tableView.frame;
    CGRect commentBoxRect = self.commentBoxView.frame;
    
    commentBoxRect.origin.y += yOffset;
    //    tableViewRect.size.height += yOffset;
    if (yOffset<0) {
        commentBoxRect.origin.y -=50;
    }else{
        commentBoxRect.origin.y +=50;
    }
    
    [UIView animateWithDuration:duration animations:^{
        //        self.tableView.frame = tableViewRect;
        self.commentBoxView.frame = commentBoxRect;
    }];
}
//按下回车键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.commentBoxTextField.placeholder = @"";
    if ([[self.commentBoxTextField text] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }else{
        [self.commentBoxTextField resignFirstResponder];
        self.content = [self.commentBoxTextField text];
        [self submitComment];
        self.commentBoxTextField.text = @"";
        return YES;
    }
}
/**
 *  点击发送按钮
 *
 *  @param button
 */
- (void)clickButton:(UIButton *)button
{
    if ([[self.commentBoxTextField text] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [self.commentBoxTextField resignFirstResponder];
        self.content = [self.commentBoxTextField text];
        [self submitComment];
        self.commentBoxTextField.text = @"";
    }
}
/**
 *  发表评论
 */
-(void)submitComment
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@sns/miniBlogService.jws?comment", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.blogModel.mid forKey:@"blogId"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:self.content forKey:@"content"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 4;
    [queue addOperation :operation];
}

/**
 *  检查缓存数据
 */
-(void)CheckCacheData
{
    NSArray *objDict = [UserDefaultsHelper getArrayForKey:@"blogList"];
    if (objDict !=nil) {//表示有缓存数据
        //判读有没朋友圈顶置缓存数据
        NSDictionary *overheadDict = [UserDefaultsHelper getDictForKey:@"blogOverhead"];
        if (overheadDict !=nil) {
            BlogOverheadModel *overModel = [[BlogOverheadModel alloc] initWithDataDict:overheadDict];
            if (![overModel.hbgPhoto isEqualToString:@""]) {
                [self.albumHeaderContainerViewPathCover setBackgroundImageUrlString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, overModel.hbgPhoto]];
            }
            [self.albumHeaderContainerViewPathCover setAvatarUrlString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, overModel.userPhoto]];
            self.albumHeaderContainerViewPathCover.userNameLabel.text = overModel.userName;
            self.albumHeaderContainerViewPathCover.birthdayLabel.text = overModel.sign;
            self.model = overModel;
        }else{
            [self BlogOverheadData];
        }
        
        MiniBlogModel *model = nil;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in objDict) {
            model = [[MiniBlogModel alloc] initWithDataDict:dict];
            model.mid = [dict objectForKey:@"id"];
            model.imagesArray = [NSMutableArray arrayWithCapacity:3];
            for (NSDictionary *imgDict in [dict objectForKey:@"images"]) {
                [model.imagesArray addObject:[[ImageModel alloc] initWithDataDict:imgDict]];
            }
            [array addObject:model];
        }
        [self stopLoading];
        self.tableView.hidden = NO;
        [self.tableView addFirstArray:array];
        float pagenumber = (float)[array count]/self.tableView.pages;
        int pageNumber = ceil(pagenumber);
        
        self.tableView.pageNumber = pageNumber +1 ;
    }else{
        [self fillData];
    }
}
/**
 *  增加缓存数据
 *
 *  @param dictionary 要增加的数据
 */
-(void)addCacheData:(NSArray*)dictionary
{
    NSArray *objDict = [UserDefaultsHelper getArrayForKey:@"blogList"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:objDict];
    for (NSDictionary *dict in dictionary) {
        [mutableArray addObject:dict];
    }
    NSArray *array = [mutableArray copy];
    [UserDefaultsHelper setArrayForKey:array :@"blogList"];
}
@end
