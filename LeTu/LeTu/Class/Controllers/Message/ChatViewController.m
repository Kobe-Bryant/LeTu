

#import "ChatViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ChatCustomCell.h"
#import "BaseViewController.h"
#import "EGOImageView.h"
#import "CacheSql.h"
#import "CacheModel.h"
#import "MessageModel.h"
#import "EGOImageButton.h"
#import "FaceUtil.h"
#define TOOLBARTAG		11200
#define TABLEVIEWTAG	11300

#ifdef IMPORT_LETUIM_H
#import "JSIdentityLabel.h"
#import "LeTuSourceImageView.h"
#import "UIScreen+MainScreen.h"
#import "AppDelegate.h"
#import "MyselfDetailViewController.h"
#import "NSString+Emoji.h"

#pragma mark ChatMessage+(MessageModel)
@implementation JSChatMessage (MessageModel)
- (MessageModel *)chatMessage2MessageModel:(LeTuMessage *)message {
    MessageModel *msg = [[MessageModel alloc] init];
    
    msg.targetName = message.receiver;
    
    msg.content = message.body;
    msg.createdDate = message.receivedDate.description;
    
    NSString *type = message.type;
    if ([type isEqualToString:MESSAGE_CHATTYPE_TEXT]) {
        msg.msgType = @"1"; // 1 文本
    } else if ([type isEqualToString:MESSAGE_CHATTYPE_PICTURE]) {
        msg.msgType = @"2"; // 2 图片
    }
    
    msg.mediaFile = message.fileID;
    
    return msg;
}
@end

@interface ChatViewController ()//<JSChatMessageDelegate>
{
    NSMutableArray *_chat;
    BOOL _needUpdateBuddyInfomation;
    BOOL _show;
    LeTuUser *_myLetu;
}
@end
#endif

@implementation ChatViewController
@synthesize titleString;
@synthesize chatArray = _chatArray;
@synthesize chatTableView = _chatTableView;

@synthesize messageString = _messageString;
@synthesize phraseString = _phraseString;


@synthesize basetempController;
@synthesize targetId;
@synthesize targetType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:self.titleString andShowButton:YES];
    [self initViews];
    
    
   	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.chatArray = tempArray;
    
	
    NSMutableString *tempStr = [[NSMutableString alloc] initWithFormat:@""];
    self.messageString = tempStr;
    
    selectView=[[UIView alloc]init];
    
#ifdef IMPORT_LETUIM_H
    LeTuIM *im = [LeTuIM sharedInstance];
    _myLetu = [im findUserWithName:[im myName] update:NO];
    if (!_myLetu.userPhoto && !_myLetu.userName && !_myLetu.userId)
        [[LeTuIM sharedInstance] userInfomationWithLoginName:_myLetu.name];
    
    isbottom = YES;
    if (_buddy && !_chatWith) {
        _chatWith = _buddy.name;
        if (!_updateBuddyInfomation) [[LeTuIM sharedInstance] userInfomationWithLoginName:_chatWith];
    }
    
    if (!_buddy && _chatWith) {
        _buddy = [[LeTuIM sharedInstance] findUserWithName:_chatWith update:!_updateBuddyInfomation];
    }
    
    _chat = [LeTuMessage fetchChatWithBuddyName:_chatWith];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatMessageChanged:) name:kJSChatMessageMessageChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatUserChanged:) name:kJSChatUserUserChanged object:nil];
    
    [self loadChatMessages];
#endif
    
}

#ifdef IMPORT_LETUIM_H

- (void) backPressed:(id)sender
{
    _show = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // kJSChatUserUserChanged, kJSChatMessageMessageChanged
    
    if (faceView.isShow) {
        [faceView dismiss];
        faceView.delegate = nil;
    }
    
    
    if (inputView) {
        [inputView removeFromSuperview];
    }
    
    [super backPressed:sender];
}

#pragma mark - user or message NSNotification

- (void)chatMessageChanged:(NSNotification *)notification {
    
    NSString *fuc = [notification userInfo][@"function"];
    if ([fuc isEqualToString:@"save"] &&[fuc isEqualToString:@"save"]) {
        
        LeTuMessage *msg = [notification object];
        [_chat addObject:msg];
    } else if ([fuc isEqualToString:@"delete"]) {
        
        LeTuMessage *msg = [notification object];
        [_chat addObject:msg];
    }
    
    
    if (_show) [self loadChatMessages];
}

- (void)chatUserChanged:(NSNotification *)notification {
    
    LeTuUser *user = [notification object];
    if (user) {
        if ([user isNamed:_buddy.name]) {
            _buddy = user;
             if (_show) [self loadChatMessages];
        } else if ([user isNamed:_myLetu.name]) {
            _myLetu = user;
             if (_show) [self loadChatMessages];
        }
        
        if (_needUpdateBuddyInfomation && ([user.userId isEqualToString:_buddy.userId] || [user.userId isEqualToString:_myLetu.userId])) {
            
            [self pushBuddyDetailViewControllerWithTitle:_buddy.userName userID:_buddy.userId];
        }
    }
}

