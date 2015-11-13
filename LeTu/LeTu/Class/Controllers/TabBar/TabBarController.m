//
//  TabBarController.m
//  CBD
//
//  Created by Roland on 12-6-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"



@implementation TabBarController

@synthesize tabBarView;
@synthesize firstTime;

    

- (void)viewWillAppear:(BOOL)animated{
	//NSLog(@"%@", [self.viewControllers description]);
	[self hideRealTabBar];
	UIImage *bgImage = [UIImage imageNamed:@"letu_nav_bg"];
    if (tabBarView ==nil) {
        
	if (firstTime) {
		self.selectedIndex = 0;
        
		firstTime = NO;
	}
    tabBarView = [[BaseTabBar alloc] initWithBackgroundImage:bgImage
                                                   ViewCount:4
                                              ViewController:self];
    tabBarView.delegate=self;
	[self.view addSubview:tabBarView];
    
    [tabBarView currentTab:0];
    
	self.moreNavigationController.navigationBarHidden = YES;
    }
	[super viewWillAppear:animated];
   
}

- (void)viewDidLoad{
	[super viewDidLoad];
	firstTime = YES;
//    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidUnload{
	[super viewDidUnload];
	tabBarView = nil;
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}
- (void)hideBaseTabBar:(BOOL)isHidden{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UIScrollView class]] | [view isKindOfClass:[UIImageView class]]){
           // [view removeFromSuperview];
			view.hidden = isHidden;
			//break;
		}
	}
}
- (void)currentTab:(int)currentIndex
{
    [tabBarView currentTab:currentIndex];
    
}
- (void)clickTab:(int)currentIndex
{
    self.selectedIndex = currentIndex;
}

@end
