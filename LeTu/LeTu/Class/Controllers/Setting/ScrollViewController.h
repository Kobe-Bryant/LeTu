//
//  ScrollViewController.h
//  E-learning
//
//  Created by CarryRee on 13-7-26.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ScrollViewController : BaseViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}

@property (nonatomic, assign) int modelFrom;

@end
