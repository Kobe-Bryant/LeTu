//#define IMPORT_LETUIM_H 1 //  #import "LeTuIM.h"

#ifdef IMPORT_LETUIM_H // |----->

#define DEBUG 0     // 测试模式

#define API_IP218 @"218.17.99.76"
#define API_IP183 @"183.232.68.203"
#define API_DOMAIN @"apps.wealift.com"
#define APIURL API_DOMAIN

#define SERVERURL [NSString stringWithFormat:@"http://%@:8082/", APIURL]
#define SERVERIMAGEURL [NSString stringWithFormat:@"http://%@:8082", APIURL]

/**
 BaiduMap AK
 cn.com.cyberway.LeTu     DLgpwG1ea1NYifID4R2HgIPA
 com.wealift.letu         N2fSK27z4HzRMx9eP3cOA4oU
 */
#define MAPAK @"DLgpwG1ea1NYifID4R2HgIPA"

#define APPLE_ITUNES_APPID @"904184904" // https://itunes.apple.com/us/app/da-yi-cheng/id904184904?l=zh&ls=1&mt=8

#endif // ----->|

//
//  Properties.h
//  CBD
//
//  Created by Roland on 12-6-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//p10.hotsale.com/
//test.cbdonephone.com/Classroom_Interface/api.aspx
//www.cbdonephone.com


#ifndef IMPORT_LETUIM_H // |----->
// 测试环境
//#define SERVERURL @"http://192.168.1.156:8082/"
//#define SERVERURL @"http://218.17.99.76:8082/"
//#define SERVERIMAGEURL @"http://218.17.99.76:8082"
//http://218.17.99.76:8083


//正式环境
//http://192.168.0.234:8891/

#define SERVERURL @"http://218.17.99.76:8083/"

#define SERVERIMAGEURL @"http://192.168.0.234:8891"

#define SERVERimageURL @"http://218.17.99.76:8083"


//#define SERVERURL @"http://192.168.0.124:8080/"
//#define SERVERIMAGEURL @"192.168.0.124:8080"

// 外网环境
//#define SERVERURL @"http://120.197.42.141:8891/"
//#define SERVERIMAGEURL @"http://120.197.42.141:8891"
//#define SERVERURL @"http://113.105.103.195:8083/"
#endif // ----->|

#define SERVERAPIURL [NSString stringWithFormat:@"%@%@", SERVERURL, @""]
#define SERVERImageURL SERVERIMAGEURL


#define INTERFACEURL    (![[UserDefaultsHelper getStringForKey:@"serviceURL"]isEqualToString:@""] ?[UserDefaultsHelper getStringForKey:@"serviceURL"]:@"http://218.17.99.76:8083")
/*
 #define SERVERURL  (![[UserDefaultsHelper getStringForKey:@"serviceURL"]isEqualToString:@""] ?[UserDefaultsHelper getStringForKey:@"serviceURL"]:@"http://192.168.0.233:6066")
 #define SERVERImageURL [NSString stringWithFormat:@"%@%@", SERVERAPIURL, @""]
 #define ApiUrl @""
 #define SERVERAPIURL (![[UserDefaultsHelper getStringForKey:@"serviceAPI"]isEqualToString:@""] ?[UserDefaultsHelper getStringForKey:@"serviceAPI"]:@"http://192.168.0.234:8891")
 //#define SERVERAPIURL @"http://192.168.0.233:6066/api.ashx"
 //*/

#define DOWNLOADURL @""

#define VERSIONNO @"1.0"

#define APPDELEGATE [(AppDelegate *)[[UIApplication sharedApplication]delegate]
#define ISCONNECT [(AppDelegate *)[[UIApplication sharedApplication]delegate] checkNetworkMessage];
#define ISSESSIONKEY [(AppDelegate *)[[UIApplication sharedApplication]delegate] sessionKeyMessage];
#define LOGOUTMESSAGE [(AppDelegate *)[[UIApplication sharedApplication]delegate] logoutMessage];
#define HIDETABBAR [(AppDelegate *)[[UIApplication sharedApplication]delegate] hideTabBar];
#define SHOWTABBAR [(AppDelegate *)[[UIApplication sharedApplication]delegate] showTabBar];
#define SHOWGUIDEVIEW [(AppDelegate *)[[UIApplication sharedApplication]delegate] showGuideView];
#define SHOWLOGINVIEW [(AppDelegate *)[[UIApplication sharedApplication]delegate] showLoginView];
#define SHOWMAPVIEW [(AppDelegate *)[[UIApplication sharedApplication]delegate] showMapView];
#define SHOWTABVIEW [(AppDelegate *)[[UIApplication sharedApplication]delegate] showTabView];
#define UPDATEMESSAGE [(AppDelegate *)[[UIApplication sharedApplication]delegate] updateMessage];
#define kTextViewPadding            26.0
#define kLineBreakMode              UILineBreakModeWordWrap
//#if DEBUG
//#define MCRelease(x) [x release]
//#else
#define MCRelease(x) [x release], x = nil
//#endif

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define FRAME_WIDTH self.view.frame.size.width
#define STATUSBAR_HEIGHT 20
#define TABBAR_HEIGHT 49
#define NAVBAR_HEIGHT 44


#define COMPRESSION_QUALITY 0.1

#define PLACEHOLDER [UIImage imageNamed:@"meDefaultPhoto60x60.png"]

#define isIOS7 [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0
#ifndef IMPORT_LETUIM_H // |----->
#define MAPAK @"DLgpwG1ea1NYifID4R2HgIPA"
#endif  // ----->|
#define SERVERAK @"7HCwqQErsqjbVpNbiG9VtYtK"

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;