- (void)loadChatMessages {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (LeTuMessage *msg in _chat) {
        [arr addObject:msg.receivedDate];
        
        BOOL buddySay = [msg isBuddySpeak];
        MessageModel *messageModel = [msg chatMessage2MessageModel:msg];
        messageModel.identity = msg.identity;
        if (buddySay) {
            messageModel.userPhoto = _buddy.userPhoto;
            messageModel.userId = _buddy.userId;
        } else {
            messageModel.userPhoto = _myLetu.userPhoto;
            messageModel.userId = _myLetu.userId;
        }
        
        UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",messageModel.content] from:![msg isBuddySpeak] Object:messageModel];
        
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%@", messageModel.mId], @"messageID",
                        [NSString stringWithFormat:@"%@", messageModel.userId], @"speaker",
                        chatView, @"view",
                        nil]];
    }
    
    self.chatArray = arr;
    [mTableView reloadData];
    
    if (_chatArray.count >2 && isbottom) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_chatArray.count -1 inSection:0];
        [mTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark ChatMessageDelegate

- (void)didReceivedMessage:(JSChatMessage *)message
{
    [_chat addObject:message];
    [self loadChatMessages];
}

- (void)didChatChanged:(NSDictionary *)changedInfomation
{
    _chat = [LeTuMessage fetchChatWithBuddyName:_chatWith];
    [self loadChatMessages];
}
#endif

-(void)viewWillAppear:(BOOL)animated

{
	[super viewWillAppear:YES];
    HIDETABBAR;
	[contentTextView setText:self.messageString];
//    isbottom=NO;
    
#ifdef IMPORT_LETUIM_H
    _show = YES;
    [[LeTuIM sharedInstance] setMessageDelegate:self];
#else
    sendCommentBtn.enabled=NO;
    
    
    //没有网络获取数据库缓存数据
    if(![Utility connectedToNetwork])
    {
        [self getCacheData:20];
        
        
    }
    //有网络时获取最新20条数据
    else
    {
        [self Get20MessageList];
        
    }
#endif
}

- (void)initViews
{
    normalMsgImg = [UIImage imageNamed:@"message2_item_btn_add_normal"];
    actMsgImg = nil;
    normalTextImg = [UIImage imageNamed:@"message2_item_btn_keyboard_normal"];
    actTextImg = [UIImage imageNamed:@"message2_item_btn_keyboard_current"];
    
    if (mContainer!=nil)
    {
        [mContainer removeFromSuperview];
    }
    
    
    //背景图
    UIImage *Img=[UIImage imageNamed:@"letu_bg"];
    
    mContainer =[[UIView alloc]initWithFrame:CGRectMake(0,44, 320, self.view.bounds.size.height-44)];
    
    mContainer.backgroundColor=[UIColor colorWithPatternImage:Img];
    
    [self.view addSubview:mContainer];
    
    
    
    
    
    CGRect appframe = [[UIScreen mainScreen ] applicationFrame];
    
    isFirst=YES;
    mTableView = [[TableView alloc] initWithFrame:CGRectMake(0, 0, 320, appframe.size.height-44-52)];
    mTableView.backgroundColor = [UIColor colorWithPatternImage:Img];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    //    mTableView.refreshDelegate = self;
    mTableView.tag=TABLEVIEWTAG;
    
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#ifdef IMPORT_LETUIM_H
#else
    mTableView.refreshDelegate = self;
    [mTableView addRefreshView];
#endif
    //    [mTableView addRefreshView];
    [mContainer addSubview:mTableView];
    
    isFirst=NO;
    
    //增加tap手势，点击使退出键盘
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    [mTableView addGestureRecognizer:tapGesture];
    
    tapGesture.cancelsTouchesInView =NO;
    
    
    //输入背景图
    UIImage *lineImage1=[UIImage imageNamed:@"message2_icon_send_bg"];
    UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(0, appframe.size.height-52-44, 320, lineImage1.size.height)];
    contentView.tag=TOOLBARTAG;
    contentView.backgroundColor=[UIColor colorWithPatternImage:lineImage1];
    [mContainer addSubview:contentView];
    
    
    
    // 发布内容
    contentTextView = [[FaceTextView alloc] initWithFrame:CGRectMake(45, 10, 225, 40)];
    contentTextView.delegate = self;
    contentTextView.font = [UIFont fontWithName:@"Arial" size:18];
    [contentView addSubview:contentTextView];
    
    
    //工具按钮
    utilityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    utilityBtn.frame = CGRectMake(7.5, 13, 28, 28);
    [utilityBtn setImage:normalMsgImg forState:UIControlStateNormal];
    [utilityBtn setImage:actMsgImg forState:UIControlStateHighlighted];
    [utilityBtn addTarget:self action:@selector(layoutDetails) forControlEvents:UIControlEventTouchUpInside];
    [Utility resizeTouchableAreaForButton:utilityBtn withNewSize:CGSizeMake(50, 50)];
    [contentView addSubview:utilityBtn];
    
    
    
    
    //发送按钮
    sendCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCommentBtn.frame = CGRectMake(271.5, 13, 40, 25);
    [sendCommentBtn setImage:[UIImage imageNamed:@"message2_item_btn_send_normal"] forState:UIControlStateNormal];
    [sendCommentBtn setImage:[UIImage imageNamed:@"message2_item_btn_send_current"] forState:UIControlStateHighlighted];
    [sendCommentBtn addTarget:self action:@selector(sendMessage_Click:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sendCommentBtn];
    
    
    
    [self addinputView];
    
    
    
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //    // 键盘高度变化通知，ios5.0新增的
    //#ifdef __IPHONE_5_0
    //    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //    if (version >= 5.0) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    }
    //#endif
    
    
}
#ifdef IMPORT_LETUIM_H
- (void)tapHeadImageView:(UIGestureRecognizer *)gestureRecognizer {
    EGOImageView *view = (EGOImageView *)gestureRecognizer.view;
    NSString *relativePath = view.imageURL.relativePath;
    
    UserModel *model = [[AppDelegate sharedAppDelegate] userModel];
    NSString *myPhoto = model.userPhoto;
    
    if ([relativePath isEqualToString:myPhoto]) {
        MyselfDetailViewController *vc = [[MyselfDetailViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self pushBuddyDetailViewControllerWithTitle:_buddy.userName userID:_buddy.userId];
    }
}
- (void)pushBuddyDetailViewControllerWithTitle:(NSString *)title userID:(NSString *)userID {
    if (!userID) {
        [[LeTuIM sharedInstance] findUserWithName:_chatWith update:NO];
        _needUpdateBuddyInfomation = YES;
        return ;
    }
    
    NSString *key = [NSUserDefaults stringForKeyInStandardUserDefaults:@"key"];
    NSString *titleStr = (!title || title.length <=0) ? @"用户信息" : title;
    MyselfDetailViewController *vc = [[MyselfDetailViewController alloc] initWithTitle:titleStr userId:userID userKey:key];
    [self.navigationController pushViewController:vc animated:YES];
}

#endif
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    
    
    if ([contentTextView.textView isFirstResponder])
    {
        
        [contentTextView.textView resignFirstResponder];
#ifdef IMPORT_LETUIM_H
        // 隐藏表情键盘
        [inputView setFrame:CGRectMake(0, [UIScreen mainScreenHeight]-44, 320,217)];
#endif
    }
    else
    {
        if (faceView.isShow)
        {
            [faceView dismiss];
        }
        CGRect appframe = [[UIScreen mainScreen ] applicationFrame];
        [inputView setFrame:CGRectMake(0, appframe.size.height, 320,217)];
        [utilityBtn setImage:normalMsgImg forState:UIControlStateNormal];
        [utilityBtn setImage:actMsgImg forState:UIControlStateHighlighted];
        [self keyboardWillHide:nil];
    }
}
//添加表情工具view
-(void)addinputView
{
    
    
    CGRect appframe = [[UIScreen mainScreen ] applicationFrame];
    
    //        inputView = [[UIView alloc] initWithFrame:CGRectMake(0, appframe.size.height-217, 320,217)];
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, appframe.size.height-44, 320,217)];
    
    
    inputView.backgroundColor = [Utility colorWithHexString:@"#E6E6E6"];
//    IMPORT_LETUIM_H
    NSArray *array1 = [NSArray arrayWithObjects:
                       @"message2_item_icon_expression_normal",
                       @"message2_item_icon_pic_normal",
                       @"message2_item_icon_camera_normal",
                       @"message2_item_icon_film_normal",
#ifndef IMPORT_LETUIM_H
                       @"message2_item_icon_position_normal",
                       @"message2_item_icon_read_normal",
                       @"message2_item_icon_card_normal",
                       @"message2_item_icon_voice_normal",
#endif
                       nil];
    
    NSArray *array2 = [NSArray arrayWithObjects:
                       @"message2_item_icon_expression_current",
                       @"message2_item_icon_pic_current",
                       @"message2_item_icon_camera_current",
                       @"message2_item_icon_film_current",
#ifndef IMPORT_LETUIM_H
                       @"message2_item_icon_position_current",
                       @"message2_item_icon_read_current",
                       @"message2_item_icon_card_current",
                       @"message2_item_icon_voice_current",
#endif
                       nil];
    
    CGFloat x;
    CGFloat y;
    for (int i = 0; i < array1.count; i++)
    {
        UIImage *image1 = [UIImage imageNamed:[array1 objectAtIndex:i]];
        UIImage *image2 = [UIImage imageNamed:[array2 objectAtIndex:i]];
        x = 10+i % 4 * 78;
        y =20+ i /4 * 95;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y , 64, 64);
        button.tag = i+1;
        [button setBackgroundImage:image1 forState:UIControlStateNormal];
        [button setBackgroundImage:image2 forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:button];
    }
    [mContainer addSubview:inputView];
    
    
}

