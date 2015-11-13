//
//  BaseTabBar.h
//  CBD
//
//  Created by Roland on 12-7-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Utility.h"


@class TabBarController;

@protocol tabDelegate <NSObject>

@optional
- (void)clickTab:(int)currentIndex;
@end

@interface BaseTabBar : UIView {
    NSMutableArray *buttons;
    int currentSelectedIndex;
	UIImageView *slideBg;
	UIScrollView *tabBarScrollView;
    TabBarController *viewController;
    NSArray *tabImages;
    NSArray *tabActImages;
    id<tabDelegate> __unsafe_unretained _delegate;

    
}
@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic, assign) id<tabDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) TabBarController *viewController;
- (id)initWithBackgroundImage:(UIImage *)bgImage 
					ViewCount:(NSUInteger)count 
			   ViewController:(TabBarController *)vc;
- (id)initWithBackgroundImageForView:(UIImage *)bgImage
					ViewCount:(NSUInteger)count
			   ViewController:(UIViewController *)vc;
- (void)currentTab:(int)currentIndex;

@end
