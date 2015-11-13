//
//  TabBarController.h
//  CBD
//
//  Created by Roland on 12-6-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseTabBar.h"


@interface TabBarController : UITabBarController<tabDelegate> {
    BaseTabBar *tabBarView;
	BOOL firstTime;

}

@property (nonatomic, retain) BaseTabBar *tabBarView;
@property (nonatomic, assign) BOOL firstTime;

- (void)hideRealTabBar;

- (void)hideBaseTabBar:(BOOL)isHidden;

- (void)currentTab:(int)currentIndex;

@end