-(void)buttonPressed:(UIButton*)btn
{
    CGRect appframe = [[UIScreen mainScreen ] applicationFrame];
    switch (btn.tag)
    {
            //表情
        case 1:
        {
            if (!faceView)
            {
                faceView = [[FaceView alloc] init];
                faceView.faceDelegate = self;
            }
            
            if (faceView.isShow)
            {
                [faceView dismiss];
            }
            else
            {
                [faceView show];
            }
            break;
        }
        case 2:
        {
// 0 不需要关闭
#if 0
            // 关闭插入内容板
            [utilityBtn setImage:normalMsgImg forState:UIControlStateNormal];
            [utilityBtn setImage:actMsgImg forState:UIControlStateHighlighted];
            [self autoMovekeyBoard:0];
            [inputView setFrame:CGRectMake(0, appframe.size.height-44, 320,217)];
#ifdef IMPORT_LETUIM_H
            //判断键盘弹起时uitableview是否在最低
            CGPoint contentOffsetPoint = mTableView.contentOffset;
            CGRect frame = mTableView.frame;
            if (contentOffsetPoint.y == mTableView.contentSize.height - frame.size.height || mTableView.contentSize.height < frame.size.height)
            {
                isbottom=YES;
            }
            else
            {
                isbottom=NO;
            }
            
            [UIView animateWithDuration:.12 animations:^{
                CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
                int currentDeviceSystemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
                float naviHeight = (currentDeviceSystemVersion <7) ? 44 : 64;
                
                CGRect rect = mTableView.frame;
                rect.size.height = mainScreenBounds.size.height -naviHeight -52; // 52 toolbar height
                mTableView.frame = rect;
            }];
            
            if (isbottom && _chatArray.count >1) {
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_chatArray.count -1 inSection:0];
                [mTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
#endif
            
            if (faceView && faceView.isShow)
            {
                [faceView dismiss];
            }
#endif
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:imagePickerController animated:YES];
            
            break;
        }
        case 3:
        {
// 0 不需要关闭
#if 0
            // 关闭插入内容板
            [utilityBtn setImage:normalMsgImg forState:UIControlStateNormal];
            [utilityBtn setImage:actMsgImg forState:UIControlStateHighlighted];
            [self autoMovekeyBoard:0];
            [inputView setFrame:CGRectMake(0, appframe.size.height-44, 320,217)];
#ifdef IMPORT_LETUIM_H
            //判断键盘弹起时uitableview是否在最低
            CGPoint contentOffsetPoint = mTableView.contentOffset;
            CGRect frame = mTableView.frame;
            if (contentOffsetPoint.y == mTableView.contentSize.height - frame.size.height || mTableView.contentSize.height < frame.size.height)
            {
                isbottom=YES;
            }
            else
            {
                isbottom=NO;
            }
            
            [UIView animateWithDuration:.12 animations:^{
                CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
                int currentDeviceSystemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
                float naviHeight = (currentDeviceSystemVersion <7) ? 44 : 64;
                
                CGRect rect = mTableView.frame;
                rect.size.height = mainScreenBounds.size.height -naviHeight -52; // 52 toolbar height
                mTableView.frame = rect;
            }];
            
            if (isbottom && _chatArray.count >1) {
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_chatArray.count -1 inSection:0];
                [mTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
#endif
            
            if (faceView && faceView.isShow)
            {
                [faceView dismiss];
            }
#endif
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:imagePickerController animated:YES];
            
            break;
        }
            
        default:
        {
            [self messageShow:@"此功能暂未实现,请期待～"];
        }
            break;
    }
    
    
}
-(void)faceView:(FaceView *)faceView faceIndex:(int)faceIndex
{
    [contentTextView setPlaceholderHidden:YES];
    contentTextView.text = [NSString stringWithFormat:@"%@[%d]", contentTextView.text, faceIndex];
}

- (void)faceTextViewDidBeginEditing:(FaceTextView *)faceTextView
{
    
}
#ifdef IMPORT_LETUIM_H
- (BOOL)faceTextViewTextFieldShouldReturn:(FaceTextView *)faceTextView
{
    [self sendMessage_Click:nil];
    return NO;
}
#endif

