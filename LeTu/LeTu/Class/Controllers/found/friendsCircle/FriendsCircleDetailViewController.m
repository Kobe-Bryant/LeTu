//
//  FriendsCircleDetailViewController.m
//  LeTu
//
//  Created by DT on 14-5-14.
//
//

#import "FriendsCircleDetailViewController.h"
#import "DetailTableHeaderView.h"
#import "DetailCommentCell.h"
#import "BlogCommentModel.h"
#import "UserModel.h"
#import "MyselfDetailViewController.h"

@interface FriendsCircleDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DetailCommentCellDelegate,DetailTableHeaderViewDelegate,UIActionSheetDelegate>
{
    NSOperationQueue *queue;
    CallBack callBack;
    NSString *_action;
}
@property(nonatomic,retain)TableView *tableView;
@property(nonatomic,retain)DetailTableHeaderView *tableHeaderView;
@property(nonatomic,retain)UIView *commentBoxView;
@property(nonatomic,retain)UIButton *commentBoxButton;
@property(nonatomic,retain)UITextField *commentBoxTextField;

@property(nonatomic,strong)MiniBlogModel *model;
@property(nonatomic,retain)NSMutableArray *itemsArray;
@property(nonatomic,copy)NSString *content;
@end

@implementation FriendsCircleDetailViewController

-(id)initWithModel:(MiniBlogModel*)model block:(CallBack)block
{
    self = [super init];
    if (self) {
        callBack = block;
        self.model = model;
        self.itemsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitle:@"详情" andShowButton:YES];
    if ([self.model.userId isEqualToString:self.appDelegate.userModel.userId]) {
        [self initRightBarButtonItem:[UIImage imageNamed:@"material_more_btn_nor"]
                    highlightedImage:[UIImage imageNamed:@"material_more_btn_pre"]];
    }
//    [self initRightBarButtonItem:[UIImage imageNamed:@"common_topbar_share_btn_normal"]
//                highlightedImage:[UIImage imageNamed:@"common_topbar_share_btn_press"]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];//键盘将要显示的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];//键盘将要隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//键盘改变的通知
    
    [self initTableView];
    [self initCommentBox];
    [self fillData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.commentBoxTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)clickRightButton:(UIButton *)button
{
    if ([self.model.userId isEqualToString:self.appDelegate.userModel.userId]) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"删除说说",nil];
        actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
        actionSheet.tag = 1;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        NSLog(@"||||||||");
    }
}
/**
 *  初始化评论框
 */
