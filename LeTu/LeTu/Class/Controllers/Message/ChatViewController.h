
#import <UIKit/UIKit.h>
#import "FaceTextView.h"
#import "FaceView.h"
//#import "FaceViewController.h"
//#import "AsyncUdpSocket.h"
//#import "IPAddress.h"
#import "Utility.h"
#import "SyncRequestParseOperation.h"
#import "BaseViewController.h"
//#import "IIDate.h"
#import "TableView.h"
#import "ShowBigImageView.h"
#import "MessageModel.h"

#ifdef IMPORT_LETUIM_H
#import "LeTuIM.h"
#endif

@class BaseTabBarController;
@class ASIHTTPRequest;

@interface ChatViewController :BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UITableViewRefresh,ASIHTTPRequestDelegate,FaceTextViewDelegate,FaceViewDelegate>
{
	NSString            *_messageString;
	NSString                   *_phraseString;
	NSMutableArray		       *_chatArray;
	
	UITableView                *_chatTableView;
	UITextField                *messageTextField;
	BOOL                       _isFromNewSMS;
    //	FaceViewController      *_phraseViewController;
    //	AsyncUdpSocket             *_udpSocket;
	NSString                     *lastTimeMessageID;
    
    NSOperationQueue *queue;
    NSTimer *timer;
    
    
    TableView *mTableView;
    BOOL isKeyborardShow;
    
    
    
    int returnViewH;
    UIButton *sendCommentBtn;
    BOOL isFirst;
    BOOL SendingMessage;
    BOOL isbottom;
    //    BOOL gettingHistoryMessage;
    ShowBigImageView *showBigImgView;
    UIView *inputView;
    UIButton *utilityBtn;
    
    
    FaceTextView *contentTextView;
    
    FaceView *faceView;
    
    
    
    
    UIView *mContainer;
    
    
    UIView *selectView;
    
    UIImage *normalMsgImg;
    UIImage *actMsgImg;
    UIImage *normalTextImg;
    UIImage *actTextImg;
}
@property (nonatomic, retain) BaseTabBarController *basetempController;
//@property (nonatomic, retain) IBOutlet FaceViewController   *phraseViewController;
@property (nonatomic, retain)  UITableView            *chatTableView;
//@property (nonatomic, retain)  UITextField            *messageTextField;
@property (nonatomic, retain) NSString               *phraseString;
@property (nonatomic, retain) NSString               *titleString;
@property (nonatomic, retain) NSString        *messageString;
@property (nonatomic, retain) NSMutableArray		 *chatArray;

//@property (nonatomic, retain) NSDate                 *lastTime;
//@property (nonatomic, retain) AsyncUdpSocket         *udpSocket;

@property(nonatomic,strong)NSString *targetType;
@property(nonatomic,strong)NSString *targetId;

#ifdef IMPORT_LETUIM_H
@property(nonatomic,strong)LeTuUser *buddy;
@property(nonatomic,strong)NSString *chatWith;
@property(nonatomic)BOOL updateBuddyInfomation;
#endif

-(IBAction)sendMessage_Click:(id)sender;



-(void)sendMassage:(NSString *)message;

- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf;

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array;
-(UIView *)assembleMessageAtIndex : (NSString *) message from: (BOOL)fromself;

- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf Object:(MessageModel*)topic;

@end