-(void)layoutDetails
{
    //        CGRect appframe = [[UIScreen mainScreen ] applicationFrame];
    //        //如果直接点击表情，通过toolbar的位置来判断
    //        if (inputView.frame.origin.y==appframe.size.height-44)
    //        {
    //                [faceView dismiss];
    ////                UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
    ////                if(isInputViewShow==NO)
    ////                {
    ////                    CGPoint point = [tableView contentOffset];
    ////                    [tableView setContentOffset:CGPointMake(0, point.y + 216) animated:YES];
    ////                    isInputViewShow=YES;
    ////                }
    //                if ([contentTextView.textView isFirstResponder])
    //                {
    //                    [contentTextView.textView resignFirstResponder];
    //
    //                }
    //                else
    //                {
    //
    //                    [utilityBtn setImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
    //                    [self autoMovekeyBoard:216];
    //                    inputView.frame=CGRectMake(0, appframe.size.height-217-44, 320,217);
    //
    //                }
    //
    //
    //
    //
    //            return;
    //        }
    //        else
    //        {
    //
    //                [faceView dismiss];
    //                [inputView setFrame:CGRectMake(0, appframe.size.height-44, 320,217)];
    //
    //                [contentTextView becomeFirstResponder];
    //
    //
    //                [utilityBtn setImage:[UIImage imageNamed:@"message2_item_btn_add_normal"] forState:UIControlStateNormal];
    //
    //                return;
    //        }
    CGRect appframe = [[UIScreen mainScreen ] applicationFrame];
    UIImage *image = [utilityBtn imageForState:UIControlStateNormal];
    if (image == normalMsgImg)
    {
        [contentTextView.textView resignFirstResponder];
        [utilityBtn setImage:normalTextImg forState:UIControlStateNormal];
        [utilityBtn setImage:actTextImg forState:UIControlStateHighlighted];
        [self autoMovekeyBoard:216];
        
        
#ifdef IMPORT_LETUIM_H
        //判断键盘弹起时uitableview是否在最低
        CGPoint contentOffsetPoint = mTableView.contentOffset;
        CGRect frame = mTableView.frame;
        if (contentOffsetPoint.y == mTableView.contentSize.height - frame.size.height || mTableView.contentSize.height < frame.size.height)
        {
            isbottom=YES;
        }
        else
        {
            isbottom=NO;
        }
        
        [UIView animateWithDuration:.12 animations:^{
            CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
            int currentDeviceSystemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
            float naviHeight = (currentDeviceSystemVersion <7) ? 44 : 64;
            
            CGRect rect = mTableView.frame;
            rect.size.height = mainScreenBounds.size.height -naviHeight -52 -216; // 52 toolbar height
            mTableView.frame = rect;
        }];
        
        if (isbottom && _chatArray.count >1) {
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_chatArray.count -1 inSection:0];
            [mTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
#endif
        
        inputView.frame=CGRectMake(0, appframe.size.height-217-44, 320,217);
    }
    else
    {
        if (faceView.isShow)
        {
            [faceView dismiss];
        }
        [utilityBtn setImage:normalMsgImg forState:UIControlStateNormal];
        [utilityBtn setImage:actMsgImg forState:UIControlStateHighlighted];
        [inputView setFrame:CGRectMake(0, appframe.size.height-44, 320,217)];
        [contentTextView becomeFirstResponder];
    }
    
}


//获取20条最新信息
-(void)Get20MessageList
{
    
    //192.168.0.234:8891/ms/messageService.jws?list&&l_key=&targetType=&targetId=&msgId=&page_size=20
    NSString *requestURL = [NSString stringWithFormat:@"%@ms/messageService.jws?list&&",SERVERAPIURL] ;
    NSURL *url = [NSURL URLWithString:requestURL];
    NSLog(@"APIUrl---%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:self.targetType forKey:@"targetType"];
    [request setPostValue:self.targetId forKey:@"targetId"];
    [request setPostValue:@"" forKey:@"msgId"];
    [request setPostValue:@"20" forKey:@"page_size"];
    [request setTag:111];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:240];
    [request startAsynchronous];
    
}

//获取1条的线程
-(void)GetOneMessage
{
    
    //192.168.0.234:8891/ms/messageService.jws?list&&l_key=&targetType=&targetId=&msgId=&page_size=20
    NSString *requestURL = [NSString stringWithFormat:@"%@ms/messageService.jws?list&&",SERVERAPIURL] ;
    NSURL *url = [NSURL URLWithString:requestURL];
    NSLog(@"APIUrl---%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:self.targetType forKey:@"targetType"];
    [request setPostValue:self.targetId forKey:@"targetId"];
    [request setPostValue:@"" forKey:@"msgId"];
    [request setPostValue:@"1" forKey:@"page_size"];
    [request setTag:222];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:240];
    [request startAsynchronous];
    
    
}
//发送消息
-(void)sendMessage_Click:(id)sender
{
    if (timer)
    {
		[timer invalidate];
    }
    self.messageString = contentTextView.textView.text;
    
    if (!self.messageString ||[self.messageString isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败！" message:@"发送的内容不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self sendMassage:self.messageString Type:@"1"];
    }
	
}
//发送消息
-(void)sendMassage:(NSString *)message Type:(NSString*)type
{
#ifdef IMPORT_LETUIM_H
//    if ([[LeTuIM sharedInstance] currentHostReachabilityStatus]) {
//        showErrorAlertView(@"与服务器连接不正常");
//        return ;
//    }
    [[LeTuIM sharedInstance] sendText:message to:_chatWith];
    contentTextView.text = @"";
    _messageString = @"";
#else
    
    //192.168.0.234:8891/ms/messageService.jws?send&&l_key=&targetType=&targetId=&msgType=&content=&mediaFile=
    NSString *requestURL = [NSString stringWithFormat:@"%@ms/messageService.jws?send&&",SERVERAPIURL] ;
    NSURL *url = [NSURL URLWithString:requestURL];
    NSLog(@"APIUrl---%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:self.targetType forKey:@"targetType"];
    [request setPostValue:self.targetId forKey:@"targetId"];
    [request setPostValue:type forKey:@"msgType"];
    [request setPostValue:message forKey:@"content"];
    [request setPostValue:@"" forKey:@"mediaFile"];
    [request setTag:333];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:240];
    [request startAsynchronous];
    
    
#endif
}
//发送图片
- (void)upLoadImage
{
    
    //192.168.0.234:8891/ms/messageService.jws?send&&l_key=&targetType=&targetId=&msgType=&content=&mediaFile=
    NSString *requestURL = [NSString stringWithFormat:@"%@ms/messageService.jws?send&&",SERVERAPIURL] ;
    NSURL *url = [NSURL URLWithString:requestURL];
    NSLog(@"APIUrl---%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:self.targetType forKey:@"targetType"];
    [request setPostValue:self.targetId forKey:@"targetId"];
    [request setPostValue:@"2" forKey:@"msgType"];
    [request setPostValue:@"" forKey:@"content"];
    [request setFile:[self getPath:@"mypic.png"] forKey:@"mediaFile"];
    [request setTag:333];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:240];
    [request startAsynchronous];
    
}
//往上拉取历史记录
-(void)GetMoreMessage:(NSString*)lastTimeMessID
{
    //192.168.0.234:8891/ms/messageService.jws?list&&l_key=&targetType=&targetId=&msgId=&page_size=20
    NSString *requestURL = [NSString stringWithFormat:@"%@ms/messageService.jws?list&&",SERVERAPIURL] ;
    NSURL *url = [NSURL URLWithString:requestURL];
    NSLog(@"APIUrl---%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:self.targetType forKey:@"targetType"];
    [request setPostValue:self.targetId forKey:@"targetId"];
    [request setPostValue:lastTimeMessID forKey:@"msgId"];
    [request setPostValue:@"20" forKey:@"page_size"];
    [request setTag:444];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:240];
    [request startAsynchronous];
}
//删除单条消息
-(void)deleteMsg:(NSString*)MessageID
{
    
    //192.168.0.234:8891/ms/messageService.jws?del&&l_key=&msgId=
    NSString *requestURL = [NSString stringWithFormat:@"%@ms/messageService.jws?del&&",SERVERAPIURL] ;
    NSURL *url = [NSURL URLWithString:requestURL];
    NSLog(@"APIUrl---%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:MessageID forKey:@"msgId"];
    [request setTag:555];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:240];
    [request startAsynchronous];
}





//UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *finalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
#ifdef IMPORT_LETUIM_H
    [[LeTuIM sharedInstance] sendImage:finalImage to:_chatWith];
#else
    [self saveImage:finalImage WithName:@"mypic.png"];
    
    [self upLoadImage];
#endif
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    /*添加代码，处理选中图像又取消的情况*/
    [picker dismissModalViewControllerAnimated:YES];
}



//保存图片到沙盒中的Documents
-(NSString*)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData *imageData=UIImagePNGRepresentation(tempImage);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    //now we get the full path to the file
    NSString *fullPathToFile=[documentsDirectory stringByAppendingPathComponent:imageName];
    //and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}
-(NSString*)getPath:(NSString *)imageName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    //now we get the full path to the file
    NSString *path=[documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSLog(@"-----PATH:---%@----",path);
    return path;
}

//从文档目录下获取Documents路径
-(NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}