- (void)initCommentBox
{
    self.commentBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-73, self.view.frame.size.width, 53)];
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
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT- 45;
    
    self.tableView = [[TableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(239, 238, 244);
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableHeaderView = [[DetailTableHeaderView alloc] initWithFrame:CGRectZero];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    self.tableHeaderView.model = self.model;
    self.tableHeaderView.isAuto = YES;
    self.tableHeaderView.delegate = self;
    self.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.tableHeaderView.frame.size.height);
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        cell = [[DetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DetailCommentCell *commentCell = (DetailCommentCell*)cell;
    commentCell.backgroundColor = RGBCOLOR(234, 234, 234);
    commentCell.tag = indexPath.row;
    commentCell.delegate = self;
    if (indexPath.row < [self.itemsArray count]) {
        BlogCommentModel *model = [self.itemsArray objectAtIndex:indexPath.row];
        commentCell.model = model;
    }
    return commentCell;

}
#pragma mark UITableViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.commentBoxTextField resignFirstResponder];
    self.commentBoxTextField.placeholder = @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCommentCell *cell = (DetailCommentCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    BlogCommentModel *model = [self.itemsArray objectAtIndex:indexPath.row];
//    self.commentBoxTextField.placeholder = [NSString stringWithFormat:@"%@%@",@"@",model.userName];
//    [self.commentBoxTextField becomeFirstResponder];
}

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
    
    [UIView animateWithDuration:duration animations:^{
//        self.tableView.frame = tableViewRect;
        self.commentBoxView.frame = commentBoxRect;
    }];
}
//按下回车键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.commentBoxTextField resignFirstResponder];
    self.commentBoxTextField.placeholder = @"";
    if ([[self.commentBoxTextField text] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }else{
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
 *  填充数据
 */
- (void)fillData
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@sns/miniBlogService.jws?listComment", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.model.mid forKey:@"blogId"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag ==1) {//评论数据
        BlogCommentModel *model = nil;
        NSDictionary *objDict = [data objectForKey:@"list"];
        for (NSDictionary *dict in objDict) {
            model = [[BlogCommentModel alloc] initWithDataDict:dict];
            model.mId = [dict objectForKey:@"id"];
            [self.itemsArray addObject:model];
        }
        [self.tableView reloadData];
    }else if (tag ==2){//发表评论
        UserModel *userModel = [AppDelegate sharedAppDelegate].userModel;
        BlogCommentModel *model = [[BlogCommentModel alloc] init];
        model.userPhoto = userModel.userPhoto;
        model.userId = userModel.userId;
        model.userName = userModel.fullName;
        model.content = self.content;
        model.createdDate = [DateUtil stringFormatDate:[NSDate date]];
        [self.itemsArray addObject:model];
        [self.tableView reloadData];
        
        self.model.hasComment = @"1";
        self.model.commentNum = [NSString stringWithFormat:@"%i",[self.model.commentNum intValue]+1];
        self.tableHeaderView.bubbleButton.isSelect = YES;
        [self.tableHeaderView.bubbleButton setTitle:self.model.commentNum forState:UIControlStateNormal];
        if (callBack) {
            callBack(1);
        }
    }else if (tag ==3){//提交赞
        if ([_action isEqualToString:@"1"]) {
            self.model.hasCommend = @"1";
            self.model.commendNum = [NSString stringWithFormat:@"%i",[self.model.commendNum intValue]+1];
            self.tableHeaderView.heartButton.isSelect = YES;
            [self.tableHeaderView.heartButton setTitle:self.model.commendNum forState:UIControlStateNormal];
            if (callBack) {
                callBack(2);
            }
        }else{
            self.model.hasCommend = @"0";
            self.model.commendNum = [NSString stringWithFormat:@"%i",[self.model.commendNum intValue]-1];
            self.tableHeaderView.heartButton.isSelect = NO;
            [self.tableHeaderView.heartButton setTitle:self.model.commendNum forState:UIControlStateNormal];
            if (callBack) {
                callBack(3);
            }
        }
    }else if (tag==4) {//删除说说
        if (self.callBack) {
            self.callBack();
        }
        [self messageToast:@"删除成功!"];
        [self.navigationController popViewControllerAnimated:YES];
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
    [paramDict setObject:self.model.mid forKey:@"blogId"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:self.content forKey:@"content"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 2;
    [queue addOperation :operation];
}

#pragma mark DetailCommentCellDelegate
- (void)commentCell:(DetailCommentCell*)commentCell clickFaceImage:(NSString*)userId
{
    MiniBlogModel *model = [self.itemsArray objectAtIndex:commentCell.tag];
    MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] initWithTitle:model.userName userId:model.userId userKey:@""];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark DetailTableHeaderViewDelegate
- (void)tableHeaderView:(DetailTableHeaderView*)tableHeaderView button:(DTButton*)button didClickAtIndex:(NSInteger)index;
{
    if (index ==1) {//赞
        if ([button isSelect]) {
            [self submitCommend:self.model.mid action:@"1"];
        }else{
            [self submitCommend:self.model.mid action:@"0"];
        }
    }else if (index==2){
        [self.commentBoxTextField becomeFirstResponder];
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
    operation.RequestTag = 3;
    [queue addOperation :operation];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {//文字
//        [self.navigationController popViewControllerAnimated:YES];
        [self deleteBlog];
    }
}
/**
 *  删除说说
 */
-(void)deleteBlog
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@sns/miniBlogService.jws?delete", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:self.model.mid forKey:@"id"];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 4;
    [queue addOperation :operation];
}
@end
