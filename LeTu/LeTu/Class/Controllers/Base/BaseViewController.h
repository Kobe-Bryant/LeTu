//
//  BaseViewController.h
//  CBD
//
//  Created by Roland on 12-7-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SyncRequestParseOperation.h"
#import "iToast.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UserDefaultsHelper.h"
#import "RequestParseOperation.h"
#import "MessageModel.h"



@class ASIHTTPRequest;

//@interface BaseViewController : UIViewController <MBProgressHUDDelegate,ActivityDelegate,NotifyDelegate>{
@interface BaseViewController : UIViewController<MBProgressHUDDelegate>{
    
    //UIActivityIndicatorView *activity;
    MBProgressHUD *HUD;
    UIView *messageView;
    MessageModel *sysMessageModel;
    UIButton *backBtn;
    CGPoint startTouch;
    UIView *blankView;
    
}
@property(nonatomic,strong)AppDelegate *appDelegate;

-(void)messageShow:(NSString *) message;

-(void)startLoading;
-(void)stopLoading;

//-(void)showRemindMessage:(int)messageType;

-(void)responseNotify:( id )sender;

-( void )reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag;
-( void )reponseFaild:(NSInteger)tag;

- (void) setTitleImage:(UIImage *)titleImage andShowButton:(BOOL)show;

- (void) backPressed:(id) sender;

- (void)setTitle:(NSString *)title andShowButton:(BOOL)show;


/**
 *  导航栏右边按钮 -- 图片类型
 *
 *  @param normalImage      普通图片
 *  @param highlightedImage 高亮图片
 */
- (void)initRightBarButtonItem:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage;
/**
 *  导航栏右边按钮 -- 文字类型
 *
 *  @param text 按钮内容
 */
- (void)initRightBarButtonItem:(NSString*)text;
/**
 *  导航栏右边按钮点击事件
 *
 *  @param button
 */
- (void)clickRightButton:(UIButton*)button;

/**
 *  Toast提示框
 *
 *  @param msg 提示内容
 */
- (void)messageToast:(NSString*)msg;
@end