//压缩图片
-(UIImage*) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    //create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    //Tell the old image to draw in this new context,with the desired new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //Get the new image from the context
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    //End the context
    UIGraphicsEndImageContext();
    
    //Return the new image.
    return newImage;
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSLog(@"-responseString--%@-----",responseString);
    
    NSError *error = [request error];
    if (!error)
    {
        
        
        JSONDecoder *decoder=[JSONDecoder decoder];
        NSDictionary *dict=[decoder objectWithData:request.responseData];
        NSDictionary *errDict=[dict objectForKey:@"error"];
        int errCode=[[errDict objectForKey:@"err_code"] intValue];
        //获取接口最新的20条，成功则显示及录入到数据库，失败则取数据库最新20条
        
        switch (request.tag)
        {
                
                
            case 111:
            {
                if(errCode==0||errCode==1)
                {
                    NSArray *list = [dict objectForKey:@"list"];
                    MessageModel *messageModel = nil;
                    if (list.count!=0)
                    {
                        messageModel = [[MessageModel alloc] initWithDataDict:[list objectAtIndex:0]];
                        lastTimeMessageID=messageModel.mId;
                    }
                    CacheSql *cacheSql = [[CacheSql alloc] init];
                    NSMutableArray *data=[NSMutableArray array];
                    for (NSDictionary *dict in list)
                    {
                        messageModel = [[MessageModel alloc] initWithDataDict:dict];
                        
                        [data addObject:messageModel];
                        
                        //判断是否要插入倒数据库
                        int count=[cacheSql ifHasMessageID:messageModel.mId];
                        if (count==0)
                        {
                            BOOL result=[cacheSql itemAdd:messageModel];
                        }
                    }
                    //显示数据
                    [self.chatArray removeAllObjects];
                    [self displayData:data Type:1];
                    //定时1秒执行任务：获取新的聊天信息加载到列表,每3秒1条
                    if (timer==nil)
                    {
                        
                        timer=[NSTimer scheduledTimerWithTimeInterval:3
                                                               target:self
                                                             selector:@selector(GetOneMessage)
                                                             userInfo:nil
                                                              repeats:YES];
                    }
                    
                }
                else
                {
                    
                    //失败则取数据库最新20条
                    [self.chatArray removeAllObjects];
                    [self getCacheData:20];
                }
                
            }
                break;
            case 222:
            {
                //每3秒获取1条成功
                if (errCode == 0 || errCode == 1)
                {
                    
                    NSArray *list = [dict objectForKey:@"list"];
                    //由于发送的时候成功了就显示在界面，所以拉取1条的时候得判断此条是否已经显示
                    BOOL shouldADD;
                    MessageModel *messageModel = nil;
                    if (list.count!=0)
                    {
                        messageModel = [[MessageModel alloc] initWithDataDict:[list objectAtIndex:0]];
                        shouldADD=YES;
                        for (int j=0; j<self.chatArray.count; j++)
                        {
                            
                            if (![[self.chatArray objectAtIndex:j] isKindOfClass:[NSDate class]])
                            {
                                
                                NSString *messageID=[[self.chatArray objectAtIndex:j] objectForKey:@"messageID"];
                                if ([messageID isEqualToString:messageModel.mId])
                                {
                                    shouldADD=NO;
                                    break;
                                }
                                else
                                {
                                    shouldADD=YES;
                                }
                            }
                            
                        }
                        if (shouldADD)
                        {
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            
                            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                            
                            NSDate *destDate= [dateFormatter dateFromString:messageModel.createdDate];
                            
                            [self.chatArray addObject:destDate];
                            
                            if([messageModel.userId isEqualToString:[UserDefaultsHelper getStringForKey:@"userId"]])
                            {
                                UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",messageModel.content] from:YES Object:messageModel];
                                
                                [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:messageModel.mId, @"messageID", messageModel.userId, @"speaker", chatView, @"view", nil]];
                            }
                            else
                            {
                                UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",messageModel.content] from:NO Object:messageModel];
                                
                                [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:messageModel.mId, @"messageID", messageModel.userId, @"speaker", chatView, @"view", nil]];
                            }
                            
                        }
                        
                    }
                    
                    if (isKeyborardShow==NO)
                    {
                        if (shouldADD)
                        {
                            //和qq一样，判断有数据来时当前位置是否在最下面，是则最下面的自动上移一位，否则不动
                            CGPoint contentOffsetPoint = mTableView.contentOffset;
                            CGRect frame = mTableView.frame;
                            if (contentOffsetPoint.y == mTableView.contentSize.height - frame.size.height || mTableView.contentSize.height < frame.size.height)
                            {
                                [mTableView reloadData];
                                if(!self.chatArray.count==0)
                                {
                                    [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0]
                                                      atScrollPosition: UITableViewScrollPositionBottom
                                                              animated:YES];
                                }
                            }
                            else
                            {
                                [mTableView reloadData];
                            }
                        }
                        
                        
                    }
                    //弹出键盘时
                    else
                    {
                        if (shouldADD)
                        {
                            if (isbottom==YES)
                            {
                                [mTableView reloadData];
                                CGPoint point = [mTableView contentOffset];
                                [mTableView setContentOffset:CGPointMake(0, point.y+(returnViewH+50)*2) animated:YES];
                            }
                            else
                            {
                                [mTableView reloadData];
                            }
                        }
                        
                    }
                    
                    //1条新增到数据库，判断是否要插入倒数据库
                    CacheSql *cacheSql = [[CacheSql alloc] init];
                    int count=[cacheSql ifHasMessageID:messageModel.mId];
                    if (count==0)
                    {
                        BOOL result=[cacheSql itemAdd:messageModel];
                    }
                    
                }
                else
                {
                    //失败后停止线程
                    [timer invalidate];
                    timer=nil;
                    
                }
            }
                break;
            case 333:
            {
                //发送消息，成功后重新开启获取1条的线程并录入数据库
                JSONDecoder *decoder=[JSONDecoder decoder];
                NSDictionary *dict=[decoder objectWithData:request.responseData];
                NSDictionary *errDict=[dict objectForKey:@"error"];
                int err_code=[[errDict objectForKey:@"err_code"] intValue];
                if(err_code==0||err_code==1)
                {
                    
                    contentTextView.text = @"";
                    self.messageString = contentTextView.text;
                    timer=[NSTimer scheduledTimerWithTimeInterval:3
                                                           target:self
                                                         selector:@selector(GetOneMessage)
                                                         userInfo:nil
                                                          repeats:YES];
                    
                }
                
            }
                break;
            case 444:
            {
                
                if (errCode == 0 || errCode == 1)
                {
                    NSArray *list = [dict objectForKey:@"list"];
                    MessageModel *messageModel = nil;
                    if (list.count!=0)
                    {
                        messageModel = [[MessageModel alloc] initWithDataDict:[list objectAtIndex:0]];
                        lastTimeMessageID=messageModel.mId;
                    }
                    NSMutableArray *newArray=[NSMutableArray array];
                    int count;
                    BOOL result;
                    CacheSql *cacheSql = [[CacheSql alloc] init];
                    if (list.count!=0)
                    {
                        for (NSDictionary *dict in list)
                        {
                            messageModel = [[MessageModel alloc] initWithDataDict:dict];
                            
                            [newArray addObject:messageModel];
                            
                            //判断是否要插入倒数据库
                            count=[cacheSql ifHasMessageID:messageModel.mId];
                            if (count==0)
                            {
                                result=[cacheSql itemAdd:messageModel];
                            }
                        }
                        
                        
                    }
                    [self displayData:newArray Type:2];
                    
                }
                else
                {
                    [self getCacheDataByID:lastTimeMessageID];
                    
                    
                }
                
            }
                break;
            case 555:
            {
                if (errCode == 0 || errCode == 1)
                {
                    //                            isFirst=YES;
                    //                          [self reloadRefreshDataSource:0];
                    [self Get20MessageList];
                    
                }
                
            }
                break;
                
            default:
                break;
        }
        
        
    }
}


//显示数据
-(void)displayData:(NSMutableArray*)data Type:(int)type
{
    if (type==1)
    {
        for (MessageModel *messageModel in data)
        {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *destDate= [dateFormatter dateFromString:messageModel.createdDate];
            
            
            [self.chatArray addObject:destDate];
            
            if([messageModel.userId isEqualToString:[UserDefaultsHelper getStringForKey:@"userId"]])
            {
                UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",messageModel.content] from:YES Object:messageModel];
                
                [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:messageModel.mId, @"messageID", messageModel.userId, @"speaker", chatView, @"view", nil]];
            }
            else
            {
                UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",messageModel.content] from:NO Object:messageModel];
                
                [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:messageModel.mId, @"messageID", messageModel.userId, @"speaker", chatView, @"view", nil]];
            }
        }
        
        [mTableView reloadData];
        
        //一进来tableview显示就在最下面
        if(!self.chatArray.count==0)
        {
            [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:YES];
        }
        
        sendCommentBtn.enabled=YES;
    }
    else
    {
        NSMutableArray *newArray=[NSMutableArray array];
        for (MessageModel *messageModel in data)
        {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *destDate= [dateFormatter dateFromString:messageModel.createdDate];
            
            
            [self.chatArray addObject:destDate];
            
            if([messageModel.userId isEqualToString:[UserDefaultsHelper getStringForKey:@"userId"]])
            {
                UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",messageModel.content] from:YES Object:messageModel];
                
                [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:messageModel.mId, @"messageID", messageModel.userId, @"speaker", chatView, @"view", nil]];
            }
            else
            {
                UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",messageModel.content] from:NO Object:messageModel];
                
                [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:messageModel.mId, @"messageID", messageModel.userId, @"speaker", chatView, @"view", nil]];
            }
        }
        [newArray addObjectsFromArray:self.chatArray];
        
        self.chatArray=newArray;
        
        [mTableView reload:0];
    }
    
    
    
    
}

