//
//  CBDAppDelegate.h
//  CBD
//
//  Created by Roland on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "UserDefaultsHelper.h"
#import "IIViewDeckController.h"
#import "LocationUtil.h"
#import "UserModel.h"
#import "DTNavigationController.h"
#import "DTTabBar.h"
#import "MainViewController.h"
#import "ApplyPersonModel.h"



@class TabBarController;
@class ScrollViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate,BMKGeneralDelegate,LocationUtilDelegate> {
    UIViewController *loginViewController;
    ScrollViewController *guideController;
    
    NSTimeInterval _backgroundRunningTimeInterval;
    BMKMapManager *_mapManager;
    LocationUtil *locationUtil;
}
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic,copy) NSString *locality;//城市
@property (nonatomic,copy) NSString *address;//地址
@property(nonatomic,copy)NSString * versionNumber;//版本号

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic,retain) DTNavigationController *navigation;
@property (nonatomic,retain) MainViewController *mainViewController;

@property (nonatomic,retain) DTTabBar *tabBar;

@property (nonatomic, retain) TabBarController *tabBarController;

@property (nonatomic, retain) NSString *sessionKey;

@property (nonatomic , strong) IIViewDeckController  *viewDeckController;

@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,strong) ApplyPersonModel* applyModel;

@property BOOL isNewUser;

-(void)checkNetworkMessage;

-(void)sessionKeyMessage;

- (void)logoutMessage;

-(void)showLoginView;
-(void)showMainView;

-(void)showTabView;

- (void)hideTabBar;

- (void)showTabBar;

- (void)currentTab:(int)currentIndex;

- (void)showGuideView;

- (void)updateMessage:(int)code;

+ (AppDelegate*) sharedAppDelegate;

@end