-(void)getCacheData:(int)num
{
    
    //获取离线最新显示
    CacheSql *cacheSql=[[CacheSql alloc]init];
    NSMutableArray *returnsAr=[NSMutableArray array];
    NSMutableArray *BydateArr=[NSMutableArray array];
    MessageModel *model=[[MessageModel alloc]init];
    returnsAr=[cacheSql getNewMessage:num];
    if (returnsAr.count>0)
    {
        //为1条时正常显示，大于1条倒序显示
        if (returnsAr.count==1)
        {
            [self displayData:returnsAr Type:1];
            model=[returnsAr objectAtIndex:0];
            lastTimeMessageID=model.mId;
            
        }
        else
        {
            
            BydateArr = (NSMutableArray *)[[returnsAr reverseObjectEnumerator] allObjects];
            [self displayData:BydateArr Type:1];
            
            model=[BydateArr objectAtIndex:0];
            lastTimeMessageID=model.mId;
            
        }
    }
    
}
-(void)getCacheDataByID:(NSString*)messageID
{
    
    //获取离线最新显示
    CacheSql *cacheSql=[[CacheSql alloc]init];
    NSMutableArray *returnsAr=[NSMutableArray array];
    NSMutableArray *BydateArr=[NSMutableArray array];
    MessageModel *model=[[MessageModel alloc]init];
    returnsAr=[cacheSql getHisMessageByID:messageID];
    if (returnsAr.count>0)
    {
        //为1条时正常显示，大于1条倒序显示
        if (returnsAr.count==1)
        {
            [self displayData:returnsAr Type:2];
            model=[returnsAr objectAtIndex:0];
            lastTimeMessageID=model.mId;
            
        }
        else
        {
            BydateArr = (NSMutableArray *)[[returnsAr reverseObjectEnumerator] allObjects];
            [self displayData:BydateArr Type:2];
            
            model=[BydateArr objectAtIndex:0];
            lastTimeMessageID=model.mId;
            
        }
    }
    
}





- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    switch (request.tag)
    {
        case 111:
        {
            //失败则取数据库最新20条
            [self.chatArray removeAllObjects];
            [self getCacheData:20];
        }
            break;
            
        case 222:
        {
            //失败后停止线程
            [timer invalidate];
            timer=nil;
        }
            break;
            
        case 333:
        {
            //发送失败
        }
            break;
            
        case 444:
        {
            if (lastTimeMessageID!=nil)
            {
                [self getCacheDataByID:lastTimeMessageID];
            }
            
        }
            break;
            
        default:
            break;
    }
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
#ifdef IMPORT_LETUIM_H
//    [[LeTuIM sharedInstance] setMessageDelegate:self];
#else
    [timer invalidate];
    timer=nil;
#endif
}




/*
 生成泡泡UIView
 */
#pragma mark -
#pragma mark Table view methods
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf Object:(MessageModel*)topic
{
    
    
    
    
    
	// build single chat bubble cell with given text
    //    UIView *returnView =  [self assembleMessageAtIndex:text from:fromSelf];
    
#ifdef IMPORT_LETUIM_H
    UIView *returnView=[NSString assembleMessageAtIndex:topic.content];
#else
    UIView *returnView=[FaceUtil assembleMessageAtIndex:topic.content];
#endif
    
    
    returnView.backgroundColor = [UIColor clearColor];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    
    cellView.backgroundColor = [UIColor clearColor];
    
    cellView.userInteractionEnabled=YES;
    
    
    
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleright":@"bubbleleft" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    bubbleImageView.backgroundColor=[UIColor clearColor];
    
    bubbleImageView.userInteractionEnabled=YES;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPressGesture:)];
    [recognizer setMinimumPressDuration:0.4f];
    
    
    
    //内容
    UILabel *valuelab=[[UILabel alloc]init];
    valuelab.text=topic.content;
    [valuelab setTag:1];
    valuelab.hidden=YES;
    [bubbleImageView addSubview:valuelab];
    
    //id
#ifdef IMPORT_LETUIM_H
    JSIdentityLabel *idlab = [[JSIdentityLabel alloc] init];
    idlab.identity = topic.identity;
#else
    UILabel *idlab=[[UILabel alloc]init];
#endif
    idlab.text=topic.mId;
    [idlab setTag:2];
    idlab.hidden=YES;
    [bubbleImageView addSubview:idlab];
    
    
    
    [bubbleImageView addGestureRecognizer:recognizer];
    
    
    
    if (fromSelf==YES)
    {
        bubbleImageView.tag=1;
    }
    else
    {
        bubbleImageView.tag=2;
        
    }
    
    
    //头像
    EGOImageView *headImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"weibo_moren"]];
#ifdef IMPORT_LETUIM_H
    headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImageView:)];
    [headImageView addGestureRecognizer:tapGestureRecognizer];
#endif
    //昵称
    
    UILabel *titleLabel=[[UILabel alloc]init];
    
    //本人发的
    if(fromSelf)
    {
        
        
        
        //文字+表情时候的样式
        if ([topic.msgType isEqualToString:@"1"])
        {
            
            returnView.frame= CGRectMake(15.0f, 17.f +11, returnView.frame.size.width, returnView.frame.size.height);
            bubbleImageView.frame = CGRectMake(5.0f, 10.0f +8, returnView.frame.size.width+30.0f, returnView.frame.size.height+30.0f +10);
            cellView.frame = CGRectMake(275.0f-bubbleImageView.frame.size.width, 0.0f +3,bubbleImageView.frame.size.width+50.0f, bubbleImageView.frame.size.height+30.0f);
            headImageView.frame = CGRectMake(bubbleImageView.frame.size.width+6, cellView.frame.size.height-50.0f, 37, 37);
            
            
            
            headImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[topic userPhoto]]];
            if ([topic userPhoto]==nil||[[topic userPhoto]isEqualToString:@""])
            {
                [headImageView setImage:[UIImage imageNamed:@"weibo_moren"]];
            }
            
            [cellView addSubview:bubbleImageView];
            [cellView addSubview:returnView];
            
            
            
            
        }
        //图片时候的样式
        else  if ([topic.msgType isEqualToString:@"2"]||[topic.msgType isEqualToString:@"3"])
        {
            
            
            UIImageView *ContentImageBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubbleWhiteRight"]]; //[UIImage imageNamed:@"bubbleLeft"]];
            ContentImageBgView.frame=CGRectMake(10, 15, 218/2, 248/2);
            ContentImageBgView.userInteractionEnabled=YES;
#ifdef IMPORT_LETUIM_H
//            EGOImageButton  *contentImageView = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"wb_send_pic_bg"]];
//            contentImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERIMAGEURL, topic.mediaFile]];
            
            ContentImageBgView.tag = 11;
            [ContentImageBgView addSubview:idlab];
            [ContentImageBgView addGestureRecognizer:recognizer];
            
            NSString *imagePath = [NSString stringWithFormat:@"%@%@", SERVERIMAGEURL, topic.mediaFile];
            LeTuSourceImageView *contentImageView = [[LeTuSourceImageView alloc] initWithPhotoPath:imagePath placeholderImage:[UIImage imageNamed:@"wb_send_pic_bg"]];
#else
            EGOImageButton  *contentImageView = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"wb_send_pic_bg"]];
            contentImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[topic mediaFile]]];
            
            [contentImageView addTarget:self action:@selector(showBigImgEvent:) forControlEvents:UIControlEventTouchUpInside];
#endif
            
            contentImageView.frame=CGRectMake(14/2 -4, 13/2 -3, 180/2 +6.5, 222/2 +7);
            
            cellView.frame = CGRectMake(253-218/2 +13, 0.0f, ContentImageBgView.frame.size.width+30.0f,ContentImageBgView.frame.size.height+30.0f);
            
            
            [cellView addSubview:ContentImageBgView];
            [ContentImageBgView addSubview:contentImageView];
            
            headImageView.frame = CGRectMake(ContentImageBgView.frame.size.width+15, cellView.frame.size.height-150, 37, 37);
            
            headImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[topic userPhoto]]];
            if ([topic userPhoto]==nil||[[topic userPhoto]isEqualToString:@""])
            {
                [headImageView setImage:[UIImage imageNamed:@"weibo_moren"]];
            }
            
            
            
        }
        
        
        
        CGRect frame = cellView.frame;
        frame.origin.x -= 4;
        cellView.frame = frame;

    }
    //其他人发的
	else
    {
        
        
        
        
        //文字+表情时候的样式
        if([topic.msgType isEqualToString:@"1"])
        {
            returnView.frame= CGRectMake(60.0f, 17.0f +7, returnView.frame.size.width, returnView.frame.size.height);
            bubbleImageView.frame = CGRectMake(45.0f, 10.0f +5, returnView.frame.size.width+30.0f, returnView.frame.size.height+30.0f +10);
            cellView.frame = CGRectMake(0.0f, 0.0f +3, bubbleImageView.frame.size.width+30.0f,bubbleImageView.frame.size.height+30.0f);
            headImageView.frame = CGRectMake(5.0f, cellView.frame.size.height-55, 37, 37);
            
            
            
            headImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[topic userPhoto]]];
            if ([topic userPhoto]==nil||[[topic userPhoto]isEqualToString:@""])
            {
                [headImageView setImage:[UIImage imageNamed:@"weibo_moren"]];
            }
            //群组消息的时候才显示发送人名字
            if ([topic.targetType isEqualToString:@"2"])
            {
                UIImageView *nameImageView = [[UIImageView alloc] init];
                [nameImageView setImage:[UIImage imageNamed:@"wb_name_bg"]];
                nameImageView.frame = CGRectMake(10.0f, cellView.frame.size.height-15, 74/2, 28/2);
                [cellView addSubview:nameImageView];
                
                [titleLabel setFrame:CGRectMake(0, 0, 37, 14)];
                titleLabel.text=topic.userName;
                titleLabel.textColor=[Utility colorWithHexString:@"#ffffff"];
                titleLabel.font = [UIFont systemFontOfSize:11];
                titleLabel.textAlignment = UITextAlignmentLeft;
                titleLabel.backgroundColor=[UIColor clearColor];
                [nameImageView addSubview:titleLabel];
                
            }
            [cellView addSubview:bubbleImageView];
            [cellView addSubview:returnView];
            
            
            
        }
        //图片时候的样式
        else  if ([topic.msgType isEqualToString:@"2"]||[topic.msgType isEqualToString:@"3"])
        {
            
            UIImageView *ContentImageBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubbleBlueLeft"]]; //[UIImage imageNamed:@"wb_pic_frame_bg"]];
            ContentImageBgView.frame=CGRectMake(50, 15, 218/2, 248/2);
            ContentImageBgView.userInteractionEnabled=YES;
            
#ifdef IMPORT_LETUIM_H
            //            EGOImageButton  *contentImageView = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"wb_send_pic_bg"]];
            //            contentImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERIMAGEURL, topic.mediaFile]];
            
            ContentImageBgView.tag = 22;
            [ContentImageBgView addSubview:idlab];
            [ContentImageBgView addGestureRecognizer:recognizer];
            
            NSString *imagePath = [NSString stringWithFormat:@"%@%@", SERVERIMAGEURL, topic.mediaFile];
            LeTuSourceImageView *contentImageView = [[LeTuSourceImageView alloc] initWithPhotoPath:imagePath placeholderImage:[UIImage imageNamed:@"wb_send_pic_bg"]];
#else
            EGOImageButton  *contentImageView = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"wb_send_pic_bg"]];
            contentImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[topic mediaFile]]];
            
            [contentImageView addTarget:self action:@selector(showBigImgEvent:) forControlEvents:UIControlEventTouchUpInside];
#endif
//            EGOImageButton *contentImageView = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"wb_send_pic_bg"]];
            contentImageView.frame=CGRectMake(25/2 -3, 11/2 -2, 180/2 +7.5, 222/2 +7);
//#ifdef IMPORT_LETUIM_H
//            contentImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERIMAGEURL, topic.mediaFile]];
//#else
//            contentImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[topic mediaFile]]];
//#endif
//            [contentImageView addTarget:self action:@selector(showBigImgEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            cellView.frame = CGRectMake(0.0f, 0.0f, ContentImageBgView.frame.size.width+30.0f,ContentImageBgView.frame.size.height+30.0f);
            
            
            
            [cellView addSubview:ContentImageBgView];
            [ContentImageBgView addSubview:contentImageView];
            
            headImageView.frame = CGRectMake(10.0f, cellView.frame.size.height-155, 37, 37);
            
            headImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[topic userPhoto]]];
            if ([topic userPhoto]==nil||[[topic userPhoto]isEqualToString:@""])
            {
                [headImageView setImage:[UIImage imageNamed:@"weibo_moren"]];
            }
            
            
            //群组消息的时候才显示发送人名字
            if ([topic.targetType isEqualToString:@"2"])
            {
                UIImageView *nameImageView = [[UIImageView alloc] init];
                [nameImageView setImage:[UIImage imageNamed:@"wb_name_bg"]];
                nameImageView.frame = CGRectMake(10.0f, cellView.frame.size.height-115, 74/2, 28/2);
                [cellView addSubview:nameImageView];
                
                [titleLabel setFrame:CGRectMake(0, 0, 37, 14)];
                titleLabel.text=topic.userName;
                titleLabel.textColor=[Utility colorWithHexString:@"#ffffff"];
                titleLabel.font = [UIFont systemFontOfSize:11];
                titleLabel.textAlignment = UITextAlignmentLeft;
                titleLabel.backgroundColor=[UIColor clearColor];
                [nameImageView addSubview:titleLabel];
                
            }
            
            
            
            CGRect frame = cellView.frame;
            frame.origin.x -= 4;
            cellView.frame = frame;

        }
        
        
    }
    [cellView addSubview:headImageView];
    
    cellView.backgroundColor=[UIColor clearColor];
	return cellView;
    
}

/**
 * 图片放大事件
 */
- (void)showBigImgEvent:(UIButton *)button
{
    if (showBigImgView != nil)
    {
        [showBigImgView removeFromSuperview];
    }
    showBigImgView = [[ShowBigImageView alloc] init];
    [self.view addSubview:showBigImgView];
    showBigImgView.image = button.imageView.image;
    showBigImgView.isAddBottomBar = YES;
    
    CGSize screenRect = [[UIScreen mainScreen] bounds].size;
    [showBigImgView showAnimationsWithOrigin:CGPointMake(screenRect.width / 2, screenRect.height / 2)];
}


#pragma mark -
#pragma mark Table View DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chatArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([[self.chatArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]])
    {
		return 30;
        
	}
    else
    {
		UIView *chatView = [[self.chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
        returnViewH= chatView.frame.size.height+10;
		return chatView.frame.size.height+10;
        
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CommentCellIdentifier = @"CommentCell";
	ChatCustomCell *cell = (ChatCustomCell*)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCustomCell" owner:self options:nil] lastObject];
	}
	
	if ([[self.chatArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]])
    {
		// 日期cell
		NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:[self.chatArray objectAtIndex:[indexPath row]]]];
        
        [cell.dateLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"message2_datebox"]]];
        cell.dateLabel.font = [UIFont fontWithName:@"Arial" size:11];
        cell.dateLabel.textColor=[Utility colorWithHexString:@"#ffffff"];
		[cell.dateLabel setText:timeString];
		
        
	}
    else
    {
		// 泡泡uiview
		NSDictionary *chatInfo = [self.chatArray objectAtIndex:[indexPath row]];
		UIView *chatView = [chatInfo objectForKey:@"view"];
        chatView.userInteractionEnabled=YES;
        cell.contentView.userInteractionEnabled=YES;
		[cell.contentView addSubview:chatView];
	}
    cell.backgroundColor=[UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




- (TableView *) getTableView
{
    return mTableView;
}
//开始移动
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)sv
{
    
    
    TableView *tb = [self getTableView];
    if (tb)
    {
        [tb scrollViewWillBeginDecelerating:sv];
    }
    if ([contentTextView.textView isFirstResponder])
    {
        
        [contentTextView.textView resignFirstResponder];
    }
    else
    {
        if (faceView.isShow)
        {
            [faceView dismiss];
        }
        CGRect appframe = [[UIScreen mainScreen ] applicationFrame];
        [inputView setFrame:CGRectMake(0, appframe.size.height, 320,217)];
        [utilityBtn setImage:normalMsgImg forState:UIControlStateNormal];
        [utilityBtn setImage:actMsgImg forState:UIControlStateHighlighted];
        [self keyboardWillHide:nil];
    }
    
    
    
    
}

//下拉table
- (void)scrollViewDidScroll:(UIScrollView *)sv
{
    TableView *tb = [self getTableView];
    if (tb)
    {
        [tb scrollViewDidScroll:sv];
    }
    
    
}

//刷新table  当scrollView 停止滚动拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate{
    TableView *tb = [self getTableView];
    
    if (tb)
    {
        [tb scrollViewDidEndDragging:sv];
    }
    
}


- (void)reloadRefreshDataSource:(int)pageIndex
{
    if (isFirst==YES)
    {
        [mTableView reload:0];
        return;
    }
    else
    {
        //没有网络获取数据库缓存的历史数据
        if(![Utility connectedToNetwork])
        {
            
            if (lastTimeMessageID!=nil)
            {
                [self getCacheDataByID:lastTimeMessageID];
            }
            else
            {
                [self getCacheData:20];
            }
            
            
        }
        //有网络时获取历史20条数据
        else
        {
            if(lastTimeMessageID!=nil)
            {
                [self GetMoreMessage:lastTimeMessageID];
                
            }
            else
            {
                [mTableView reload:0];
            }
            
        }
        
    }
}


#pragma mark -
#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //	if(textField == contentTextView)
    //	{
    //
    //	}
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([contentTextView.textView isFirstResponder])
    {
        [contentTextView.textView resignFirstResponder];
        
    }
    else
    {
        if (faceView.isShow)
        {
            [faceView dismiss];
        }
        CGRect appframe = [[UIScreen mainScreen ] applicationFrame];
        [inputView setFrame:CGRectMake(0, appframe.size.height, 320,217)];
        [utilityBtn setImage:normalMsgImg forState:UIControlStateNormal];
        [utilityBtn setImage:actMsgImg forState:UIControlStateHighlighted];
        [self keyboardWillHide:nil];
    }
    
    return YES;
}


#pragma mark -
#pragma mark Responding to keyboard events
-(void) autoMovekeyBoard: (float) h{
    
    
    
    
    UIView *toolbar = (UIView *)[self.view viewWithTag:TOOLBARTAG];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    
    toolbar.frame = CGRectMake(0.0f, (float)(screenBounds.size.height-h-108+44-44), 320.0f, 50);
    [UIView commitAnimations];
    
    
}
#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification
{
#ifdef IMPORT_LETUIM_H
    // 隐藏其他面板
    if (faceView.isShow) {
        [faceView dismiss];
        [inputView setFrame:CGRectMake(0, [UIScreen mainScreenHeight]-44, 320,217)];
    }
#endif
    
    NSDictionary *userInfo = [notification userInfo];
    
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:keyboardRect.size.height];
    
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
    
    //判断键盘弹起时uitableview是否在最低
    CGPoint contentOffsetPoint = mTableView.contentOffset;
    CGRect frame = mTableView.frame;
    if (contentOffsetPoint.y == mTableView.contentSize.height - frame.size.height || mTableView.contentSize.height < frame.size.height)
    {
        isbottom=YES;
    }
    else
    {
        isbottom=NO;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
        int currentDeviceSystemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
        float naviHeight = (currentDeviceSystemVersion <7) ? 44 : 64;
        
        CGRect rect = mTableView.frame;
        rect.size.height = mainScreenBounds.size.height -naviHeight -52 -keyboardRect.size.height; // 52 toolbar height
        mTableView.frame = rect;
    }];
    
    if (isbottom && _chatArray.count >1) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_chatArray.count -1 inSection:0];
        [mTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
//    if(isKeyborardShow==NO)
//    {
//        CGPoint point = [tableView contentOffset];
////        [tableView setContentOffset:CGPointMake(0, point.y + 216) animated:YES];
//        [tableView setContentOffset:CGPointMake(0, point.y + keyboardRect.size.height) animated:YES];
//    }
//    isKeyborardShow=YES;
    
    
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:0];
    
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
    //	tableView.frame = CGRectMake(0.0f, tableView.frame.origin.y-h, 320.0f,(float)(480.0-h-108.0));
//    if(isKeyborardShow==YES)
//    {
//        CGPoint point = [tableView contentOffset];
//        [tableView setContentOffset:CGPointMake(0, point.y - keyboardRect.size.height) animated:YES];
//        
//    }
//    isKeyborardShow=NO;
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
        int currentDeviceSystemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
        float naviHeight = (currentDeviceSystemVersion <7) ? 44 : 64;
        
        CGRect rect = mTableView.frame;
        rect.size.height = mainScreenBounds.size.height -naviHeight -52; // 52 toolbar height
        mTableView.frame = rect;
    }];
}


#pragma mark - Copying

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(delete:) || action == @selector(copy:));
}
//复制文字
- (void)copy:(id)sender
{
    
    UILabel *valuelab;
    for(UIControl * v in selectView.subviews)
    {
        
        if([v isKindOfClass:[UILabel class]])
        {
            if (v.tag==1) {
                valuelab=(UILabel*)v;
            }
        }
    }
    
    [[UIPasteboard generalPasteboard] setString:[valuelab text]];
    [self resignFirstResponder];
}
//删除
- (void)delete:(id)sender
{
    UILabel *valuelab;
    for(UIControl * v in selectView.subviews)
    {
#ifdef IMPORT_LETUIM_H
        if([v isKindOfClass:[JSIdentityLabel class]])
        {
            if (v.tag==2) {
                JSIdentityLabel *valuelab=(JSIdentityLabel *)v;
                [LeTuMessage deleteMessageWithID:valuelab.identity];
                
                [self resignFirstResponder];
                break;
            }
        }
#else
        
        if([v isKindOfClass:[UILabel class]])
        {
            if (v.tag==2) {
                valuelab=(UILabel*)v;
            }
            
        }
#endif
    }
    
    [self resignFirstResponder];
    
    
    
    //没有网络
    if(![Utility connectedToNetwork])
    {
        
        //删除数据库
        CacheSql *cacheSql = [[CacheSql alloc] init];
        BOOL result=[cacheSql DelMessageByMsgID:valuelab.text];
        
        if (result)
        {
            //取数据库最新20条
            [self.chatArray removeAllObjects];
            [self getCacheData:20];
            
        }
        
        
        
    }
    //有网络时
    else
    {
        [self deleteMsg:valuelab.text];
    }
    
    
    
    
    
    
    
    
}





#pragma mark - Gestures

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    CGRect targetRect =[longPress.view frame];
    
    
    
    selectView=longPress.view;
    
    
    //    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:longPress.view.superview.superview];
    
    
    
    
    if(longPress.view.tag==1 || longPress.view.tag ==11)
    {
        targetRect.origin.x= 275.0f-targetRect.size.width;
        [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:longPress.view.superview.superview];
        
        
    }
    else
    {
        [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:longPress.view.superview.superview];
        
    }
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}




@end

